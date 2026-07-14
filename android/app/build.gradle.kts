plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Base launcher label; the dev/staging flavors append their own suffix.
// The rename script (setup/setup.dart) rewrites this value.
val appLabelBase = "craft_flutter_template"

android {
    namespace = "com.craft.craft_flutter_template"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.craft.craft_flutter_template"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // One flavor per AppEnv (lib/core/config/app_env.dart). Suffixed ids
    // let dev/staging/prod installs coexist on one device. Pair each with
    // its Dart entry point:
    //   flutter run --flavor dev --target lib/main_dev.dart
    flavorDimensions += "env"
    productFlavors {
        create("dev") {
            dimension = "env"
            applicationIdSuffix = ".dev"
            manifestPlaceholders["appLabel"] = "$appLabelBase Dev"
        }
        create("staging") {
            dimension = "env"
            applicationIdSuffix = ".stg"
            manifestPlaceholders["appLabel"] = "$appLabelBase Staging"
        }
        create("prod") {
            dimension = "env"
            manifestPlaceholders["appLabel"] = appLabelBase
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
