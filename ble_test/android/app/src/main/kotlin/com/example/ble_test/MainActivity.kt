package com.example.ble_test

import android.annotation.SuppressLint
import android.content.ContentResolver
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;


class MainActivity : FlutterActivity() {
    private val deviceId: String = "deviceId";

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val contentResolver: ContentResolver = activity.contentResolver

        MethodChannel(flutterEngine.dartExecutor, deviceId).setMethodCallHandler(IdHandler(contentResolver))
    }
}

// IdHandler class
class IdHandler(private val contentResolver: ContentResolver) : MethodChannel.MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "getId") {
            result.success(getAndroidId())
        } else {
            result.notImplemented()
        }
    }

    @SuppressLint("HardwareIds")
    private fun getAndroidId(): String? {
        return Settings.Secure.getString(contentResolver, Settings.Secure.ANDROID_ID)
    }
}

