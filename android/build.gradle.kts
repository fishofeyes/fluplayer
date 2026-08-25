allprojects {
    repositories {
        google()
        mavenCentral()

        flatDir {
            dirs("libs")
        }
        maven { url = uri("https://dl-maven-android.mintegral.com/repository/mbridge_android_sdk_oversea") }
        maven { url = uri("https://artifact.bytedance.com/repository/pangle") }
        maven { url = uri("https://jitpack.io") }
        maven { url = uri("https://artifactory.bidmachine.io/bidmachine") }
        maven { url = uri("https://android-sdk.is.com/") }
        maven { url = uri("https://imobile.github.io/adnw-sdk-android") }

        maven { url = uri("https://jfrog.anythinktech.com/artifactory/overseas_sdk") }
        maven { url = uri("https://jfrog.anythinktech.com/artifactory/debugger") }

    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
