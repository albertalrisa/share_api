package com.albertalrisa.flutter.plugins.shareapi

import android.content.Intent
import com.albertalrisa.flutter.plugins.shareapi.intents.Facebook
import com.albertalrisa.flutter.plugins.shareapi.intents.SystemUI
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener
import io.flutter.plugin.common.PluginRegistry.Registrar

class ShareApiPlugin(private val registrar: Registrar): MethodCallHandler, ActivityResultListener {
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        return true
    }

    companion object {
        private const val authority_name = "com.albertalrisa.flutter.plugins.share_api"
        private const val channel_name = "com.albertalrisa.flutter.plugins/share_api"

        @JvmStatic
        fun registerWith(registrar: Registrar): Unit {
            val channel = MethodChannel(registrar.messenger(), channel_name)
            val pluginInstance = ShareApiPlugin(registrar)
            channel.setMethodCallHandler(pluginInstance)
            registrar.addActivityResultListener(pluginInstance)
        }
    }

    private val intents = mapOf(
            "facebook" to Facebook(authority_name, registrar),
            "system" to SystemUI(authority_name, registrar)
    )

    override fun onMethodCall(call: MethodCall, result: Result): Unit {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        }
        else if(call.method == "share") {
            val handler:Map<String, String> = call.argument("handler")
            val module = handler["module"]
            if(intents.containsKey(module)){
                val function = handler["function"]
                intents[module]!!.execute(function, call.argument("arguments"), result)
            }
            else{
                result.notImplemented()
            }
        }
        else {
            result.notImplemented()
        }
    }
}
