package com.example.credit_flutter

import android.annotation.TargetApi
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.ConnectivityManager
import android.net.NetworkInfo
import android.net.Uri
import android.os.Build
import android.provider.MediaStore
import android.telephony.TelephonyManager
import android.webkit.ValueCallback
import android.webkit.WebChromeClient
import android.webkit.WebSettings
import android.webkit.WebView

class WBH5FaceVerifySDK private constructor() {

    private var mUploadMessage: ValueCallback<Uri>? = null
    private var mUploadCallbackAboveL: ValueCallback<Array<Uri>>? = null
    fun setWebViewSettings(mWebView: WebView?, context: Context) {
        if (null == mWebView) {
            return
        }
        //
        if (null == mWebView) {
            return
        }
        val webSetting: WebSettings = mWebView.settings
        webSetting.javaScriptEnabled = true
        webSetting.textZoom = 100
        webSetting.allowFileAccess = true
        webSetting.layoutAlgorithm = WebSettings.LayoutAlgorithm.NARROW_COLUMNS
        webSetting.setSupportZoom(true)
        webSetting.builtInZoomControls = true
        webSetting.useWideViewPort = true
        webSetting.setSupportMultipleWindows(false)
        webSetting.loadWithOverviewMode = true
//        webSetting.setAppCacheMaxSizeheEnabled(true)
        webSetting.databaseEnabled = true
        webSetting.domStorageEnabled = true
        webSetting.setGeolocationEnabled(true)
//        webSetting.setAppCacheMaxSize(Long.MAX_VALUE)
//        webSetting.setAppCachePath(context.getDir("appcache", 0).path)
        webSetting.databasePath = context.getDir("databases", 0).path
        webSetting.setGeolocationDatabasePath(context.getDir("geolocation", 0).path)
        webSetting.pluginState = WebSettings.PluginState.ON_DEMAND
        webSetting.setRenderPriority(WebSettings.RenderPriority.HIGH)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
            webSetting.allowUniversalAccessFromFileURLs = true
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
            mWebView.removeJavascriptInterface("searchBoxJavaBridge_")
        }
        val ua: String = webSetting.userAgentString
        try {
            webSetting.setUserAgentString(
                ua + ";webank/h5face;webank/1.0" + ";netType:" + getNetWorkState(context) + ";appVersion:" + context.packageManager.getPackageInfo(
                    context.packageName,
                    0
                ).versionCode + ";packageName:" + context.packageName
            )
        } catch (e: PackageManager.NameNotFoundException) {
            webSetting.setUserAgentString("$ua;webank/h5face;webank/1.0")
            e.printStackTrace()
        }
    }

    fun receiveH5FaceVerifyResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == VIDEO_REQUEST) { //根据请求码判断返回的是否是h5刷脸结果
            if (null == mUploadMessage && null == mUploadCallbackAboveL) {
                return true
            }
            val result: Uri? =
                if (data == null || resultCode != Activity.RESULT_OK) null else data.getData()
            val uris = result?.let { arrayOf(it) }
            if (mUploadCallbackAboveL != null) {
                mUploadCallbackAboveL!!.onReceiveValue(uris)
                setmUploadCallbackAboveL(null)
            } else {
                mUploadMessage!!.onReceiveValue(result)
                setmUploadMessage(null)
            }
            return true
        }
        return false
    }

    fun recordVideoForApiBelow21(
        uploadMsg: ValueCallback<Uri>?, acceptType: String, activity: Activity
    ): Boolean {
        if ("video/webank" == acceptType) {
            setmUploadMessage(uploadMsg)
            recordVideo(activity)
            return true
        }
        return false
    }

    @TargetApi(21)
    fun recordVideoForApi21(
        webView: WebView,
        filePathCallback: ValueCallback<Array<Uri>>?,
        activity: Activity,
        fileChooserParams: WebChromeClient.FileChooserParams
    ): Boolean {
        if ("video/webank" == fileChooserParams.getAcceptTypes().get(0) || webView.url!!.startsWith(
                "https://miniprogram-kyc.tencentcloudapi.com"
            ) || webView.url!!.startsWith("https://ida.webank.com")
        ) { //是h5刷脸
            setmUploadCallbackAboveL(filePathCallback)
            recordVideo(activity)
            return true
        }
        return false
    }

    /**
     * 调用系统前置摄像头进行视频录制
     */
    fun recordVideo(activity: Activity) {
        try {
            val intent = Intent(MediaStore.ACTION_VIDEO_CAPTURE)
            intent.putExtra(MediaStore.EXTRA_VIDEO_QUALITY, 1)
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            intent.putExtra("android.intent.extras.CAMERA_FACING", 1) // 调用前置摄像头
            activity.startActivityForResult(intent, VIDEO_REQUEST)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun setmUploadMessage(uploadMessage: ValueCallback<Uri>?) {
        mUploadMessage = uploadMessage
    }

    private fun setmUploadCallbackAboveL(uploadCallbackAboveL: ValueCallback<Array<Uri>>?) {
        mUploadCallbackAboveL = uploadCallbackAboveL
    }

    companion object {
        //没有网络连接
        private const val NETWORK_NONE = "NETWORK_NONE"

        //wifi连接
        private const val NETWORK_WIFI = "NETWORK_WIFI"

        //手机网络数据连接类型
        private const val NETWORK_2G = "NETWORK_2G"
        private const val NETWORK_3G = "NETWORK_3G"
        private const val NETWORK_4G = "NETWORK_4G"
        private const val NETWORK_MOBILE = "NETWORK_MOBILE"
        private const val VIDEO_REQUEST = 0x0001

        @get:Synchronized
        var instance: WBH5FaceVerifySDK? = null
            get() {
                if (null == field) {
                    field = WBH5FaceVerifySDK()
                }
                return field
            }
            private set

        /**
         * 获取当前网络连接类型
         *
         * @param context
         */
        private fun getNetWorkState(context: Context): String {
            //获取系统的网络服务
            val connManager: ConnectivityManager =
                context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
                    ?: return NETWORK_NONE
            //如果当前没有网络

            //获取当前网络类型，如果为空，返回无网络
            val activeNetInfo: NetworkInfo? = connManager.activeNetworkInfo
            if (activeNetInfo == null || !activeNetInfo.isAvailable) {
                return NETWORK_NONE
            }

            // 判断是不是连接的是不是wifi
            val wifiInfo: NetworkInfo? = connManager.getNetworkInfo(ConnectivityManager.TYPE_WIFI)
            if (null != wifiInfo) {
                val state: NetworkInfo.State = wifiInfo.state
                if (null != state) {
                    if (state == NetworkInfo.State.CONNECTED || state == NetworkInfo.State.CONNECTING) {
                        return NETWORK_WIFI
                    }
                }
            }

            // 如果不是wifi，则判断当前连接的是运营商的哪种网络2g、3g、4g等
            val networkInfo: NetworkInfo? =
                connManager.getNetworkInfo(ConnectivityManager.TYPE_MOBILE)
            if (null != networkInfo) {
                val state: NetworkInfo.State = networkInfo.getState()
                val strSubTypeName: String = networkInfo.getSubtypeName()
                if (null != state) {
                    if (state == NetworkInfo.State.CONNECTED || state == NetworkInfo.State.CONNECTING) {
                        return when (activeNetInfo.getSubtype()) {
                            TelephonyManager.NETWORK_TYPE_GPRS, TelephonyManager.NETWORK_TYPE_CDMA, TelephonyManager.NETWORK_TYPE_EDGE, TelephonyManager.NETWORK_TYPE_1xRTT, TelephonyManager.NETWORK_TYPE_IDEN -> NETWORK_2G
                            TelephonyManager.NETWORK_TYPE_EVDO_A, TelephonyManager.NETWORK_TYPE_UMTS, TelephonyManager.NETWORK_TYPE_EVDO_0, TelephonyManager.NETWORK_TYPE_HSDPA, TelephonyManager.NETWORK_TYPE_HSUPA, TelephonyManager.NETWORK_TYPE_HSPA, TelephonyManager.NETWORK_TYPE_EVDO_B, TelephonyManager.NETWORK_TYPE_EHRPD, TelephonyManager.NETWORK_TYPE_HSPAP -> NETWORK_3G
                            TelephonyManager.NETWORK_TYPE_LTE -> NETWORK_4G
                            else ->                             //中国移动 联通 电信 三种3G制式
                                if (strSubTypeName.equals(
                                        "TD-SCDMA", ignoreCase = true
                                    ) || strSubTypeName.equals(
                                        "WCDMA", ignoreCase = true
                                    ) || strSubTypeName.equals(
                                        "CDMA2000", ignoreCase = true
                                    )
                                ) {
                                    NETWORK_3G
                                } else {
                                    NETWORK_MOBILE
                                }
                        }
                    }
                }
            }
            return NETWORK_NONE
        }
    }
}