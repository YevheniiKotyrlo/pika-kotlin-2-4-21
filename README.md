# Pika has no pika-compiler build for Kotlin 2.4.21

A Kotlin/JVM project applying `kotlin("jvm")` and `id("io.github.expo.pika") version "1.1.1"`. The Kotlin version comes
from the `kotlinVersion` Gradle property, 2.4.21 unless set.

```sh
git clone https://github.com/YevheniiKotyrlo/pika-kotlin-2-4-21
cd pika-kotlin-2-4-21
bash repro.sh
```

`repro.sh` runs `./gradlew compileKotlin -PkotlinVersion=2.4.21`, then the same with 2.4.20 as the control. It exits 1
while the 2.4.21 build cannot resolve `pika-compiler` for 2.4.21, 0 once it compiles, and 2 when a step fails another
way.
