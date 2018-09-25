package com.albertalrisa.flutter.plugins.shareapi.intents

import android.app.Activity
import android.content.Intent
import android.support.v4.content.FileProvider
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.io.File

abstract class BaseIntent(val authority_name: String, val registrar: Registrar) {

    abstract val packageName:String?

    protected fun isIntentResolvable(intent: Intent): Boolean {
        if (registrar.activity() != null) {
            return registrar.activity().packageManager.resolveActivity(intent, 0) != null
        }
        return false
    }

    protected fun getActivity(): Activity {
        return registrar.activity()
    }

    protected fun runActivity(intent: Intent, activity: Activity? = null) {
        val baseActivity: Activity? = if(activity == null) activity else registrar.activity()
        if (baseActivity != null) {
            baseActivity.startActivity(intent)
        } else {
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            registrar.context().startActivity(intent)
        }
    }

    protected fun runActivityForResult(intent: Intent, requestCode: Int, activity: Activity? = null) {
        val baseActivity: Activity? = if(activity == null) activity else registrar.activity()
        if (baseActivity != null) {
            baseActivity.startActivityForResult(intent, requestCode)
        } else {
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            registrar.context().startActivity(intent)
        }
    }

    abstract fun execute(function: String?, arguments: Map<String, String>, result: Result)
}