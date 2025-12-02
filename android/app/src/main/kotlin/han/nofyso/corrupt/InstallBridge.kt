package han.nofyso.corrupt

import android.content.Context
import android.content.Intent
import android.os.Build
import android.provider.Settings
import androidx.annotation.RequiresApi
import androidx.core.content.FileProvider
import androidx.core.net.toUri
import java.io.File

/*
 * TMD，我都写Flutter了还要写原生安卓是吧？
 * 去你的安装，去你的动态权限，去你的FileProvider
 * 我真服了你了
 */
object InstallBridge {
    fun installApk(context: Context, file: File) {
        when {
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.S -> installAfter12(context, file)
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.O -> installAfter8Before12(context, file)
            else -> install(context, file)
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun installAfter12(context: Context, file: File) {
        if (checkPermissionAfter8(context)) {
            install(context, file)
            return
        }
        val intent = Intent(Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES).also {
            it.setData("package:${context.packageName}".toUri())
        }
        context.startActivity(intent)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun installAfter8Before12(context: Context, file: File) {
        if (checkPermissionAfter8(context)) {
            install(context, file)
            return
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun checkPermissionAfter8(context: Context): Boolean {
        return context.packageManager.canRequestPackageInstalls()
    }

    private fun install(context: Context, file: File) {
        val intent = Intent(Intent.ACTION_VIEW).also {
            it.putExtra("name", "")
            it.addCategory("android.intent.category.DEFAULT")
            it.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            val type = "application/vnd.android.package-archive"
            it.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            it.setDataAndType(
                FileProvider.getUriForFile(
                    context, context.packageName + ".FILE_PROVIDER", file
                ),
                type
            )
        }
        context.startActivity(intent)
    }
}