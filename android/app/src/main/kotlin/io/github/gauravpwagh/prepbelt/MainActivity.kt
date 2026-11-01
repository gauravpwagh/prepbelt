package io.github.gauravpwagh.prepbelt

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var folder: StudyFolderChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val channel = StudyFolderChannel(this)
        folder = channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, StudyFolderChannel.NAME)
            .setMethodCallHandler(channel)
    }

    @Deprecated("Activity results still arrive here for startActivityForResult")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (folder?.onActivityResult(requestCode, resultCode, data) == true) return
        super.onActivityResult(requestCode, resultCode, data)
    }
}
