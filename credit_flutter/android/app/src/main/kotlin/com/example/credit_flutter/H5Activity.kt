package com.example.credit_flutter

import android.annotation.TargetApi
import android.app.Activity
import android.content.Intent
import android.graphics.Bitmap
import android.net.Uri
import android.net.http.SslError
import android.os.Build
import android.os.Bundle
import android.provider.MediaStore
import android.util.Log
import android.view.KeyEvent
import android.webkit.*
import android.widget.Toast
import androidx.annotation.Nullable
import androidx.appcompat.app.AppCompatActivity

/**
 * @author xingtian on 2019/3/25
 */
class H5Activity : AppCompatActivity() {
    private val mWebView: WebView by lazy { findViewById<WebView>(R.id.webview) }

    var curUrl: String? = null
    var viewFile = false
    var time = System.currentTimeMillis()
    var uploadMessage: ValueCallback<Uri>? = null
    private var uploadMessageAboveL: ValueCallback<Array<Uri>>? = null

    override fun onCreate(@Nullable savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_h5)
        val webSetting: WebSettings = mWebView.settings

        webSetting.javaScriptEnabled = true
        webSetting.domStorageEnabled = true
//        webSetting.setAppCacheMaxSize(1024 * 1024 * 8)
        webSetting.useWideViewPort = true
        webSetting.loadWithOverviewMode = true
        webSetting.allowFileAccess = true
//        webSetting.setAppCacheEnabled(true)
        val appCachePath: String = application.cacheDir.absolutePath
//        webSetting.setAppCachePath(appCachePath)
        webSetting.databaseEnabled = true
        webSetting.cacheMode = WebSettings.LOAD_NO_CACHE
        webSetting.layoutAlgorithm = WebSettings.LayoutAlgorithm.SINGLE_COLUMN
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            WebView.setWebContentsDebuggingEnabled(true)
        }
        CookieSyncManager.createInstance(this)
        val cookieManager = CookieManager.getInstance()
        if (Build.VERSION.SDK_INT >= 21) {
            cookieManager.setAcceptThirdPartyCookies(mWebView, true)
        }
        cookieManager.setAcceptCookie(true)
        mWebView.webViewClient = MyWebViewClient()
        mWebView.webChromeClient = H5FaceWebChromeClient(this)
        WBH5FaceVerifySDK.instance?.setWebViewSettings(mWebView, applicationContext)
        processExtraData(intent)
    }

    override fun onPause() {
        super.onPause()
        mWebView.onPause()
    }

    override fun onResume() {
        super.onResume()
        mWebView.onResume()
    }

    override fun onStop() {
        super.onStop()
        mWebView.stopLoading()
    }

    override fun onDestroy() {
        super.onDestroy()
        try {
            if (mWebView != null) {
                mWebView.removeAllViews()
                mWebView.destroy()
            }
        } catch (e: Exception) {
        }
    }

    override fun onNewIntent(intent: Intent?) {
        super.onNewIntent(intent)
        setIntent(intent)
        intent?.let { processExtraData(it) }
    }

    private fun processExtraData(intent: Intent) {
        val uri: Uri? = intent.data
        Log.e("XXX", "===$uri")
        if (uri != null) {
            // 芝麻认证刷脸结束返回获取后续操作页面地址
            Log.i("XXX", "芝麻认证刷脸结束返回获取后续操作页面地址: ")
//            String callbackUrl = uri.getQueryParameter("callback");
            val callbackUrl = uri.getQueryParameter("realnameUrl")
            Log.i("XXX", "callbackUrl: $callbackUrl")

//            if (callbackUrl?.isNotEmpty() == true) {
//                try {
//                    mWebView.loadUrl(URLDecoder.decode(callbackUrl, "utf-8"))
//                } catch (e: UnsupportedEncodingException) {
//                    e.printStackTrace()
//                }
//            }
        } else {
            val url: String = intent.getStringExtra("url").toString()
            viewFile = intent.getBooleanExtra("view_file", false)
            if (url != null) {
                if (url.startsWith("alipay")) {
                    try {
                        val intent2 = Intent(Intent.ACTION_VIEW, Uri.parse(url))
                        startActivity(intent2)
                        return
                    } catch (e: Exception) {
                    }
                }
            }
            if (curUrl == null) {
                curUrl = url
            }
            if (url != null) {
                mWebView.loadUrl(url)
            }
        }
    }

    private inner class MyWebViewClient : WebViewClient() {

        override fun shouldOverrideUrlLoading(view: WebView, url: String): Boolean {
            if (url == null) {
                return false
            }
            val uri = Uri.parse(url)
            Log.e("XXX", "要加载的地址:" + uri.scheme + " " + url + " ")
            return if (uri.scheme == "http" || uri.scheme == "https") {
                view.loadUrl(url)
                true
            } else if (uri.scheme == "js" || uri.scheme == "jsbridge") {
                Log.i("XXX", "签署结果")
                // js://signCallback?signResult=true  签署结果
                if (uri.authority == "signCallback") {
                    if (viewFile) {
                        curUrl?.let { view.loadUrl(it) }
                        return true
                    } else {

                        if (url.contains("signResult")) {
                            val signResult = uri.getBooleanQueryParameter("signResult", false)
                            Log.i("XXX", "签署结果：  signResult = $signResult")

                            Toast.makeText(
                                this@H5Activity,
                                "签署结果：  signResult = $signResult",
                                Toast.LENGTH_LONG
                            ).show()
                        } else {
                            var tsignCode = uri.getQueryParameter("tsignCode")
                            tsignCode = if ("0" == tsignCode) {
                                "签署成功"
                            } else {
                                "签署失败"
                            }
                            Log.i("XXX", "签署结果： $tsignCode")

                            Toast.makeText(
                                this@H5Activity,
                                "签署结果： $tsignCode",
                                Toast.LENGTH_LONG
                            )
                                .show()
                        }
                    }
                    finish()
                }

                //js://tsignRealBack?esignAppScheme=esign://app/callback&serviceId=854677892133554052&verifycode=4a52e2af0d0abfb7b285c4f05b5af133&status=true&passed=true
                //实名结果
                if (uri.authority == "tsignRealBack") {
                    //实名结果字段
                    if (uri.getQueryParameter("verifycode") != null) {
                        val realVerifyCode = uri.getQueryParameter("verifycode")
                        Log.i("XXX", "实名结果字段")
                        Log.i("XXX", "realVerifyCode=$realVerifyCode")

                    }
                    // 实名认证结束 返回按钮/倒计时返回/暂不认证
                    val status = uri.getBooleanQueryParameter("status", false)
                    if (status) {
                        Log.i("XXX", "认证成功返回")

                        //认证成功返回
                        Toast.makeText(this@H5Activity, "认证成功", Toast.LENGTH_LONG).show()
                        finish()
                    }
                }
                true
            } else if (url.startsWith(SCHEMA_REAL)) {
                //esign://app/realBack&serviceId=854677892133554052&verifycode=4a52e2af0d0abfb7b285c4f05b5af133&status=true&passed=true

                //实名结果
                if (uri.getQueryParameter("verifycode") != null) {
                    val realVerifyCode = uri.getQueryParameter("verifycode")
                }
                // 实名认证结束 返回按钮/倒计时返回/暂不认证
                val status = uri.getBooleanQueryParameter("status", false)
                if (status) {
                    //认证成功返回
                    Log.i("XXX", "$SCHEMA_REAL-认证成功返回")

                    Toast.makeText(this@H5Activity, "认证成功", Toast.LENGTH_LONG).show()
                    finish()
                }
                true
            } else if (url.startsWith(SCHEMA_SIGN)) {
                // js://signCallback?signResult=true  签署结果
                var result = false
                if (url.contains("signResult")) {
                    val signResult = uri.getBooleanQueryParameter("signResult", false)
                    Log.i("XXX", "认证成功返回")
                    Log.i("XXX", "$SCHEMA_SIGN-签署结果：  signResult = $signResult")
                    result = signResult
                } else {
                    var tsignCode = uri.getQueryParameter("tsignCode")
                    result = "0" == tsignCode
                    if ("0" == tsignCode) {
                        Log.i("XXX", "$SCHEMA_SIGN-签署结果：签署成功")
                    } else {
                        Log.i("XXX", "$SCHEMA_SIGN-签署结果：签署失败")
                    }
                    Log.i("XXX", "$SCHEMA_SIGN-签署结果： $tsignCode")
                }
                val intent = Intent()
                intent.putExtra("resultData", result)
                setResult(RESULT_OK, intent)
                finish()
                true
            } else if (uri.scheme == "alipays") {
                // 跳转到支付宝刷脸
                // alipays://platformapi/startapp?appId=20000067&pd=NO&url=https%3A%2F%2Fzmcustprod.zmxy.com.cn%2Fcertify%2Fbegin.htm%3Ftoken%3DZM201811133000000050500431389414
                try {
                    Log.i("XXX", "跳转到支付宝刷脸")

                    val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
                    startActivity(intent)
                    true
                } catch (e: Exception) {
                    false
                }
            } else {
                false
            }
        }

        override fun onReceivedError(
            view: WebView, request: WebResourceRequest, error: WebResourceError
        ) {
            super.onReceivedError(view, request, error)
        }

        override fun onReceivedSslError(view: WebView, handler: SslErrorHandler, error: SslError) {
//            super.onReceivedSslError(view, handler, error);
            handler.proceed()
        }

        override fun onPageStarted(view: WebView, url: String, favicon: Bitmap?) {
            super.onPageStarted(view, url, favicon)
            time = System.currentTimeMillis()
        }

        override fun onPageFinished(view: WebView, url: String) {
            super.onPageFinished(view, url)
        }

        override fun onLoadResource(view: WebView, url: String) {
            super.onLoadResource(view, url)
        }
    }

    inner class H5FaceWebChromeClient(mActivity: Activity) : WebChromeClient() {
        private val activity: Activity

        init {
            activity = mActivity
        }

        override fun onReceivedTitle(view: WebView, title: String) {}
        override fun onJsPrompt(
            view: WebView,
            url: String,
            message: String,
            defaultValue: String,
            result: JsPromptResult
        ): Boolean {
            return super.onJsPrompt(view, url, message, defaultValue, result)
        }

        override fun onJsConfirm(
            view: WebView, url: String, message: String, result: JsResult
        ): Boolean {
            return super.onJsConfirm(view, url, message, result)
        }

        @TargetApi(8)
        override fun onConsoleMessage(consoleMessage: ConsoleMessage): Boolean {
            return super.onConsoleMessage(consoleMessage)
        }

        fun openFileChooser(uploadMsg: ValueCallback<Uri>?, acceptType: String?) {
            if (WBH5FaceVerifySDK.instance?.recordVideoForApiBelow21(
                    uploadMsg, acceptType.toString(), activity
                ) == true
            ) {
                return
            }
            uploadMessage = uploadMsg
        }

        fun openFileChooser(
            uploadMsg: ValueCallback<Uri>?, acceptType: String?, capture: String?
        ) {
            if (WBH5FaceVerifySDK.instance?.recordVideoForApiBelow21(
                    uploadMsg, acceptType.toString(), activity
                ) == true
            ) {
                return
            }
            uploadMessage = uploadMessage
        }

        @TargetApi(21)
        override fun onShowFileChooser(
            webView: WebView,
            filePathCallback: ValueCallback<Array<Uri>>,
            fileChooserParams: FileChooserParams
        ): Boolean {
            if (WBH5FaceVerifySDK.instance?.recordVideoForApi21(
                    webView, filePathCallback, activity, fileChooserParams
                ) == true
            ) {
                return true
            }
            uploadMessageAboveL = filePathCallback
            recordVideo(this@H5Activity)
            return true
        }

        override fun onPermissionRequest(request: PermissionRequest) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                request.grant(request.resources)
                request.origin
            }
        }
    }

    fun recordVideo(activity: Activity) {
        try {
            val intent = Intent(MediaStore.ACTION_VIDEO_CAPTURE)
            intent.putExtra(MediaStore.EXTRA_VIDEO_QUALITY, 1)
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            intent.putExtra("android.intent.extras.CAMERA_FACING", 1) // 调用前置摄像头
            activity.startActivityForResult(intent, FILE_CHOOSER_RESULT_CODE)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            if (mWebView.canGoBack()) {
                mWebView.goBack()
            } else {
                finish()
            }
            return true
        }
        return super.onKeyDown(keyCode, event)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (WBH5FaceVerifySDK.instance?.receiveH5FaceVerifyResult(
                requestCode, resultCode, data
            ) == true
        ) {
            return
        }
        if (requestCode == FILE_CHOOSER_RESULT_CODE) {
            if (null == uploadMessage && null == uploadMessageAboveL) {
                return
            }
            val result: Uri? = if (data == null || resultCode != RESULT_OK) null else data.data
            if (uploadMessageAboveL != null) {
                uploadMessageAboveL = if (resultCode == RESULT_OK) {
                    uploadMessageAboveL!!.onReceiveValue(arrayOf(result!!))
                    null
                } else {
                    uploadMessageAboveL!!.onReceiveValue(arrayOf<Uri>())
                    null
                }
            } else if (uploadMessage != null) {
                uploadMessage = if (resultCode == RESULT_OK) {
                    uploadMessage!!.onReceiveValue(result)
                    null
                } else {
                    uploadMessage!!.onReceiveValue(Uri.EMPTY)
                    null
                }
            }
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int, permissions: Array<out String>, grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        WBH5FaceVerifySDK.instance?.recordVideo(this)
    }


    companion object {
        const val SCHEMA_REAL = "esign://hyc/realBack"
        const val SCHEMA_SIGN = "esign://hyc/signBack"
        private const val FILE_CHOOSER_RESULT_CODE = 10000
    }
}