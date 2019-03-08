package com.australia.house;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.content.res.Configuration;
import android.content.res.Resources.NotFoundException;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.util.Log;
import android.util.TypedValue;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager.LayoutParams;

import java.util.ArrayList;

import io.flutter.app.FlutterActivityEvents;
import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.util.Preconditions;
import io.flutter.view.FlutterMain;
import io.flutter.view.FlutterNativeView;
import io.flutter.view.FlutterRunArguments;
import io.flutter.view.FlutterView;
import io.flutter.view.FlutterView.FirstFrameListener;
import io.flutter.view.FlutterView.Provider;

public final class FlutterActivityDelegate implements FlutterActivityEvents, Provider, PluginRegistry {
    private static final LayoutParams matchParent = new LayoutParams(-1, -1);
    private final Activity activity;
    private final ViewFactory viewFactory;
    private FlutterView flutterView;
    private View launchView;

    FlutterActivityDelegate(Activity activity, ViewFactory viewFactory) {
        this.activity = Preconditions.checkNotNull(activity);
        this.viewFactory = Preconditions.checkNotNull(viewFactory);
    }

    public FlutterView getFlutterView() {
        return this.flutterView;
    }

    public boolean hasPlugin(String key) {
        return this.flutterView.getPluginRegistry().hasPlugin(key);
    }

    public <T> T valuePublishedByPlugin(String pluginKey) {
        return this.flutterView.getPluginRegistry().valuePublishedByPlugin(pluginKey);
    }

    public Registrar registrarFor(String pluginKey) {
        return this.flutterView.getPluginRegistry().registrarFor(pluginKey);
    }

    public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        return this.flutterView.getPluginRegistry().onRequestPermissionsResult(requestCode, permissions, grantResults);
    }

    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        return this.flutterView.getPluginRegistry().onActivityResult(requestCode, resultCode, data);
    }

    public void onCreate(Bundle savedInstanceState) {
        String[] args = getArgsFromIntent(this.activity.getIntent());
        FlutterMain.ensureInitializationComplete(this.activity.getApplicationContext(), args);
        this.flutterView = this.viewFactory.createFlutterView(this.activity);
        if (this.flutterView == null) {
            FlutterNativeView nativeView = this.viewFactory.createFlutterNativeView();
            this.flutterView = new FlutterView(this.activity, null, nativeView);
            this.flutterView.setLayoutParams(matchParent);
            this.activity.setContentView(this.flutterView);
            this.launchView = this.createLaunchView();
            if (this.launchView != null) {
                this.addLaunchView();
            }
        }

        if (!this.loadIntent(this.activity.getIntent())) {
            if (!this.flutterView.getFlutterNativeView().isApplicationRunning()) {
                String appBundlePath = FlutterMain.findAppBundlePath(this.activity.getApplicationContext());
                if (appBundlePath != null) {
                    FlutterRunArguments arguments = new FlutterRunArguments();
                    arguments.bundlePath = appBundlePath;
                    arguments.entrypoint = "main";
                    this.flutterView.runFromBundle(arguments);
                }
            }

        }
    }

    public void onNewIntent(Intent intent) {
        if (!this.isDebuggable() || !this.loadIntent(intent)) {
            this.flutterView.getPluginRegistry().onNewIntent(intent);
        }

    }

    private boolean isDebuggable() {
        return (this.activity.getApplicationInfo().flags & 2) != 0;
    }

    public void onPause() {
        Application app = (Application) this.activity.getApplicationContext();
        if (app instanceof FlutterApplication) {
            FlutterApplication flutterApp = (FlutterApplication) app;
            if (this.activity.equals(flutterApp.getCurrentActivity())) {
                flutterApp.setCurrentActivity(null);
            }
        }

        if (this.flutterView != null) {
            this.flutterView.onPause();
        }

    }

    public void onStart() {
        if (this.flutterView != null) {
            this.flutterView.onStart();
        }

    }

    public void onResume() {
        Application app = (Application) this.activity.getApplicationContext();
        if (app instanceof FlutterApplication) {
            FlutterApplication flutterApp = (FlutterApplication) app;
            flutterApp.setCurrentActivity(this.activity);
        }

    }

    public void onStop() {
        this.flutterView.onStop();
    }

    public void onPostResume() {
        if (this.flutterView != null) {
            this.flutterView.onPostResume();
        }

    }

    public void onDestroy() {
        Application app = (Application) this.activity.getApplicationContext();
        if (app instanceof FlutterApplication) {
            FlutterApplication flutterApp = (FlutterApplication) app;
            if (this.activity.equals(flutterApp.getCurrentActivity())) {
                flutterApp.setCurrentActivity(null);
            }
        }

        if (this.flutterView != null) {
            boolean detach = this.flutterView.getPluginRegistry().onViewDestroy(this.flutterView.getFlutterNativeView());
            if (!detach && !this.viewFactory.retainFlutterNativeView()) {
                this.flutterView.destroy();
            } else {
                this.flutterView.detach();
            }
        }

    }

    public boolean onBackPressed() {
        if (this.flutterView != null) {
            this.flutterView.popRoute();
            return true;
        } else {
            return false;
        }
    }

    public void onUserLeaveHint() {
        this.flutterView.getPluginRegistry().onUserLeaveHint();
    }

    public void onTrimMemory(int level) {
        if (level == 10) {
            this.flutterView.onMemoryPressure();
        }

    }

    public void onLowMemory() {
        this.flutterView.onMemoryPressure();
    }

    public void onConfigurationChanged(Configuration newConfig) {
    }

    private static String[] getArgsFromIntent(Intent intent) {
        ArrayList<String> args = new ArrayList<>();
        if (intent.getBooleanExtra("trace-startup", false)) {
            args.add("--trace-startup");
        }

        if (intent.getBooleanExtra("start-paused", false)) {
            args.add("--start-paused");
        }

        if (intent.getBooleanExtra("use-test-fonts", false)) {
            args.add("--use-test-fonts");
        }

        if (intent.getBooleanExtra("enable-dart-profiling", false)) {
            args.add("--enable-dart-profiling");
        }

        if (intent.getBooleanExtra("enable-software-rendering", false)) {
            args.add("--enable-software-rendering");
        }

        if (intent.getBooleanExtra("skia-deterministic-rendering", false)) {
            args.add("--skia-deterministic-rendering");
        }

        if (intent.getBooleanExtra("trace-skia", false)) {
            args.add("--trace-skia");
        }

        if (intent.getBooleanExtra("verbose-logging", false)) {
            args.add("--verbose-logging");
        }

        if (!args.isEmpty()) {
            String[] argsArray = new String[args.size()];
            return args.toArray(argsArray);
        } else {
            return null;
        }
    }

    private boolean loadIntent(Intent intent) {
        String action = intent.getAction();
        if ("android.intent.action.RUN".equals(action)) {
            String route = intent.getStringExtra("route");
            String appBundlePath = intent.getDataString();
            if (appBundlePath == null) {
                appBundlePath = FlutterMain.findAppBundlePath(this.activity.getApplicationContext());
            }

            if (route != null) {
                this.flutterView.setInitialRoute(route);
            }

            if (!this.flutterView.getFlutterNativeView().isApplicationRunning()) {
                FlutterRunArguments args = new FlutterRunArguments();
                args.bundlePath = appBundlePath;
                args.entrypoint = "main";
                this.flutterView.runFromBundle(args);
            }

            return true;
        } else {
            return false;
        }
    }

    private View createLaunchView() {
        if (!this.showSplashScreenUntilFirstFrame()) {
            return null;
        } else {
            Drawable launchScreenDrawable = this.getLaunchScreenDrawableFromActivityTheme();
            if (launchScreenDrawable == null) {
                return null;
            } else {
                View view = new View(this.activity);
                view.setLayoutParams(matchParent);
                view.setBackground(launchScreenDrawable);
                return view;
            }
        }
    }

    private Drawable getLaunchScreenDrawableFromActivityTheme() {
        TypedValue typedValue = new TypedValue();
        if (!this.activity.getTheme().resolveAttribute(16842836, typedValue, true)) {
            return null;
        } else if (typedValue.resourceId == 0) {
            return null;
        } else {
            try {
                return this.activity.getResources().getDrawable(typedValue.resourceId);
            } catch (NotFoundException var3) {
                Log.e("FlutterActivityDelegate", "Referenced launch screen windowBackground resource does not exist");
                return null;
            }
        }
    }

    private Boolean showSplashScreenUntilFirstFrame() {
        try {
            ActivityInfo activityInfo = this.activity.getPackageManager().getActivityInfo(this.activity.getComponentName(), PackageManager.GET_META_DATA);
            Bundle metadata = activityInfo.metaData;
            return metadata != null && metadata.getBoolean("io.flutter.app.android.SplashScreenUntilFirstFrame");
        } catch (NameNotFoundException var3) {
            return false;
        }
    }

    private void addLaunchView() {
        if (this.launchView != null) {
            this.activity.addContentView(this.launchView, matchParent);
            this.flutterView.addFirstFrameListener(new FirstFrameListener() {
                public void onFirstFrame() {
                    FlutterActivityDelegate.this.launchView.animate().alpha(0.0F).setListener(new AnimatorListenerAdapter() {
                        public void onAnimationEnd(Animator animation) {
                            ((ViewGroup) FlutterActivityDelegate.this.launchView.getParent()).removeView(FlutterActivityDelegate.this.launchView);
                            FlutterActivityDelegate.this.launchView = null;
                        }
                    });
                    FlutterActivityDelegate.this.flutterView.removeFirstFrameListener(this);
                }
            });
        }
    }

    public interface ViewFactory {
        FlutterView createFlutterView(Context var1);

        FlutterNativeView createFlutterNativeView();

        boolean retainFlutterNativeView();
    }
}
