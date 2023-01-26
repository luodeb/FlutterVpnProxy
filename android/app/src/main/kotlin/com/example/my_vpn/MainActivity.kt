package com.example.my_vpn

import android.content.Intent
import android.util.Log
import com.example.my_vpn_plugin.core.Constant
import com.example.my_vpn_plugin.core.LocalVpnService
import com.example.my_vpn_plugin.core.ProxyConfig
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {
    val START_VPN_SERVICE_REQUEST_CODE = 1985
//    private var switchProxy: SwitchCompat? = null
//    private var GL_HISTORY_LOGS: String? = null
//    override fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//        inputAddress()
//        switchProxy = SwitchCompat(context)
//        println("初始化完成MyVPN")
//        LocalVpnService.addOnStatusChangedListener(this)
//    }

//    private fun inputAddress() {
//        ProxyConfig.Instance.setProxy("http://192.168.66.109:10080")
//        ProxyConfig.setHttpProxyServer(this@MainActivity,"http://192.168.66.109:10080")
//    }
    
//    override fun onStatusChanged(status: String?, isRunning: Boolean?) {
//        switchProxy?.isEnabled = true
//        if (isRunning != null) {
//            switchProxy?.isChecked = isRunning
//        }
//        Toast.makeText(this,status,Toast.LENGTH_SHORT).show()
//    }

    private fun onLogReceived(logString: String?) {
        if (logString != null) {
            Log.d(Constant.TAG,logString)
        }
    }

    private fun startVPNService() {
        onLogReceived("starting...")
        println("测试启动")
        val intent = LocalVpnService.prepare(this@MainActivity)
        println("Intent: $intent")
        if (intent == null){
            val serviceIntent = Intent(this@MainActivity, LocalVpnService::class.java)
            startService(serviceIntent)
        }else{
            startActivityForResult(intent, START_VPN_SERVICE_REQUEST_CODE)
        }
    }

    private fun stopVPNService() {
        LocalVpnService.IsRunning = false
    }

    private fun setVPNAddress(address:String,port: Int) {
        val httpAddress = "http://$address:$port"
        ProxyConfig.Instance.setProxy(httpAddress)
        ProxyConfig.setHttpProxyServer(this@MainActivity,httpAddress)
        println("设置http代理$httpAddress")
    }
//    private fun initCreate() {
//        inputAddress()
//        switchProxy = SwitchCompat(context)
//        println("初始化完成MyVPN")
//        LocalVpnService.addOnStatusChangedListener(this)
//    }

//    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
//        if (requestCode == START_VPN_SERVICE_REQUEST_CODE) {
//            if (resultCode == RESULT_OK) {
//                startVPNService()
//            } else {
//                switchProxy!!.isChecked = false
//                switchProxy!!.isEnabled = true
//                onLogReceived("canceled.")
//            }
//            return
//        }
//        super.onActivityResult(requestCode, resultCode, data)
//    }

    override fun onDestroy() {
//        LocalVpnService.removeOnStatusChangedListener(this)
        super.onDestroy()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger
        val channel = MethodChannel(messenger, "my_vpn")

        channel.setMethodCallHandler { call, res ->
            when (call.method) {
                // Flutter中声明的方法名
                "getPlatformVersion" -> {
                    val msg = call.argument<String>("msg")
                    Log.i("ZHP", "正在执行原生方法，传入的参数是：「$msg」")
                    res.success("这是执行的结果")
                };
//                "initCreate" -> initCreate();
                "startVPNService" -> {
                    val address = call.argument<String>("address") as String
                    val port = call.argument<String>("port") as Int
                    setVPNAddress(address,port)
                    startVPNService();
                };
                "stopVPNService" -> stopVPNService();
                "setVPNAddress" -> {
                    val address = call.argument<String>("address") as String
                    val port = call.argument<String>("port") as Int
                    setVPNAddress(address,port)
                };

                else -> {
                    res.error("error_code", "error_message", null)
                }
            }
        }
    }

}

