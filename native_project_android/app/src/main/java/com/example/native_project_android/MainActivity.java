package com.example.native_project_android;

import android.os.Bundle;
import android.view.View;

import androidx.appcompat.app.AppCompatActivity;

import com.example.native_project_android.databinding.ActivityMainBinding;
import com.idlefish.flutterboost.FlutterBoost;
import com.idlefish.flutterboost.FlutterBoostRouteOptions;

import java.util.HashMap;

public class MainActivity extends AppCompatActivity {

    // Used to load the 'native_project_android' library on application startup.
    static {
        System.loadLibrary("native_project_android");
    }

    private ActivityMainBinding binding;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        binding = ActivityMainBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());
        binding.btnTest.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
//                FlutterFragment flutterFragment = FlutterFragment.withNewEngine()
//                        .initialRoute("{name:'devio',dataList:['aa','bb','bb']}")
//                        .build();
//                getSupportFragmentManager()
//                        .beginTransaction()
//                        .replace(R.id.ll_someContainer, flutterFragment)
//                        .commit();

            }
        });

        binding.btnFlutterMainPage.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                FlutterBoostRouteOptions options = new FlutterBoostRouteOptions.Builder()
                        .pageName("mainPage")
                        .arguments(new HashMap<String, Object>())
                        .requestCode(100)
                        .build();
                FlutterBoost.instance().open(options);
            }
        });

        binding.btnFlutterSimplePage.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                HashMap<String, Object> params = new HashMap<>();
                params.put("data", "hello");
                FlutterBoostRouteOptions options = new FlutterBoostRouteOptions.Builder()
                        .pageName("simplePage")
                        .arguments(params)
                        .requestCode(101)
                        .build();
                FlutterBoost.instance().open(options);
            }
        });

    }

    /**
     * A native method that is implemented by the 'native_project_android' native library,
     * which is packaged with this application.
     */
    public native String stringFromJNI();
}