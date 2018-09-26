package com.albertalrisa.flutter.plugins.shareapi.intents

import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

abstract class BaseIntent(val authority_name: String, val registrar: Registrar, val activity: Activity) {

    abstract val packageName:String?

    fun isInstalled(): Boolean {
        if(packageName == null) return true
        val packageManager = activity.packageManager
        return try {
            packageManager.getApplicationInfo(packageName, 0).enabled
        } catch (e: PackageManager.NameNotFoundException) {
            false
        }
    }

    protected fun isIntentResolvable(intent: Intent): Boolean {
        if (registrar.activity() != null) {
            return registrar.activity().packageManager.resolveActivity(intent, 0) != null
        }
        return false
    }

    protected fun runActivity(intent: Intent, activity: Activity? = null) {
        val baseActivity: Activity? = activity ?: this.activity
        if (baseActivity != null) {
            baseActivity.startActivity(intent)
        } else {
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            registrar.context().startActivity(intent)
        }
    }

    protected fun runActivityForResult(intent: Intent, requestCode: Int, activity: Activity? = null) {
        val baseActivity: Activity? = activity ?: this.activity
        if (baseActivity != null) {
            baseActivity.startActivityForResult(intent, requestCode)
        } else {
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            registrar.context().startActivity(intent)
        }
    }

    abstract fun execute(function: String?, arguments: Map<String, String>, result: Result)
}