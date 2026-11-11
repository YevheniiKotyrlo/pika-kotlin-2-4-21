pluginManagement {
  val kotlinVersion = providers.gradleProperty("kotlinVersion").getOrElse("2.4.21")
  plugins {
    kotlin("jvm") version kotlinVersion
  }
  repositories {
    mavenCentral()
    gradlePluginPortal()
  }
}

dependencyResolutionManagement {
  repositories {
    mavenCentral()
  }
}

rootProject.name = "pika-kotlin-2-4-21"
