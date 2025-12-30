package com.softieons.gleekeyu
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.util.Base64
import android.util.Log
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException


class MainActivity : FlutterActivity() {

    private val CHANNEL = "deep_link_channel"
    private lateinit var deepLinkChannel: MethodChannel
    private var pendingDeepLink: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        deepLinkChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        deepLinkChannel.setMethodCallHandler { call, result ->
            if (call.method == "getInitialLink") {
                result.success(pendingDeepLink)
                pendingDeepLink = null
            } else {
                result.notImplemented()
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.P)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        printKeyHash()
        // Cache incoming deep link (app launched from killed state)
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent?) {
        val data: Uri? = intent?.data
        val url = data?.toString()
        if (url != null) {
            Log.d("DeepLink", "handleIntent url=$url, channelInitialized=${this::deepLinkChannel.isInitialized}")
            // Always cache for cold-start retrieval from Flutter splash
            pendingDeepLink = url
            // When Flutter is already running, also forward immediately
            if (this::deepLinkChannel.isInitialized) {
                deepLinkChannel.invokeMethod("onDeepLink", url)
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        handleIntent(intent)
    }

    @RequiresApi(Build.VERSION_CODES.P)
    private fun printKeyHash() {
        try {
            val packageInfo =
                packageManager.getPackageInfo(packageName, PackageManager.GET_SIGNING_CERTIFICATES)
            for (signature in packageInfo.signingInfo?.apkContentsSigners!!) {
                val md = MessageDigest.getInstance("SHA")
                md.update(signature.toByteArray())
                val keyHash = Base64.encodeToString(md.digest(), Base64.NO_WRAP)
                Log.e("KeyHash----------->>>>>>>", "Key Hash: $keyHash")
            }
        } catch (e: PackageManager.NameNotFoundException) {
            e.printStackTrace()
        } catch (e: NoSuchAlgorithmException) {
            e.printStackTrace()
        }
    }
}