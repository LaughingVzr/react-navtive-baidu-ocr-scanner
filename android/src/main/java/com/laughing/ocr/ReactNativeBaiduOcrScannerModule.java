
package com.laughing.ocr;

import android.util.Log;

import com.baidu.ocr.sdk.OCR;
import com.baidu.ocr.sdk.OnResultListener;
import com.baidu.ocr.sdk.exception.OCRError;
import com.baidu.ocr.sdk.model.AccessToken;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

public class ReactNativeBaiduOcrScannerModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;

    private final String LICENSE_FILE_NAME = "api.license";

    private IDCardActivity idCardActivity = new IDCardActivity();

    public ReactNativeBaiduOcrScannerModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }


    /**
     * 身份证正面扫描.
     */
    @ReactMethod
    public void IDCardFrontScanner() {
        idCardActivity.IDCardFrontScanner();
    }

    /**
     * 身份证反面扫描.
     */
    @ReactMethod
    public void IDCardBackScanner() {
        idCardActivity.IDCardBackScanner();
    }


    /**
     * 通过安全文件初始化Token.
     */
    @ReactMethod
    private void initAccessTokenLicenseFile() {
        OCR.getInstance(getCurrentActivity()).initAccessToken(new OnResultListener<AccessToken>() {
            @Override
            public void onResult(AccessToken accessToken) {
                String token = accessToken.getAccessToken();
                Log.d("zhiwei-ocr", "初始化成功");
            }

            @Override
            public void onError(OCRError error) {
                error.printStackTrace();
                Log.e("zhiwei-ocr", "初始化失败");
            }
        }, LICENSE_FILE_NAME, getReactApplicationContext());
    }


    @Override
    public String getName() {
        return "ReactNativeBaiduOcrScanner";
    }
}