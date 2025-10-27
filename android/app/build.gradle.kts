plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.notification"
    compileSdk = 36  // ← CAMBIAR de 34 a 36
    ndkVersion = "27.0.12077973"  // ← CAMBIAR de "25.1.8937393" a "27.0.12077973"


    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17  // ← CAMBIAR de VERSION_11 a VERSION_17
        targetCompatibility = JavaVersion.VERSION_17  // ← CAMBIAR de VERSION_11 a VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()  // ← CAMBIAR de VERSION_11 a VERSION_17
    }

    defaultConfig {
        applicationId = "com.example.notification"
        minSdk = flutter.minSdkVersion
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
        multiDexEnabled = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:32.7.0"))
    implementation("com.google.firebase:firebase-messaging-ktx")
}
