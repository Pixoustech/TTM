package com.ttm.ttm

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.google.android.gms.maps.StreetViewPanoramaOptions
import com.google.android.gms.maps.StreetViewPanoramaView
import com.google.android.gms.maps.model.LatLng
import android.widget.LinearLayout
import androidx.appcompat.widget.Toolbar
import android.graphics.Color
import android.widget.TextView
import androidx.core.content.ContextCompat

class StreetViewActivity : AppCompatActivity() {
    private lateinit var streetView: StreetViewPanoramaView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Set the status bar color
        val statusBarColor = Color.parseColor("#7E1416")
        window.statusBarColor = statusBarColor

        // Create a LinearLayout to hold the AppBar and StreetView
        val layout = LinearLayout(this)
        layout.orientation = LinearLayout.VERTICAL

        // Create a Toolbar (AppBar)
        val toolbar = Toolbar(this)
        toolbar.setBackgroundColor(statusBarColor) // Set the same color as the status bar

        // Create a TextView for the title
        val titleTextView = TextView(this)
        titleTextView.text = "Street View"
        titleTextView.setTextColor(Color.WHITE) // Set title color to white
        titleTextView.textSize = 20f // Set title text size
        titleTextView.setPadding(0, 16, 0, 16) // Add some padding

        // Add the title TextView to the Toolbar
        toolbar.addView(titleTextView)

        // Set the Toolbar as the ActionBar
        setSupportActionBar(toolbar)
        supportActionBar?.title = ""
        // Enable the Up button
        supportActionBar?.setDisplayHomeAsUpEnabled(true)

        // Set the color of the back button (up button) to white
        supportActionBar?.setHomeAsUpIndicator(R.drawable.ic_arrow_back_white) // Use a white back arrow icon

        layout.addView(toolbar)

        // Get latitude and longitude from intent
        val latitude = intent.getDoubleExtra("latitude", 0.0)
        val longitude = intent.getDoubleExtra("longitude", 0.0)

        // Create StreetViewPanoramaOptions
        val options = StreetViewPanoramaOptions().position(LatLng(latitude, longitude))
        streetView = StreetViewPanoramaView(this, options)

        // Add the StreetView to the layout
        layout.addView(streetView)

        // Set the content view to the layout
        setContentView(layout)

        // Initialize the StreetView
        streetView.onCreate(savedInstanceState)
    }

    override fun onResume() {
        super.onResume()
        streetView.onResume()
    }

    override fun onPause() {
        super.onPause()
        streetView.onPause()
    }

    override fun onDestroy() {
        super.onDestroy()
        streetView.onDestroy()
    }

    override fun onLowMemory() {
        super.onLowMemory()
        streetView.onLowMemory()
    }

    // Handle the Up button click
    override fun onSupportNavigateUp(): Boolean {
        onBackPressed() // Go back to the previous activity
        return true
    }
}