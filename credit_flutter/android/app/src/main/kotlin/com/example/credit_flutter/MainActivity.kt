package com.example.credit_flutter

import android.Manifest
import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.os.Message
import android.util.Log
import android.widget.Toast
import com.alipay.sdk.app.PayTask
import com.hjq.permissions.OnPermissionCallback
import com.hjq.permissions.XXPermissions
import com.umeng.commonsdk.UMConfigure
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.flutter.native"

    private var result: MethodChannel.Result? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        initUmengSDK()

    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger, CHANNEL
        ).setMethodCallHandler { call, result ->
            this.result = result
            when (call.method) {
                "AliPay" -> {
                    val orderInfo = call.argument<String>("context")
                    startPay(orderInfo.toString())
                }

                "CertificationProcess" -> {
                    val url = call.argument<String>("url").toString()
                    judgePermissions(url)
                }
            }
        }

    }

    private fun initUmengSDK() {
        UMConfigure.setLogEnabled(true)

        //HUAWEI
        //VIVO
        //BAIDU
        //OPPO
        //MILLET
        //TENCENT

        //TEST
        //UPDATE
//        UMConfigure.preInit(this, "6435119bba6a5259c4358dd6", "TEST")

    }


    private val SDK_PAY_FLAG = 1

    private val mHandler: Handler = object : Handler(Looper.myLooper()!!) {
        override fun handleMessage(msg: Message) {
            when (msg.what) {
                SDK_PAY_FLAG -> {
                    val payResult = PayResult(msg.obj as Map<String?, String?>)

                    /**
                     * 对于支付结果，请商户依赖服务端的异步通知结果。同步通知结果，仅作为支付结束的通知。
                     */
                    val resultInfo: String? = payResult.result // 同步返回需要验证的信息
                    val resultStatus: String? = payResult.resultStatus
                    // 判断resultStatus 为9000则代表支付成功
                    if (result != null) {
                        var map: HashMap<String, String> = HashMap<String, String>()
                        map["resultStatus"] = resultStatus.toString()
                        result?.success(map)
                    }
                }

                else -> {}
            }
        }
    }

    private fun startPay(orderInfo: String) {
        val payRunnable = Runnable {
            val alipay = PayTask(this@MainActivity)
            val result = alipay.payV2(orderInfo, true)
            val msg = Message()
            msg.what = SDK_PAY_FLAG
            msg.obj = result
            mHandler.sendMessage(msg)
        }
        // 必须异步调用
        val payThread = Thread(payRunnable)
        payThread.start()
    }

    private fun judgePermissions(url: String) {
        XXPermissions.with(this) // 申请单个权限
            .permission(Manifest.permission.CAMERA) // 申请多个权限
            .request(object : OnPermissionCallback {
                override fun onGranted(permissions: MutableList<String>, allGranted: Boolean) {
                    startPage(url)
                }

                override fun onDenied(permissions: MutableList<String>, doNotAskAgain: Boolean) {
                    super.onDenied(permissions, doNotAskAgain)
                    if (doNotAskAgain) {
                        Toast.makeText(
                            this@MainActivity,
                            "被永久拒绝授权，请手动授予相机权限",
                            Toast.LENGTH_SHORT
                        ).show()
                        // 如果是被永久拒绝就跳转到应用权限系统设置页面
                        XXPermissions.startPermissionActivity(
                            this@MainActivity, Manifest.permission.CAMERA
                        )
                    } else {
                        Toast.makeText(this@MainActivity, "获取相机权限失败", Toast.LENGTH_SHORT)
                            .show()
                    }
                }
            })
    }

    private fun startPage(url: String) {
        val intent = Intent(this@MainActivity, H5Activity::class.java)
        intent.putExtra("url", url)
        intent.putExtra("view_file", false)
        startActivityForResult(intent, 101)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == 101 && resultCode == RESULT_OK) {
            val resultData = data?.extras!!.getBoolean("resultData", false)
            if (result != null) {
                var map: HashMap<String, Boolean> = HashMap()
                map["result"] = resultData
                result!!.success(map)
            }
        }
    }


}
