---
title: Android - MMKV 原理分析
date: 2021-10-07 21:20:30
categories: 客户端
---

### 对外API介绍

`MMVK` 的 `Java` 测代码非常简单。对标 `SharedPreferences` 接口，减少学习成本，方便业务替换。

```java
public class MMKV implements SharedPreferences, SharedPreferences.Editor {
    ...
}
```

`MMKV` 底层分为两部分，第一部分是 `native-bridge.cpp`，这里主要用来做`jni`透传。第二部分为 `mmkv` 的底层实现，这里才是真正的 `mmkv` 实现。

### 原理分析

#### MMAP 原理简介
`mmap`是一种内存映射文件的方法，即将一个文件或者其它对象映射到进程的地址空间，实现文件磁盘地址和进程虚拟地址空间中一段虚拟地址的一一对映关系。实现这样的映射关系后，进程就可以采用指针的方式读写操作这一段内存，而系统会自动回写脏页面到对应的文件磁盘上，即完成了对文件的操作而不必再调用`read`,`write`等系统调用函数。相反，内核空间对这段区域的修改也直接反映用户空间，从而可以实现不同进程间的文件共享。如下图所示：

![5bee22ac55ebd10a20fbf28d4693c69c](/image/7182C050-A26E-4240-BF68-B9F4554F3175.png)

由上图可以看出，进程的虚拟地址空间，由多个虚拟内存区域构成。虚拟内存区域是进程的虚拟地址空间中的一个同质区间，即具有同样特性的连续地址范围。上图中所示的text数据段（代码段）、初始数据段、BSS数据段、堆、栈和内存映射，都是一个独立的虚拟内存区域。而为内存映射服务的地址空间处在堆栈之间的空余部分。

##### `mmap` 和常规文件操作的区别
常规文件操作为了提高读写效率和保护磁盘，使用了页缓存机制。这样造成读文件时需要先将文件页从磁盘拷贝到页缓存中，由于页缓存处在内核空间，不能被用户进程直接寻址，所以还需要将页缓存中数据页再次拷贝到内存对应的用户空间中。写操作也是一样，待写入的 `buffer` 在内核空间不能直接访问，必须要先拷贝至内核空间对应的主存储器，再写回磁盘中（延迟写回），也是需要两次数据拷贝。

而使用 `mmap` 操作文件中，创建新的虚拟内存区域和建立文件磁盘地址和虚拟内存区域映射这两步，没有任何文件拷贝操作。而之后访问数据时发现内存中并无数据而发起的缺页异常过程，可以通过已经建立好的映射关系，只使用一次数据拷贝，就从磁盘中将数据传入内存的用户空间中，供进程使用。

#### `mmap` 使用细节
使用 `mmap` 需要注意的一个关键点是，`mmap` 映射区域大小必须是物理页大小(`page_size`)的整倍数（32位系统中通常是 4k 字节）。原因是，内存的最小粒度是页，而进程虚拟地址空间和内存的映射也是以页为单位。为了匹配内存的操作，`mmap` 从磁盘到虚拟地址空间的映射也必须是页。

#### MMKV 与 SP 性能对比

MMAP对文件的读写操作只需要从磁盘到用户主存的一次数据拷贝过程，减少了数据的拷贝次数，提高了文件读写效率。
MMAP使用逻辑内存对磁盘文件进行映射，操作内存就相当于操作文件，不需要开启线程，操作MMAP的速度和操作内存的速度一样快；
MMAP提供一段可供随时写入的内存块，App 只管往里面写数据，由操作系统如内存不足、进程退出等时候负责将内存回写到文件，不必担心 crash 导致数据丢失。

下面来对比一下SP可MMKV同事存储1000条数据的耗时：

![9b7ff9b6aeefddbbd5beb2376341af85](/image/2AB92370-4543-4F60-A3B7-098E7F4EA808.png)

![94ea594dec2d3dbbf8150c6a9ddc494c](/image/4C3733C2-C9C8-4AC7-B351-751F13031E87.png)

由此可见，MMKV的写入速度远超过了SP！这也是MMAP的优势所在。读取的时候两者都是在app初始化时将数据保存在了一个map中，从内存中读取，所以两者的读取速度是没什么分别的。

### MMKV 初始化

使用MMKV的时候需要调用MMKV.java中的初始化方法，最终都会调用到C++层的jniInitialize()方法，这个类就不多说了。

值得一提的是，每次操作数据时都是通过defaultMMKV来使用的，但是它最终new出来的一个新的对象：

```java
public static MMKV defaultMMKV() {
        if (rootDir == null) {
            throw new IllegalStateException("You should Call MMKV.initialize() first.");
        }
        long handle = getDefaultMMKV();
        return new MMKV(handle);
    }
```

最终都返回了一个新的实例。为什么不是单例呢？因为真正的mmkv对象是存放在C++层的，最后传递了一个handle参数，这个handle就是MMKV对象在内存中的地址（这个稍后看C源码可知，其实在C++层，是用了一个map来保存MMKV的，因为每次文件保存的路径可能不一样，所以不能使用单例）。拿到了这个地址引用以后，就可以把这个地址传递回C++层，在C++拿到MMKV的对象进行操作。

#### C++初始化与实例化

```c++
void MMKV::initializeMMKV(const std::string &rootDir) {
    static pthread_once_t once_control = PTHREAD_ONCE_INIT;
    pthread_once(&once_control, initialize);

    g_rootDir = rootDir;
    char *path = strdup(g_rootDir.c_str());
    if (path) {
        mkPath(path);
        free(path);
    }

    MMKVInfo("root dir: %s", g_rootDir.c_str());
}
```
可以看到，这里初始化其实只创建了一个目录，mkpath方法中创建了一个可读可写权限的文件夹。那么怎么获取实例呢? 源码中的defaultMMKV中调用返回了mmkvWithID（）函数

```c++
MMKV *MMKV::defaultMMKV(MMKVMode mode, string *cryptKey) {
    return mmkvWithID(DEFAULT_MMAP_ID, DEFAULT_MMAP_SIZE, mode, cryptKey);
}

MMKV *MMKV::mmkvWithID(
    const std::string &mmapID, int size, MMKVMode mode, string *cryptKey, string *relativePath) {

    if (mmapID.empty()) {
        return nullptr;
    }
    SCOPEDLOCK(g_instanceLock);
    // 根据mmapID获取mmkv在map中的key
    auto mmapKey = mmapedKVKey(mmapID, relativePath);
    // 从map集合中根据key查找MMKV实例
    auto itr = g_instanceDic->find(mmapKey);
    // 如果map中存在这个实例，就直接返回
    if (itr != g_instanceDic->end()) {
        MMKV *kv = itr->second;
        return kv;
    }
    // 省略一些不关键代码
    ...
   
    // 如果不存在，根据mmapID创建一个实例，并保存到map中，下次用直接从map中取到
    auto kv = new MMKV(mmapID, size, mode, cryptKey, relativePath);
    (*g_instanceDic)[mmapKey] = kv;
    return kv;
}
```

这个函数中传递了一个mmapID， 这个id如果其实相当于SharedPreference中的fileName参数，根据id保存到不同的文件中。获取实例时先判断g_instanceDic集合中是否存在实例，如果存在直接返回，否则创建完成MMKV之后放入g_instanceDic集合中。所以其实在C++层是做了单例处理的。具体细节都在上面注释。当然，获取实例的时候mmapID并不是必传的参数，C++已经为我们设置了一个默认值：

```c++
//默认的mmkv文件
#define DEFAULT_MMAP_ID "mmkv.default"
```

在MMKV的构造函数中，可以看到调用了一个loadFromFile函数，这个函数的主要作用就是在初始化的时候，读取MMKV文件，并放入map集合中。

```c++
void MMKV::loadFromFile() {
    // 省略不关键代码
    ... 
    // 打开MMKV文件
    m_fd = open(m_path.c_str(), O_RDWR | O_CREAT, S_IRWXU);
    if (m_fd < 0) {
        // 打开失败 
        MMKVError("fail to open:%s, %s", m_path.c_str(), strerror(errno));
    } else {
        // 获取文件大小
        m_size = 0;
        struct stat st = {0};
        if (fstat(m_fd, &st) != -1) {
            m_size = static_cast<size_t>(st.st_size);
        }
        // round up to (n * pagesize)
        if (m_size < DEFAULT_MMAP_SIZE || (m_size % DEFAULT_MMAP_SIZE != 0)) {
            size_t oldSize = m_size;
            m_size = ((m_size / DEFAULT_MMAP_SIZE) + 1) * DEFAULT_MMAP_SIZE;
            if (ftruncate(m_fd, m_size) != 0) {
                MMKVError("fail to truncate [%s] to size %zu, %s", m_mmapID.c_str(), m_size,
                          strerror(errno));
                m_size = static_cast<size_t>(st.st_size);
            }
            zeroFillFile(m_fd, oldSize, m_size - oldSize);
        }
        // 映射到内存
        m_ptr = (char *) mmap(nullptr, m_size, PROT_READ | PROT_WRITE, MAP_SHARED, m_fd, 0);
        if (m_ptr == MAP_FAILED) {
            MMKVError("fail to mmap [%s], %s", m_mmapID.c_str(), strerror(errno));
        } else {
            memcpy(&m_actualSize, m_ptr, Fixed32Size);
            MMKVInfo("loading [%s] with %zu size in total, file size is %zu, InterProcess %d",
                     m_mmapID.c_str(), m_actualSize, m_size, m_isInterProcess);
            bool loadFromFile = false, needFullWriteback = false;
            if (m_actualSize > 0) {
                if (m_actualSize < m_size && m_actualSize + Fixed32Size <= m_size) {
                    if (checkFileCRCValid()) {
                        loadFromFile = true;
                    } else {
                        auto strategic = mmkv::onMMKVCRCCheckFail(m_mmapID);
                        if (strategic == OnErrorRecover) {
                            loadFromFile = true;
                            needFullWriteback = true;
                        }
                    }
                } else {
                    auto strategic = mmkv::onMMKVFileLengthError(m_mmapID);
                    if (strategic == OnErrorRecover) {
                        writeAcutalSize(m_size - Fixed32Size);
                        loadFromFile = true;
                        needFullWriteback = true;
                    }
                }
            }
            if (loadFromFile) {
                MMKVInfo("loading [%s] with crc %u sequence %u version %u", m_mmapID.c_str(),
                         m_metaInfo.m_crcDigest, m_metaInfo.m_sequence, m_metaInfo.m_version);
                MMBuffer inputBuffer(m_ptr + Fixed32Size, m_actualSize, MMBufferNoCopy);
                if (m_crypter) {
                    decryptBuffer(*m_crypter, inputBuffer);
                }
                m_dic.clear();
                MiniPBCoder::decodeMap(m_dic, inputBuffer);
                m_output = new CodedOutputData(m_ptr + Fixed32Size + m_actualSize,
                                               m_size - Fixed32Size - m_actualSize);
                if (needFullWriteback) {
                    fullWriteback();
                }
            } else {
                SCOPEDLOCK(m_exclusiveProcessLock);

                if (m_actualSize > 0) {
                    writeAcutalSize(0);
                }
                m_output = new CodedOutputData(m_ptr + Fixed32Size, m_size - Fixed32Size);
                recaculateCRCDigest();
            }
            MMKVInfo("loaded [%s] with %zu values", m_mmapID.c_str(), m_dic.size());
        }
    }

    if (!isFileValid()) {
        MMKVWarning("[%s] file not valid", m_mmapID.c_str());
    }

    m_needLoadFromFile = false;
}
```

### MMKV 编码&写入

```c++
// 写入64位整型
void CodedOutputData::writeInt64(int64_t value) {
    this->writeRawVarint64(value);
}
// 写入32位整型，判断是否是正数，如果是正数使用32位编码，否则使用64位编码
void CodedOutputData::writeInt32(int32_t value) {
    if (value >= 0) {
        this->writeRawVarint32(value);
    } else {
        this->writeRawVarint64(value);
    }
}
// 写入32位整型
void CodedOutputData::writeRawVarint32(int32_t value) {
    while (true) {
        // 判断是否只有前7位是有效数据
        if ((value & ~0x7f) == 0) {
            // 如果是，直接写入文件
            this->writeRawByte(static_cast<uint8_t>(value));
            return;
        } else {
            // 否则取前7位，并在最高位补1.
            this->writeRawByte(static_cast<uint8_t>((value & 0x7F) | 0x80));
            // 将数据右移7位，继续判断
            value = logicalRightShift32(value, 7);
        }
    }
}
// 写入64位整型， 原理同上
void CodedOutputData::writeRawVarint64(int64_t value) {
    while (true) {
        if ((value & ~0x7f) == 0) {
            this->writeRawByte(static_cast<uint8_t>(value));
            return;
        } else {
            this->writeRawByte(static_cast<uint8_t>((value & 0x7f) | 0x80));
            value = logicalRightShift64(value, 7);
        }
    }
}
```

MMKV使用了一个游标去记录当前存入的位置，如果这个位置超过了文件的大小，就报错了，否则在m_ptr的下一位去插入这个数据。

```c++
void CodedOutputData::writeRawByte(uint8_t value) {
    //满啦，出错啦
    if (m_position == m_size) {
        MMKVError("m_position: %d, m_size: %zd", m_position, m_size);
        return;
    }
    //将byte放入数组
    m_ptr[m_position++] = value;
}
```

### MMKV 解码&读取

```c++
int32_t CodedInputData::readRawVarint32() {
    // 第一个字节
    int8_t tmp = this->readRawByte();
    if (tmp >= 0) {
        // 如果最高位是0，直接返回
        return tmp;
    }
    int32_t result = tmp & 0x7f;
    // 第二个字节
    if ((tmp = this->readRawByte()) >= 0) {
        // 拼接
        result |= tmp << 7;
    } else {
        // 拼接
        result |= (tmp & 0x7f) << 7;
        // 读取第三个字节
        if ((tmp = this->readRawByte()) >= 0) {
            // 拼接
            result |= tmp << 14;
        } else {
            // 拼接
            result |= (tmp & 0x7f) << 14;
            // 读取第4个字节
            if ((tmp = this->readRawByte()) >= 0) {
                result |= tmp << 21;
            } else {
                // 拼接
                result |= (tmp & 0x7f) << 21;
                // 读取第五个字节并拼接
                result |= (tmp = this->readRawByte()) << 28;
                if (tmp < 0) {
                    // discard upper 32 bits
                    for (int i = 0; i < 5; i++) {
                        // 32位以上。。。
                        if (this->readRawByte() >= 0) {
                            return result;
                        }
                    }
                    MMKVError("InvalidProtocolBuffer malformed varint32");
                }
            }
        }
    }
    return result;
}
```

首先从内存中读取这个数据，使用8位的int接收， 如果有效数据小于8位，占用一个字节，直接返回，这里都没问题。如果大于8位呢？

首先取出第一个字节，如果最高位是0 ，直接返回，否则继续读取，将第二个字节左移7位，或运算拼接到result前面，再判断最高位，以此读取。

### MMKV 数据存取

#### 数据存储
```c++
bool MMKV::setInt32(int32_t value, const std::string &key) {
    if (key.empty()) {
        return false;
    }
    size_t size = pbInt32Size(value);
    MMBuffer data(size);
    CodedOutputData output(data.getPtr(), size);
    output.writeInt32(value);
    // 最终调用setDataForKey进行存入数据
    return setDataForKey(std::move(data), key);
}

bool MMKV::setDataForKey(MMBuffer &&data, const std::string &key) {
    // 省略不关键代码，保证程序的健壮性。。。 
    ...
    // 这里是存数据逻辑
    auto ret = appendDataWithKey(data, key);
    if (ret) {
        m_dic[key] = std::move(data);
        m_hasFullWriteback = false;
    }
    return ret;
}

bool MMKV::appendDataWithKey(const MMBuffer &data, const std::string &key) {
    //计算保存这个key-value需要多少字节
    size_t keyLength = key.length();
    size_t size = keyLength + pbRawVarint32Size((int32_t) keyLength);
    size += data.length() + pbRawVarint32Size((int32_t) data.length());
    // 分配内存
    bool hasEnoughSize = ensureMemorySize(size);
    SCOPEDLOCK(m_exclusiveProcessLock);

    if (!hasEnoughSize || !isFileValid()) {
        return false;
    }

    // 写入数据
    writeAcutalSize(m_actualSize + size);
    m_output->writeString(key);
    m_output->writeData(data); // note: write size of data

    auto ptr = (uint8_t *) m_ptr + Fixed32Size + m_actualSize - size;
    if (m_crypter) {
        m_crypter->encrypt(ptr, ptr, size);
    }
    updateCRCDigest(ptr, size, KeepSequence);
    return true;
}

// 因为代码太多了，这里只展示了扩容相关
bool MMKV::ensureMemorySize(size_t newSize) {
    ...
    if (newSize >= m_output->spaceLeft() || m_dic.empty()) {
        ...
        } else {
            size_t avgItemSize = lenNeeded / std::max<size_t>(1, m_dic.size());
            size_t futureUsage = avgItemSize * std::max<size_t>(8, (m_dic.size() + 1) / 2);

            if (lenNeeded >= m_size || (lenNeeded + futureUsage) >= m_size) {
                size_t oldSize = m_size;
                do {
                    // 进行扩容，每次都是上一次大小的2倍
                    m_size *= 2;
                } while (lenNeeded + futureUsage >= m_size);  
                
                ...
    }
    return true;
}
```

#### 数据获取

```c++
int32_t MMKV::getInt32ForKey(const std::string &key, int32_t defaultValue) {
    if (key.empty()) { //如过key是空的，直接返回默认值
        return defaultValue;
    }
    SCOPEDLOCK(m_lock);
    // 根据 key 获取value
    auto &data = getDataForKey(key);
    if (data.length() > 0) {
        // 这就是上面讲到的读取的逻辑 
        CodedInputData input(data.getPtr(), data.length());
        return input.readInt32();
    }
    return defaultValue;
}
```

# 参考

- https://www.jianshu.com/p/181387155fd5
- https://www.jianshu.com/p/e9dfabc75bb2
- https://www.jianshu.com/p/665698f2fe14
- https://github.com/Tencent/MMKV/wiki/home_cn