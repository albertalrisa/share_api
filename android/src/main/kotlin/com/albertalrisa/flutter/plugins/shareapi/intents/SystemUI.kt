package com.albertalrisa.flutter.plugins.shareapi.intents

import android.content.Intent
import android.support.v4.content.FileProvider
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.io.File

class SystemUI(authority_name: String, registrar: Registrar): BaseIntent(authority_name, registrar) {
    override fun execute(function: String?, arguments: Map<String, String>, result: Result) {
        when (function) {
            "shareText" -> {
                shareText(arguments["text"], arguments["type"]!!, arguments["prompt"])
                result.success(null)
            }
            "shareFile" -> {
                shareFile(arguments["file_url"], arguments["type"]!!, arguments["prompt"])
                result.success(null)
            }
            "shareImage" -> {
                shareImage(arguments["image_url"], arguments["type"]!!, arguments["prompt"])
                result.success(null)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override val packageName: String? = null

    private fun shareText(text:String?, mime:String, prompt: String?) {
        if (text.isNullOrEmpty()) {
            throw IllegalArgumentException("Non-empty text expected")
        }
        val shareIntent = Intent(Intent.ACTION_SEND)
        shareIntent.type = mime
        shareIntent.putExtra(Intent.EXTRA_TEXT, text)

        val chooserIntent = Intent.createChooser(shareIntent, prompt)
        runActivity(chooserIntent)
    }

    private fun shareFile(file:String?, mime:String, prompt: String?) {
        if (file.isNullOrEmpty()) {
            throw IllegalArgumentException("File path is expected")
        }
        val contentFile = File(registrar.context().cacheDir, file)
        val contentUri = FileProvider.getUriForFile(registrar.context(), authority_name, contentFile)
        val shareIntent = Intent(Intent.ACTION_SEND)
        shareIntent.type = mime
        shareIntent.putExtra(Intent.EXTRA_STREAM, contentUri)

        val chooserIntent = Intent.createChooser(shareIntent, prompt)
        runActivity(chooserIntent)
    }

    private fun shareImage(image:String?, mime:String, prompt: String?) {
        if (image.isNullOrEmpty()) {
            throw IllegalArgumentException("Image path is expected")
        }
        val imageFile = File(registrar.context().cacheDir, image)
        val contentUri = FileProvider.getUriForFile(registrar.context(), authority_name, imageFile)
        val shareIntent = Intent(Intent.ACTION_SEND)
        shareIntent.type = mime
        shareIntent.putExtra(Intent.EXTRA_STREAM, contentUri)

        val chooserIntent = Intent.createChooser(shareIntent, prompt)
        runActivity(chooserIntent)
    }
}