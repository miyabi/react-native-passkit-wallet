package com.mybdesign.RNPassKit;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.support.v4.content.FileProvider;
import android.util.Base64;

import com.facebook.react.bridge.JSApplicationCausedNativeException;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import java.io.File;
import java.io.FileOutputStream;
import java.util.UUID;

public class RNPassKitModule extends ReactContextBaseJavaModule {
	private final String FILE_PROVIDER = "com.mybdesign.RNPassKit.fileprovider";
	private final String PKPASS_TYPE = "application/vnd.apple.pkpass";

	public RNPassKitModule(ReactApplicationContext reactContext) {
		super(reactContext);
	}

	@Override
	public String getName() {
		return "RNPassKit";
	}

	private Intent intentWithContentUri(Uri uri, String type) {
		return new Intent(Intent.ACTION_VIEW)
			.setDataAndType(uri, type)
			.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
			.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
	}

	@ReactMethod
	public void canAddPasses(Promise promise) {
		try {
			Intent intent = this.intentWithContentUri(Uri.parse("content://"), PKPASS_TYPE);
			boolean canAddPass = intent.resolveActivity(getReactApplicationContext().getPackageManager()) != null;
			promise.resolve(canAddPass);
		} catch (Exception e) {
			promise.reject(new JSApplicationCausedNativeException(e.getMessage()));
		}
	}

	@ReactMethod
	public void addPass(String base64Encoded, Promise promise) {
		try {
			Context context = getReactApplicationContext();

			File file = new File(context.getCacheDir(), UUID.randomUUID().toString() + ".pkpass");
			FileOutputStream stream = new FileOutputStream(file, true);
			stream.write(Base64.decode(base64Encoded, 0));
			stream.flush();
			stream.close();

			Uri uri = FileProvider.getUriForFile(context, FILE_PROVIDER, file);
			Intent intent = this.intentWithContentUri(uri, PKPASS_TYPE);
			context.startActivity(intent);
			promise.resolve(null);
		} catch (Exception e) {
			promise.reject(new JSApplicationCausedNativeException(e.getMessage()));
		}
	}
}
