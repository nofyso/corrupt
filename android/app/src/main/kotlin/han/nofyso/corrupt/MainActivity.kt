package han.nofyso.corrupt

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    val updateBridge = "han.nofyso.corrupt"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            updateBridge
        ).setMethodCallHandler { call, result ->
            if (call.method == "performAndroidInstall") {
                val path = call.argument<String>("path")
                if (path == null) {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                InstallBridge.installApk(this@MainActivity, File(path))
                result.success(Unit)
                return@setMethodCallHandler
            }
            result.notImplemented()
        }
    }
}
