#!/usr/bin/env bash
# Compiles the project with Kotlin 2.4.21 and the newest Pika plugin, then with Kotlin 2.4.20 as the control. Exits 1
# while the 2.4.21 build cannot resolve pika-compiler for 2.4.21 and the control builds, 0 once the 2.4.21 build
# compiles, and 2 when the control fails or the 2.4.21 build fails another way.
set -uo pipefail

cd "$(dirname "$0")" || exit 2

pika_version=$(sed -n -E 's/.*id\("io\.github\.expo\.pika"\) version "([^"]+)".*/\1/p' build.gradle.kts) || exit 2
gradle_version=$(sed -n -E 's/^distributionUrl=.*gradle-([0-9.]+)-bin\.zip$/\1/p' gradle/wrapper/gradle-wrapper.properties) || exit 2
java_version=$(java -version 2>&1 | head -n 1) || exit 2
system_name=$(uname -s) || exit 2
echo "System: $system_name, Gradle $gradle_version, $java_version, io.github.expo.pika $pika_version"

compile() {
  local kotlin_version=$1 log=$2
  echo "\$ ./gradlew compileKotlin -PkotlinVersion=$kotlin_version"
  ./gradlew --no-daemon --console=plain compileKotlin "-PkotlinVersion=$kotlin_version" >"$log" 2>&1
  local status=$?
  echo "exit $status"
  return "$status"
}

compile 2.4.21 build-2.4.21.log
status_new=$?
missing=$(grep -m 1 -E '> Could not find io\.github\.expo\.pika:pika-compiler:' build-2.4.21.log)
grep -m 1 -E '^> Task :compileKotlin' build-2.4.21.log
[ -n "$missing" ] && echo "$missing"

compile 2.4.20 build-2.4.20.log
status_control=$?
grep -m 1 -E '^> Task :compileKotlin' build-2.4.20.log

if [ "$status_control" -ne 0 ]; then
  tail -n 20 build-2.4.20.log
  echo "SUMMARY: step failed: the control build with Kotlin 2.4.20 failed (build-2.4.20.log)"
  exit 2
fi
if [ "$status_new" -eq 0 ]; then
  echo "SUMMARY: fixed: io.github.expo.pika $pika_version compiles with Kotlin 2.4.21"
  exit 0
fi
if [ -n "$missing" ]; then
  echo "SUMMARY: defect: io.github.expo.pika $pika_version has no pika-compiler build for Kotlin 2.4.21; with Kotlin 2.4.20 the project builds"
  exit 1
fi
tail -n 20 build-2.4.21.log
echo "SUMMARY: step failed: the Kotlin 2.4.21 build failed another way (build-2.4.21.log)"
exit 2
