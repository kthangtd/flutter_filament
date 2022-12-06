import java.io.*
import java.nio.file.FileSystems
import java.nio.file.Files
import java.nio.file.Path
import kotlin.io.path.absolutePathString
import kotlin.io.path.listDirectoryEntries
import android.util.Log


class HotReloadPathHelper {
    companion object {
        fun getAssetPath(path: String, packageName: String): String? {
            val packagePath = "/data/user/0/${packageName}/code_cache/"
            Log.v("FFI", "Looking for path ${path} under package path ${packagePath}")
            val files = File(packagePath).walkBottomUp().filter {
              it.path.endsWith(path)
            }.sortedBy {
              Log.v("FFI", it.path.toString())
              it.lastModified()
            }.toList()
            Log.v("FFI", files.size.toString())
            if(files.size > 0)
                return files.last().path;
            return null;
          }
    }
}