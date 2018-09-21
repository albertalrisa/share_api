package com.albertalrisa.flutter.plugins.shareapi

import android.content.Intent
import android.support.v4.content.FileProvider
import android.util.Log
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.io.File

class ShareApiPlugin(private val registrar: Registrar): MethodCallHandler {
    companion object {
        private const val authority_name = "com.albertalrisa.flutter.plugins.share_api"
        private const val channel_name = "com.albertalrisa.flutter.plugins/share_api"

        @JvmStatic
        fun registerWith(registrar: Registrar): Unit {
            val channel = MethodChannel(registrar.messenger(), channel_name)
            channel.setMethodCallHandler(ShareApiPlugin(registrar))
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result): Unit {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        }
        else if (call.method.equals("shareText")) {
            share("Oi ini shared!")
            Log.d("PLUGIN", "Called")
            result.success("Text shared!")
        }
        else if (call.method.equals("shareFile")) {
            shareFile(call.argument("uri"))
            Log.d("PLUGIN", "File share active")
            result.success(null)
        }
        else {
            result.notImplemented()
        }
    }

    private fun shareFile(path: String) {
        Log.d("SHARE_IMAGE", "INIT---")
        Log.d("SHARE_IMAGE", path)
        Log.d("SHARE_IMAGE", registrar.context().packageName)
        Log.d("SHARE_IMAGE", authority_name)
        Log.d("SHARE_IMAGE", registrar.context().cacheDir.absolutePath)
        val imageFile = File(registrar.context().cacheDir, path)
        Log.d("SHARE_IMAGE", "IMAGEFILE---")
        Log.d("SHARE_IMAGE", imageFile.absolutePath)
        Log.d("SHARE_IMAGE", imageFile.name)
        Log.d("SHARE_IMAGE", imageFile.extension)
        val contentUri = FileProvider.getUriForFile(registrar.context(), authority_name, imageFile)
        Log.d("SHARE_IMAGE", contentUri.path)
        val shareIntent = Intent(Intent.ACTION_SEND)
        shareIntent.type = "image/jpg"
        shareIntent.putExtra(Intent.EXTRA_STREAM, contentUri)
        val chooserIntent = Intent.createChooser(shareIntent, "Share image using")
        if(registrar.activity() != null){
            registrar.activity().startActivity(chooserIntent)
        }
        else {
            chooserIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            registrar.context().startActivity(chooserIntent)
        }
    }

    private fun share(text:String) {
        if (text.isEmpty()) {
            throw IllegalArgumentException("Non-empty text expected");
        }

        val shareIntent = Intent(Intent.ACTION_SEND)
        shareIntent.type = "text/plain"
        shareIntent.putExtra(Intent.EXTRA_TEXT, text)
        val chooserIntent = Intent.createChooser(shareIntent, null)
        if(registrar.activity() != null){
            registrar.activity().startActivity(chooserIntent)
        }
        else {
            chooserIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            registrar.context().startActivity(chooserIntent)
        }
    }
}
