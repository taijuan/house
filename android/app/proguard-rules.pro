#java kotlin注解
-keep public class * extends java.lang.annotation.Annotation
-keepattributes Signature
-keepattributes *Annotation*

#Flutter源码
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

#jni native方法
-keepclasseswithmembernames class * {
    native <methods>;
}

#Permistion Handler
-keep class com.baseflow.permissionhandler.data.*{*;}

#Gson
-dontwarn sun.misc.**
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

-dontwarn  android.support.**
-dontwarn  com.google.android.gms.**


#Glide
-keep public class * implements com.bumptech.glide.module.GlideModule
-keep public class * extends com.bumptech.glide.module.AppGlideModule
-keep public enum com.bumptech.glide.load.ImageHeaderParser$** {
  **[] $VALUES;
  public *;
}
