package com.ttm.ttm

import android.content.Intent
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "com.ttm.streetview"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Setting up the MethodChannel for Flutter-Dart communication
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "launchStreetView" -> {
                        val latitude = call.argument<Double>("latitude") ?: 0.0
                        val longitude = call.argument<Double>("longitude") ?: 0.0
                        launchStreetView(latitude, longitude)
                        result.success(null) // Notify Dart of successful execution
                    }
                    else -> {
                        result.notImplemented() // Handle unsupported method calls
                    }
                }
            }
    }

    /**
     * Launches the StreetViewActivity with the provided latitude and longitude.
     *
     * @param latitude The latitude to show in Street View.
     * @param longitude The longitude to show in Street View.
     */
    private fun launchStreetView(latitude: Double, longitude: Double) {
        val intent = Intent(this, StreetViewActivity::class.java).apply {
            putExtra("latitude", latitude)
            putExtra("longitude", longitude)
        }
        startActivity(intent)
    }
}
