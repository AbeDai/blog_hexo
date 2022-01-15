---
title: Flutter - pubspec.yaml 规则介绍
date: 2022-01-15 17:12:43
categories: 客户端
---

### 简介

##### pubspec.yaml 文件

当我们新建一个 Flutter Project 的时候，我们通常会有如下的文件树：

```shell
.
├── README.md
├── android
├── ios
├── lib
├── pubspec.lock
├── pubspec.yaml
├── test
└── web
```

但是pubspec.yaml文件里面到底是什么？让我们检查一下：

```yaml
# General Section (Metadata)
name: fantastic_app
description: A fantastic app that does amazing things!
version: 1.0.0+1

# Environment
environment:
  sdk: ">=2.7.0 <3.0.0"
  
# Publish pub.dev
publish_to: 'none'

# Dependencies
dependencies:
  flutter:
    sdk: flutter

  flutter_bloc: ^6.0.6
  dio: ^3.0.10
  cupertino_icons: ^1.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter

# Flutter specific configurations
flutter:
  uses-material-design: true
```

如我们所见，该pubspec.yaml文件分为不同的部分，让我们深入研究每一部分。

### 规则详解

##### name 字段

在文件的顶部，我们看到`name`. 此字段指示包名称，以及我们将如何在此项目中或从此项目导入文件。例如，如果在一个文件中我们要导入`main.dart`函数，则导入如下：

```dart
import 'package:fantastic_app/main.dart';
```

但是，如果将来我们将`name`字段更改为`weather_app_prototype`，我们必须确保将所有导入从 更改`fantastic_app`为`weather_app_prototype`，这意味着我们的`main.dart`导入将如下所示：

```dart
import 'package:weather_app_prototype/main.dart';
```

##### description 字段

`description`顾名思义，该字段是一个可选字段，可让我们为我们的项目添加一个简短的描述。如果我们正在创建一个`library`，那么如果我们决定在`pub.dev`上发布我们的包，那么每个人都可以看到这个描述，例如对于`shared_preferences`，我们有以下描述：“用于读取和写入简单键值对的 Flutter 插件。在 iOS 上包装 NSUserDefaults，在 Android 上包装 SharedPreferences。” 并且，如果我们在`pub.dev`搜索“shared_preferences” ，我们可以在结果列表中看到描述：

![c63b568efa73cf00ab59631247a88348](/image/C7B337CA-625C-469D-B561-C0D4D981050E.png)

##### version 字段

参数version将允许我们向应用程序或库添加语义版本控制。对于移动应用程序，这将是出现在`Google Play`商店和`iOS App Store`中的版本。带有`version`的`Flutter`应用程序`1.2.3+4`意味着它是`1.2.3`带有`build version`的版本`4`。

`Android`工程中的使用方式如下：

![6dea744f4ca96cdb8b8476fe52cebd4e.png](/image/7941642238147_.pic.jpg)

另一方面，如果我们正在创建`library`，版本控制将使任何用户能够指定他们想要使用哪个版本的库，让他们决定是否使用`shared_preferences: 0.5.12+2`或`shared_preferences: 0.1.0`。

##### author、homepage、repository 等字段

如果我们创建了一个`library`项目，还有额外的可选字段，允许我们给我们的包，具体的信息越多`author`，`homepage`，`repository`，`issue_tracker` 分别表示：

- author：作者，填写自己的署名
- homepage：主页
- repository：一般写当前插件源代码的Github地址
- issue_tracker：issue，一般写当前插件源代码的Github issue 地址

##### environment 字段

这个字段允许我们对`Dart SDK`和`Flutter Version`都添加约束。

```dart
environment:
  sdk: ">=2.7.0 <3.0.0"
  flutter: "1.22.0"
```

这个应用程序或库将只在`SDK`版本上运行高于或等于比`2.7.0`，但低比`3.0.0`。我们不关心它当前使用的是哪个特定版本，只关心它保持在这些界限之间。

如果我们使用`Flutter`版本的`1.22.0`。如果我们尝试通过`flutter pub get`使用任何其他`Flutter`版本获取我们的包，将会报错。

##### publish_to 字段

此属性意为包发布到哪里去，`none`表示此包不发布，也可以指定发布的服务器，根据注释可以看到，如果删除此项配置，那么默认发布到`pub.dev`。

##### dependencies、dev_dependencies 字段

`dependencies`和`dev_dependencies`下包含应用程序所依赖的包，`dependencies`和`dev_dependencies`就像其名字一样，`dependencies`下的所有依赖会编译到项目中，而`dev_dependencies`仅仅是运行期间的包，比如自动生成代码的库。

支持以下四种依赖方式：

- 从依赖包 托管 在pub.dev
- 来自路径目录的依赖
- 来自git存储库的依赖
- 来自自定义发布服务器的依赖

```yaml
# 从依赖包 托管 在pub.dev
dependencies:
  bloc: ^6.1.0

# 来自路径目录的依赖
# 文件目录
# .
# ├── example
# └── bloc_fixes_issue_110
dependencies:
  bloc:
    path: ../bloc_fixes_issue_110

# 来自git存储库的依赖
dependencies:
  bloc:
    git:
      url: https://github.com/felangel/bloc.git
      ref: bloc_fixes_issue_110
      path: packages/bloc

# 来自自定义发布服务器的依赖
dependencies:
  bloc: 
    hosted:
      name: bloc
      url: http://your-package-server.com
    version: ^6.0.0
```

##### dependency_overrides 字段

我们使用`bloc`带有`version的包6.0.0`，但同时我们依赖另一个使用`version` 的包`5.0.0`。如果我们尝试获取应用程序的依赖项，则会收到以下错误：

```shell
Because main_app depends on package from path which depends on flutter_bloc 5.0.0, flutter_bloc 5.0.0 is required.
So, because main_app depends on flutter_bloc 6.0.0, version solving failed.
Running "flutter pub get" in main_app...                                
pub get failed (1; So, because main_app depends on flutter_bloc 6.0.0, version solving failed.)
```

如果我们不能增加库的版本，或者只是想测试应用程序，我们该怎么做？通过使用`dependency_overrides`以下方法覆盖依赖项：

```yaml
dependencies:
  flutter_bloc: 6.0.0

  # Library called "package"
  package:
    path: ../package

dependency_overrides:
  flutter_bloc: 6.0.6
```

我们`package`使用的是`flutter_blocversion 5.0.0`，我们的应用程序使用的是`version 6.0.0`。但是，我们需要使用`version`运行我们的应用程序`6.0.6`，因此我们覆盖了依赖项。通过这样做，当`pubspec`编译所有依赖项的列表时，它将使用`version 6.0.6`。

##### Flutter 特定配置

这是我们拥有所有Flutter 特定配置的地方。可以设置设计风格、图片资源、字体、插件等。

```yaml
flutter: 
  uses-material-design: true # 是否启动 material design

  assets: # 资源
    - images/a_dot_burr.jpeg
    - images/a_dot_ham.jpeg

  fonts: # 字体
    - family: Schyler
      fonts:
        - asset: fonts/Schyler-Regular.ttf
        - asset: fonts/Schyler-Italic.ttf
          style: italic
    - family: Trajan Pro
      fonts:
        - asset: fonts/TrajanPro.ttf
        - asset: fonts/TrajanPro_Bold.ttf
          weight: 700
          
  plugin: # 插件
    platforms:
      android:
        package: io.flutter.plugins.connectivity
        pluginClass: ConnectivityPlugin
      ios:
        pluginClass: FLTConnectivityPlugin
      macos:
        default_package: connectivity_macos
      web:
        default_package: connectivity_for_web
```

### 参考

- https://news.sangniao.com/p/2414019247
- https://dart.dev/tools/pub/pubspec
