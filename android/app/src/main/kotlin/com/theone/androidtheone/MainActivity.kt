package com.theone.androidtheone

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import android.content.Context
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.os.PersistableBundle
import android.util.Base64
import android.util.Log
import androidx.annotation.NonNull
import androidx.appcompat.app.AppCompatDelegate
import com.facebook.FacebookSdk
import com.facebook.FacebookSdk.setAdvertiserIDCollectionEnabled
import com.facebook.FacebookSdk.setAutoLogAppEventsEnabled
import com.facebook.LoggingBehavior
import io.flutter.plugins.GeneratedPluginRegistrant
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException
class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
//        Added line

        FacebookSdk.setApplicationId("485115409812800")
        FacebookSdk.sdkInitialize(applicationContext)
        FacebookSdk.fullyInitialize();
        super.onCreate(savedInstanceState, persistentState)

                                                 
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        AppCompatDelegate.setCompatVectorFromResourcesEnabled(true)

        setAutoLogAppEventsEnabled(true)
        FacebookSdk.setAutoInitEnabled(true)
        setAdvertiserIDCollectionEnabled(true)
        FacebookSdk.setIsDebugEnabled(true);
        FacebookSdk.addLoggingBehavior(LoggingBehavior.APP_EVENTS);
    }


}
