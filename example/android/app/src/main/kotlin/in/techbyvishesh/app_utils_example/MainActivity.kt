package `in`.techbyvishesh.app_utils_example

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        intent?.putExtra("name","Vishesh Pandey")
        intent?.putExtra("no",1123)
    }
}
