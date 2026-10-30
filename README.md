# Pika has no pika-compiler build for Kotlin 2.4.21

A Kotlin/JVM project applying `kotlin("jvm") version "2.4.21"` and `id("io.github.expo.pika") version "1.1.0"`.
Pika's Gradle plugin adds `io.github.expo.pika:pika-compiler:1.1.0-2.4.21` to the compiler plugin classpath, and Maven
Central has builds up to `1.1.0-2.4.20`.

```
git clone https://github.com/YevheniiKotyrlo/pika-kotlin-2-4-21
cd pika-kotlin-2-4-21
./gradlew compileKotlin
```

Expected: `compileKotlin` succeeds. Seen:

```
> Could not find io.github.expo.pika:pika-compiler:1.1.0-2.4.21.
```

With `kotlin("jvm") version "2.4.20"` in `build.gradle.kts` the same project builds.
