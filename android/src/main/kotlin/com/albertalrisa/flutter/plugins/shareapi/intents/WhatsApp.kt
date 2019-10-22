package com.albertalrisa.flutter.plugins.shareapi.intents

import android.app.Activity
import android.content.Intent
import androidx.core.content.FileProvider
import com.albertalrisa.flutter.plugins.shareapi.requests.WHATSAPP_SHARE_IMAGE
import com.albertalrisa.flutter.plugins.shareapi.requests.WHATSAPP_SHARE_TEXT
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import java.io.File

class WhatsApp(authority_name: String, registrar: PluginRegistry.Registrar, activity: Activity): BaseIntent(authority_name, registrar, activity) {
    override val packageName = "com.whatsapp"

    override fun execute(function: String?, arguments: Map<String, String>, result: MethodChannel.Result) {
        when (function) {
            "shareText" -> {
                shareText(arguments["text"], arguments["type"]!!, result)
            }
            "shareImage" -> {
                shareImage(arguments["image_url"], arguments["type"]!!, result)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun shareText(text: String?, mime:String, result: MethodChannel.Result) {
        if (text.isNullOrEmpty()) {
            val exceptionMessage = "Non-empty text expected"
            val exception = IllegalArgumentException(exceptionMessage)
            result.error("IllegalArgumentException", exceptionMessage, exception)
            throw exception
        }
        val shareIntent = Intent(Intent.ACTION_SEND)
        shareIntent.`package` = this.packageName
        shareIntent.type = mime
        shareIntent.putExtra(Intent.EXTRA_TEXT, text)

        runActivityForResult(shareIntent, WHATSAPP_SHARE_TEXT)
    }

    private fun shareImage(image:String?, mime:String, result: MethodChannel.Result) {
        if (image.isNullOrEmpty()) {
            val exceptionMessage = "Non-empty local image path expected"
            val exception = IllegalArgumentException(exceptionMessage)
            result.error("IllegalArgumentException", exceptionMessage, exception)
            throw exception
        }

        val imageFile = File(registrar.context().cacheDir, image)
        val contentUri = FileProvider.getUriForFile(registrar.context(), authority_name, imageFile)
        val shareIntent = Intent(Intent.ACTION_SEND)
        shareIntent.`package` = this.packageName
        shareIntent.type = mime
        shareIntent.putExtra(Intent.EXTRA_STREAM, contentUri)

        runActivityForResult(shareIntent, WHATSAPP_SHARE_IMAGE)
    }

}