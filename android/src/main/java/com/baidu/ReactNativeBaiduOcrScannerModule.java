
package com.baidu;

import android.app.Activity;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.util.Log;

import com.alibaba.fastjson.JSON;
import com.baidu.ocr.sdk.OCR;
import com.baidu.ocr.sdk.OnResultListener;
import com.baidu.ocr.sdk.exception.OCRError;
import com.baidu.ocr.sdk.model.AccessToken;
import com.baidu.ocr.sdk.model.IDCardParams;
import com.baidu.ocr.sdk.model.IDCardResult;
import com.baidu.ocr.ui.camera.CameraActivity;
import com.baidu.ocr.ui.camera.CameraNativeHelper;
import com.baidu.ocr.ui.camera.CameraView;
import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.BaseActivityEventListener;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import java.io.File;

public class ReactNativeBaiduOcrScannerModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;

    private final String LICENSE_FILE_NAME = "api.license";


    private Promise globalPromise;
    private static final int REQUEST_CODE_PICK_IMAGE_FRONT = 201;
    private static final int REQUEST_CODE_PICK_IMAGE_BACK = 202;
    private static final int REQUEST_CODE_CAMERA = 102;


    public ReactNativeBaiduOcrScannerModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
        reactContext.addActivityEventListener(activityEventListener);
    }


    /**
     * 身份证正面扫描.
     */
    @ReactMethod
    public void IDCardFrontScanner(Promise promise) {
        this.globalPromise = promise;
        Intent intent = new Intent(getReactApplicationContext(), CameraActivity.class);
        intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH,
                FileUtil.getSaveFile(getReactApplicationContext()).getAbsolutePath());
        intent.putExtra(CameraActivity.KEY_NATIVE_ENABLE,
                true);
        // KEY_NATIVE_MANUAL设置了之后CameraActivity中不再自动初始化和释放模型
        // 请手动使用CameraNativeHelper初始化和释放模型
        // 推荐这样做，可以避免一些activity切换导致的不必要的异常
        intent.putExtra(CameraActivity.KEY_NATIVE_MANUAL,
                true);
        intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, CameraActivity.CONTENT_TYPE_ID_CARD_FRONT);
        getCurrentActivity().startActivityForResult(intent, REQUEST_CODE_CAMERA);
    }


    /**
     * 身份证反面扫描.
     */
    @ReactMethod
    public void IDCardBackScanner(Promise promise) {
        this.globalPromise = promise;
        Intent intent = new Intent(getReactApplicationContext(), CameraActivity.class);
        intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH,
                FileUtil.getSaveFile(getCurrentActivity().getApplication()).getAbsolutePath());
        intent.putExtra(CameraActivity.KEY_NATIVE_ENABLE,
                true);
        // KEY_NATIVE_MANUAL设置了之后CameraActivity中不再自动初始化和释放模型
        // 请手动使用CameraNativeHelper初始化和释放模型
        // 推荐这样做，可以避免一些activity切换导致的不必要的异常
        intent.putExtra(CameraActivity.KEY_NATIVE_MANUAL,
                true);
        intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, CameraActivity.CONTENT_TYPE_ID_CARD_BACK);
        getCurrentActivity().startActivityForResult(intent, REQUEST_CODE_CAMERA);
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
                initAuth();
            }

            @Override
            public void onError(OCRError error) {
                error.printStackTrace();
                Log.e("zhiwei-ocr", "初始化失败");
            }
        }, LICENSE_FILE_NAME, getReactApplicationContext());
    }

    /**
     * 用明文ak，sk初始化
     */
    @ReactMethod
    private void initAccessTokenWithAkSk(String apiKey, String secureKey) {
        OCR.getInstance(getCurrentActivity()).initAccessTokenWithAkSk(new OnResultListener<AccessToken>() {
            @Override
            public void onResult(AccessToken result) {
                String token = result.getAccessToken();
                initAuth();
            }

            @Override
            public void onError(OCRError error) {
                error.printStackTrace();
                Log.e("zhiwei-ocr", error.getMessage());
            }
        }, getCurrentActivity().getApplicationContext(), apiKey, secureKey);
    }

    /**
     * 初始化鉴权.
     */
    private void initAuth() {
        //  初始化本地质量控制模型,释放代码在onDestory中
        //  调用身份证扫描必须加上 intent.putExtra(CameraActivity.KEY_NATIVE_MANUAL, true); 关闭自动初始化和释放本地模型
        CameraNativeHelper.init(getCurrentActivity(), OCR.getInstance(getCurrentActivity()).getLicense(),
                new CameraNativeHelper.CameraNativeInitCallback() {
                    @Override
                    public void onError(int errorCode, Throwable e) {
                        String msg;
                        switch (errorCode) {
                            case CameraView.NATIVE_SOLOAD_FAIL:
                                msg = "加载so失败，请确保apk中存在ui部分的so";
                                break;
                            case CameraView.NATIVE_AUTH_FAIL:
                                msg = "授权本地质量控制token获取失败";
                                break;
                            case CameraView.NATIVE_INIT_FAIL:
                                msg = "本地质量控制";
                                break;
                            default:
                                msg = String.valueOf(errorCode);
                        }
                        Log.e("zhiwei-ocr", "本地质量控制初始化错误，错误原因： " + msg);
                    }
                });
    }

    /**
     * 监听Activity的事件返回.
     */
    private final ActivityEventListener activityEventListener = new BaseActivityEventListener() {

        @Override
        public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
            super.onActivityResult(activity, requestCode, resultCode, data);
            if (globalPromise != null && requestCode == REQUEST_CODE_PICK_IMAGE_FRONT && resultCode == Activity.RESULT_OK) {
                Uri uri = data.getData();
                String filePath = getRealPathFromURI(uri);
                recIDCard(IDCardParams.ID_CARD_SIDE_FRONT, filePath);
            }

            if (globalPromise != null && requestCode == REQUEST_CODE_PICK_IMAGE_BACK && resultCode == Activity.RESULT_OK) {
                Uri uri = data.getData();
                String filePath = getRealPathFromURI(uri);
                recIDCard(IDCardParams.ID_CARD_SIDE_BACK, filePath);
            }

            if (globalPromise != null && requestCode == REQUEST_CODE_CAMERA && resultCode == Activity.RESULT_OK) {
                if (data != null) {
                    String contentType = data.getStringExtra(CameraActivity.KEY_CONTENT_TYPE);
                    String filePath = FileUtil.getSaveFile(getCurrentActivity()
                            .getApplicationContext()).getAbsolutePath();
                    if (!TextUtils.isEmpty(contentType)) {
                        if (CameraActivity.CONTENT_TYPE_ID_CARD_FRONT.equals(contentType)) {
                            recIDCard(IDCardParams.ID_CARD_SIDE_FRONT, filePath);
                        } else if (CameraActivity.CONTENT_TYPE_ID_CARD_BACK.equals(contentType)) {
                            recIDCard(IDCardParams.ID_CARD_SIDE_BACK, filePath);
                        }
                    }
                }
            }
        }
    };


    private void recIDCard(String idCardSide, String filePath) {
        IDCardParams param = new IDCardParams();
        param.setImageFile(new File(filePath));
        // 设置身份证正反面
        param.setIdCardSide(idCardSide);
        // 设置方向检测
        param.setDetectDirection(true);
        // 设置图像参数压缩质量0-100, 越大图像质量越好但是请求时间越长。 不设置则默认值为20
        param.setImageQuality(20);

        OCR.getInstance(getCurrentActivity()).recognizeIDCard(param, new OnResultListener<IDCardResult>() {
            @Override
            public void onResult(IDCardResult result) {
                if (result != null) {
                    // TODO: 判断结果并返回promise
                    if (result.getWordsResultNumber() > 0) {
                        globalPromise.resolve(JSON.toJSONString(result));
                    } else {
                        globalPromise.resolve(JSON.toJSONString(result));
                    }
                    Log.d("zhiwei-ocr", result.toString());
                }
            }

            @Override
            public void onError(OCRError error) {
                globalPromise.reject("-1", error.getMessage());
                Log.e("zhiwei-ocr", error.getMessage());
            }
        });
    }

    private String getRealPathFromURI(Uri contentURI) {
        String result;
        Cursor cursor = getCurrentActivity()
                .getContentResolver().query(contentURI, null, null, null, null);
        if (cursor == null) { // Source is Dropbox or other similar local file path
            result = contentURI.getPath();
        } else {
            cursor.moveToFirst();
            int idx = cursor.getColumnIndex(MediaStore.Images.ImageColumns.DATA);
            result = cursor.getString(idx);
            cursor.close();
        }
        return result;
    }

    @Override
    public String getName() {
        return "ReactNativeBaiduOcrScanner";
    }
}