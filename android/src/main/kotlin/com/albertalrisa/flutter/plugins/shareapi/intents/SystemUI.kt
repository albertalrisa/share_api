package com.albertalrisa.flutter.plugins.shareapi.intents

import android.app.Activity
import android.content.Intent
import androidx.core.content.FileProvider
import com.albertalrisa.flutter.plugins.shareapi.requests.SYSTEMUI_SHARE_FILE
import com.albertalrisa.flutter.plugins.shareapi.requests.SYSTEMUI_SHARE_IMAGE
import com.albertalrisa.flutter.plugins.shareapi.requests.SYSTEMUI_SHARE_TEXT
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.io.File

class SystemUI(authority_name: String, registrar: Registrar, activity: Activity): BaseIntent(authority_name, registrar, activity) {

    override val packageName: String? = null

    override fun execute(function: String?, arguments: Map<String, String>, result: Result) {
        when (function) {
            "shareText" -> {
                shareText(arguments["text"], arguments["type"]!!, arguments["prompt"], result)
            }
            "shareFile" -> {
                shareFile(arguments["file_url"], arguments["type"]!!, arguments["prompt"], result)
            }
            "shareImage" -> {
                shareImage(arguments["image_url"], arguments["type"]!!, arguments["prompt"], result)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun shareText(text:String?, mime:String, prompt: String?, result: Result) {
        if (text.isNullOrEmpty()) {
            val exceptionMessage = "Non-empty text expected"
            val exception = IllegalArgumentException(exceptionMessage)
            result.error("IllegalArgumentException", exceptionMessage, exception)
            throw exception
        }

        val shareIntent = Intent(Intent.ACTION_SEND)
        shareIntent.type = mime
        shareIntent.putExtra(Intent.EXTRA_TEXT, text)

        val chooserIntent = Intent.createChooser(shareIntent, prompt)
        runActivityForResult(chooserIntent, SYSTEMUI_SHARE_TEXT)
    }

    private fun shareFile(file:String?, mime:String, prompt: String?, result: Result) {
        if (file.isNullOrEmpty()) {
            val exceptionMessage = "Non-empty local file path expected"
            val exception = IllegalArgumentException(exceptionMessage)
            result.error("IllegalArgumentException", exceptionMessage, exception)
            throw exception
        }

        val contentFile = File(registrar.context().cacheDir, file)
        val contentUri = FileProvider.getUriForFile(registrar.context(), authority_name, contentFile)
        val shareIntent = Intent(Intent.ACTION_SEND)
        shareIntent.type = mime
        shareIntent.putExtra(Intent.EXTRA_STREAM, contentUri)

        val chooserIntent = Intent.createChooser(shareIntent, prompt)
        runActivityForResult(chooserIntent, SYSTEMUI_SHARE_FILE)
    }

    private fun shareImage(image:String?, mime:String, prompt: String?, result: Result) {
        if (image.isNullOrEmpty()) {
            val exceptionMessage = "Non-empty local image path expected"
            val exception = IllegalArgumentException(exceptionMessage)
            result.error("IllegalArgumentException", exceptionMessage, exception)
            throw exception
        }

        val imageFile = File(registrar.context().cacheDir, image)
        val contentUri = FileProvider.getUriForFile(registrar.context(), authority_name, imageFile)
        val shareIntent = Intent(Intent.ACTION_SEND)
        shareIntent.type = mime
        shareIntent.putExtra(Intent.EXTRA_STREAM, contentUri)

        val chooserIntent = Intent.createChooser(shareIntent, prompt)
        runActivityForResult(chooserIntent, SYSTEMUI_SHARE_IMAGE)
    }
}