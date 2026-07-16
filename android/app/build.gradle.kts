plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.fluplayer"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.fluplayer.stunningquality"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {  // 使用 create 方法定义签名配置
            keyAlias = "fluplayer"
            keyPassword = "fluplayer"
            storeFile = file("fluplayer.keystore")  // 文件路径使用 file() 函数
            storePassword = "fluplayer"
        }
    }

    buildTypes {
        debug {
            signingConfig = signingConfigs.getByName("release")
        }
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("androidx.core:core-splashscreen:1.0.0")
    implementation("com.google.firebase:firebase-bom:33.14.0")
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.adjust.sdk:adjust-android:5.1.0")
    implementation("com.google.gms:google-services:4.4.4")
    implementation("androidx.recyclerview:recyclerview:1.4.0")
    compileOnly("com.facebook.infer.annotation:infer-annotation:0.18.0")

    implementation("com.applovin:applovin-sdk:+")
    implementation("com.applovin.mediation:bidmachine-adapter:+")
    implementation("com.applovin.mediation:bigoads-adapter:+")
    implementation("com.applovin.mediation:fyber-adapter:+")
    implementation("com.applovin.mediation:google-ad-manager-adapter:+")
    implementation("com.applovin.mediation:google-adapter:+")
    implementation("com.applovin.mediation:inmobi-adapter:+")
    implementation("com.squareup.picasso:picasso:2.8")
    implementation("com.applovin.mediation:ironsource-adapter:+")
    implementation("com.applovin.mediation:vungle-adapter:+")
    implementation("com.applovin.mediation:facebook-adapter:+")
    implementation("com.applovin.mediation:mintegral-adapter:+")
    implementation("com.applovin.mediation:moloco-adapter:+")
    implementation("com.applovin.mediation:bytedance-adapter:+")
    implementation("com.applovin.mediation:unityads-adapter:+")

    implementation("com.google.ads.mediation:applovin:13.5.1.0")
    implementation("com.google.ads.mediation:fyber:8.3.8.0")
    implementation("com.google.ads.mediation:imobile:2.3.2.1")
    implementation("com.google.ads.mediation:inmobi:10.8.3.1")
    implementation("com.google.ads.mediation:ironsource:8.10.0.0")
    implementation("com.google.ads.mediation:vungle:7.7.1.0")
    implementation("com.google.ads.mediation:facebook:6.20.0.0")
    implementation("com.google.ads.mediation:mintegral:16.9.81.0")
    implementation("com.google.ads.mediation:moloco:4.3.1.0")
    implementation("com.google.ads.mediation:pangle:7.9.1.3.0")
    implementation("com.unity3d.ads:unity-ads:4.15.0")
    implementation("com.google.ads.mediation:unity:4.16.0.0")
}
