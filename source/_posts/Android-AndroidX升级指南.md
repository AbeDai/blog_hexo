---
title: Android-AndroidX升级指南
date: 2019-10-14 18:12:42
categories: 客户端
---

## AndroidX 介绍

AndroidX 是 Android 团队用于在 Jetpack 中开发、测试、打包和发布库以及对其进行版本控制的开源项目。

AndroidX 对原始 Android [支持库](https://developer.android.com/topic/libraries/support-library/index) 进行了重大改进。与支持库一样，AndroidX 与 Android 操作系统分开提供，并与各个 Android 版本向后兼容。AndroidX 完全取代了支持库，不仅提供同等的功能，而且提供了新的库。此外，AndroidX 还包括以下功能：

- AndroidX 中的所有软件包都使用一致的命名空间，以字符串 androidx 开头。支持库软件包已映射到对应的 androidx.* 软件包。
- 与支持库不同，AndroidX 软件包会单独维护和更新。androidx 软件包使用严格的 [语义版本控制](https://semver.org/lang/zh-CN/) ，从版本 1.0.0 开始。您可以单独更新项目中的 AndroidX 库。
- 所有新支持库的开发工作都将在 AndroidX 库中进行。

## 如何在老项目中使用AndroidX

- 首先将所有主工程中依赖的support lib都改成androidX。并将相关引用代码，手动改为androidX的引用。

- 其次，修改当前项目的 gradle.properties文件，添加useAndroidX与enableJetifier字段。
    > android.useAndroidX=true：表示当前项目启用 AndroidX。
    > android.enableJetifier=true：表示将依赖包也迁移到AndroidX。如果取值为false，表示不迁移依赖包到AndroidX。

    ```groovy
    // 当前项目 gradle.properties
    android.useAndroidX=true
    android.enableJetifier=true
    ```

## 原理浅析

在gradle 3.2.1以上构建工具中，提供了enableJetifier字段，用于矫正support lib的引入方式。简单分析gradle构建过程，看看enableJetifier是怎么来矫正引入的。

#### 插入构建任务
```java
// VariantManager.kt

public void configureDependencies() {
        final DependencyHandler dependencies = project.getDependencies();

        // 参数校验
        if (!globalScope.getProjectOptions().get(BooleanOption.USE_ANDROID_X)
                && globalScope.getProjectOptions().get(BooleanOption.ENABLE_JETIFIER)) {
            throw new IllegalStateException(
                    "AndroidX must be enabled when Jetifier is enabled. To resolve, set "
                            + BooleanOption.USE_ANDROID_X.getPropertyName()
                            + "=true in your gradle.properties file.");
        }

        // 依赖关系替换
        if (globalScope.getProjectOptions().get(BooleanOption.ENABLE_JETIFIER)) {
            JetifyTransform.replaceOldSupportLibraries(project);
        }

        // 注册矫正器 
        dependencies.registerTransform(
                transform -> {
                    transform.getFrom().attribute(ARTIFACT_FORMAT, AAR.getType());
                    transform.getTo().attribute(ARTIFACT_FORMAT, TYPE_PROCESSED_AAR);
                    transform.artifactTransform(
                            globalScope.getProjectOptions().get(BooleanOption.ENABLE_JETIFIER)
                                    ? JetifyTransform.class
                                    : IdentityTransform.class);
                });
        dependencies.registerTransform(
                transform -> {
                    transform.getFrom().attribute(ARTIFACT_FORMAT, JAR.getType());
                    transform.getTo().attribute(ARTIFACT_FORMAT, PROCESSED_JAR.getType());
                    transform.artifactTransform(
                            globalScope.getProjectOptions().get(BooleanOption.ENABLE_JETIFIER)
                                    ? JetifyTransform.class
                                    : IdentityTransform.class);
                });
}
```

#### 构建任务执行逻辑
```java
// JetifyTransform.kt
class JetifyTransform @Inject constructor() : ArtifactTransform() {

    companion object {

        // 替换依赖库，将support lib依赖替换为androidX
        @JvmStatic
        fun replaceOldSupportLibraries(project: Project) {
            project.dependencies.components.all { component ->
                component.allVariants { variant ->
                    variant.withDependencies { metadata ->
                        val oldDeps = mutableSetOf<DirectDependencyMetadata>()
                        val newDeps = mutableListOf<String>()
                        metadata.forEach { it ->
                            val newDep = if (bypassDependencySubstitution(it)) {
                                null
                            } else {
                                androidXMappings["${it.group}:${it.name}"]
                            }
                            if (newDep != null) {
                                oldDeps.add(it)
                                newDeps.add(newDep)
                            }
                        }
                        for (oldDep in oldDeps.map { it -> "${it.group}:${it.name}" }) {
                            metadata.removeIf { it -> "${it.group}:${it.name}" == oldDep }
                        }
                        for (newDep in newDeps) {
                            metadata.add(newDep)
                        }
                    }
                }
            }

            project.configurations.all { config ->
                if (config.isCanBeResolved) {
                    config.resolutionStrategy.dependencySubstitution.all { it ->
                        JetifyTransform.maybeSubstituteDependency(it, config)
                    }
                }
            }
        }
    }

    // 文件遍历，矫正依赖库
    override fun transform(aarOrJarFile: File): List<File> {
        Preconditions.checkArgument(
            aarOrJarFile.name.toLowerCase().endsWith(".aar")
                    || aarOrJarFile.name.toLowerCase().endsWith(".jar")
        )

        // Case 1: 对AndroidX依赖，不做任何操作
        if (jetifyProcessor.isNewDependencyFile(aarOrJarFile)) {
            return listOf(aarOrJarFile)
        }

        // Case 2: 正常情况，已经不存在support依赖，因此对support lib不做任何操作 
        if (jetifyProcessor.isOldDependencyFile(aarOrJarFile)) {
            return listOf(aarOrJarFile)
        }

        // Case 3: 对剩余依赖库，进行矫正操作
        // 具体操作为，通过asm浏览aar、jar的字节码，将support的包名通过映射关系，转化为androidX的包名。
        // 映射关系如下：https://developer.android.com/jetpack/androidx/migrate#migrate
        val outputFile = File(outputDirectory, "jetified-" + aarOrJarFile.name)
        val maybeTransformedFile = try {
            jetifyProcessor.transform(
                setOf(FileMapping(aarOrJarFile, outputFile)), false
            )
                .single()
        } catch (exception: Exception) {
            throw RuntimeException(
                "Failed to transform '$aarOrJarFile' using Jetifier."
                        + " Reason: ${exception.message}. (Run with --stacktrace for more details.)"
                        + " To disable Jetifier,"
                        + " set ${BooleanOption.ENABLE_JETIFIER.propertyName}=false in your"
                        + " gradle.properties file.",
                exception
            )
        }

        Preconditions.checkState(
            maybeTransformedFile == aarOrJarFile || maybeTransformedFile == outputFile
        )
        Verify.verify(maybeTransformedFile.exists(), "$outputFile does not exist")
        return listOf(maybeTransformedFile)
    }
}
```

## 参考

https://developer.android.com/jetpack/androidx
https://developer.android.com/jetpack/androidx/migrate

