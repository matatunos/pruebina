-keep class com.agenda.telefonos.** { *; }
-keep class androidx.** { *; }
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
