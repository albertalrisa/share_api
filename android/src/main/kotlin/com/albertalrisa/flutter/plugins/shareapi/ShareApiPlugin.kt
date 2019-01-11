package com.albertalrisa.flutter.plugins.shareapi

import android.app.Activity
import android.content.Intent
import com.albertalrisa.flutter.plugins.shareapi.intents.*
import com.albertalrisa.flutter.plugins.shareapi.requests.*
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener
import io.flutter.plugin.common.PluginRegistry.Registrar

class ShareApiPlugin(registrar: Registrar, activity: Activity): MethodCallHandler, ActivityResultListener {

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if(currentCallResult == null)
            return false
        val result = currentCallResult!!
        if(activityRequestCodes.containsValue(requestCode)){
            if(resultCode == Activity.RESULT_OK){
                result.success(ShareResult.Ok)
            }
            else{
                if(supportResult.containsValue(requestCode)) {
                    result.success(ShareResult.Canceled)
                }
                else {
                    result.success(ShareResult.Undefined)
                }
            }
            return true
        }
        return false
    }

    companion object {
        private const val channel_name = "com.albertalrisa.flutter.plugins/share_api"
        private const val authority_suffix = ".com.albertalrisa.share_api"
        @JvmStatic
        fun registerWith(registrar: Registrar): Unit {
            val channel = MethodChannel(registrar.messenger(), channel_name)
            val pluginInstance = ShareApiPlugin(registrar, registrar.activity())
            channel.setMethodCallHandler(pluginInstance)
            registrar.addActivityResultListener(pluginInstance)
        }
    }

    private val authorityName = registrar.context().packageName + authority_suffix

    private var intents: Map<String, BaseIntent> = mapOf(
            "facebook" to Facebook(authorityName, registrar, activity),
            "instagram" to Instagram(authorityName, registrar, activity),
            "system" to SystemUI(authorityName, registrar, activity)
    )

    private val activityRequestCodes = mapOf(
            "Facebook.shareToStory" to FACEBOOK_SHARE_TO_STORY,
            "Instagram.shareToStory" to INSTAGRAM_SHARE_TO_STORY,
            "SystemUI.shareText" to SYSTEMUI_SHARE_TEXT,
            "SystemUI.shareImage" to SYSTEMUI_SHARE_IMAGE,
            "SystemUI.shareFile" to SYSTEMUI_SHARE_FILE
    )

    private val supportResult = mapOf(
            "Facebook.shareToStory" to FACEBOOK_SHARE_TO_STORY
    )

    private var currentCallResult: Result? = null

    override fun onMethodCall(call: MethodCall, result: Result): Unit {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
            return
        }
        else if(call.method == "share") {
            val handler:Map<String, String> = call.argument("handler")!!
            val module = handler["module"]
            if(intents.containsKey(module)){
                val function = handler["function"]
                currentCallResult = result
                val arguments:Map<String, String>? = call.argument("arguments")
                if(arguments == null){
                    result.error("InvalidArgument", "Arguments must be of type Map<String, String>", arguments)
                    return
                }
                try {
                    intents[module]!!.execute(function, call.argument("arguments")!!, result)
                    return
                } catch (e: Exception) {
                    result.error("SharingException", "Sharing to module ${module} failed", e)
                }
            }
        }
        else if(call.method == "isInstalled") {
            val handler:Map<String, String> = call.argument("handler")!!
            val module = handler["module"]
            if(intents.containsKey(module)){
                result.success(intents[module]!!.isInstalled())
                return
            }
        }
        result.notImplemented()
    }
}
