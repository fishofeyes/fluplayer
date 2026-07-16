package com.example.fluplayer

import android.content.Context
import android.telephony.TelephonyManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val _CHANNEL = "com.sim.app/device_info"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            _CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "haveSim") {
                val hasSim = checkSimCardStatus()
                result.success(hasSim)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun checkSimCardStatus(): Boolean {
        val tm = getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
        // SIM_STATE_READY 代表 SIM 卡就绪，其他状态（如 ABSENT 等）均视为无可用卡
        return tm.simState == TelephonyManager.SIM_STATE_READY
    }
}
