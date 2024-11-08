# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile
-keep class com.alibaba.security.**{*;}
-keep class com.taobao.dp.**{*;}
-keep class com.taobao.wireless.security.**{*;}
-keep class com.alibaba.wireless.security.**{*;}
-keep class android.taobao.windvane.**{*;}
-keep class android.webkit.JavascriptInterface

#阿里云人脸
-keep class com.alipay.deviceid.** { *; }
-keep class net.security.device.api.** {*;}
-keep class org.json.** { *;}
-keep class com.alibaba.fastjson.** {*;}
-keep class com.alibaba.sdk.android.oss.** { *; }

-dontwarn okio.**
-dontwarn org.apache.commons.codec.binary.**

-keepclassmembers,allowobfuscation class * {
@com.alibaba.fastjson.annotation.JSONField <fields>;
}

#友盟 start
-keep class com.umeng.** {*;}

-keep class org.repackage.** {*;}

-keepclassmembers class * {
   public <init> (org.json.JSONObject);
}

-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}
#友盟 end
#huanxin
-keep class com.hyphenate.** {*;}
-dontwarn  com.hyphenate.**
