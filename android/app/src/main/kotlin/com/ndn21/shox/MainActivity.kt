package com.ndn21.shox

import android.content.ContentValues
import android.media.MediaScannerConnection
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DOWNLOADS_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method != "saveToDownloads") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                val sourcePath = call.argument<String>("path")
                val mimeType = call.argument<String>("mimeType") ?: "application/octet-stream"
                if (sourcePath == null) {
                    result.error("INVALID_ARGS", "Missing path", null)
                    return@setMethodCallHandler
                }
                // File copy off the main thread, reply back on it.
                Thread {
                    try {
                        val location = saveToDownloads(File(sourcePath), mimeType)
                        runOnUiThread { result.success(location) }
                    } catch (e: Exception) {
                        runOnUiThread { result.error("SAVE_FAILED", e.message, null) }
                    }
                }.start()
            }
    }

    /** Copies [source] into the public Download/Shox folder and returns its relative location. */
    private fun saveToDownloads(source: File, mimeType: String): String {
        val relativeDir = "${Environment.DIRECTORY_DOWNLOADS}/$DOWNLOADS_SUBFOLDER"

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val values = ContentValues().apply {
                put(MediaStore.Downloads.DISPLAY_NAME, source.name)
                put(MediaStore.Downloads.MIME_TYPE, mimeType)
                put(MediaStore.Downloads.RELATIVE_PATH, relativeDir)
                put(MediaStore.Downloads.IS_PENDING, 1)
            }
            val resolver = contentResolver
            val uri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, values)
                ?: throw IllegalStateException("MediaStore insert failed")
            try {
                resolver.openOutputStream(uri).use { output ->
                    requireNotNull(output) { "Cannot open $uri" }
                    source.inputStream().use { it.copyTo(output) }
                }
                values.clear()
                values.put(MediaStore.Downloads.IS_PENDING, 0)
                resolver.update(uri, values, null, null)
            } catch (e: Exception) {
                resolver.delete(uri, null, null)
                throw e
            }
        } else {
            // Android 7-9: needs WRITE_EXTERNAL_STORAGE, requested on the Dart side.
            @Suppress("DEPRECATION")
            val dir = File(
                Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS),
                DOWNLOADS_SUBFOLDER,
            )
            if (!dir.exists() && !dir.mkdirs()) {
                throw IllegalStateException("Cannot create $dir")
            }
            val target = File(dir, source.name)
            source.copyTo(target, overwrite = true)
            MediaScannerConnection.scanFile(this, arrayOf(target.absolutePath), arrayOf(mimeType), null)
        }
        return "$relativeDir/${source.name}"
    }

    companion object {
        private const val DOWNLOADS_CHANNEL = "com.ndn21.shox/downloads"
        private const val DOWNLOADS_SUBFOLDER = "Shox"
    }
}
