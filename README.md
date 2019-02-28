
# react-native-baidu-ocr-idcard-scanner

## Getting started

`$ yarn install react-native-baidu-ocr-idcard-scanner --save`

### Mostly automatic installation

`$ react-native link react-native-baidu-ocr-idcard-scanner`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to your project`
2. Go to `node_modules` ➜ `react-native-baidu-ocr-idcard-scanner` and add `ReactNativeBaiduOcrScanner.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libReactNativeBaiduOcrScanner.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Add dependencies in `ios/`(`AipBase.framework`,`AipOcrSdk.framework`,`IdcardQuality.framework`) to your project's `Build Phases` ➜ `Embed Frameworks`
5. Run your project (`Cmd+R`)<

**PS: when you release your iOS app(manual or automatic use this lib), you need fllow script:**

```bash
cd [your lib]
# see the architectures
lipo -info AipBase.framework/AipBase  # Architectures in the fat file: AipBase are: i386 x86_64 armv7 armv7s arm64
# remove x86_64, i386
lipo -remove x86_64 AipBase.framework/AipBase -o AipBase.framework/AipBase
lipo -remove i386 AipBase.framework/AipBase -o AipBase.framework/AipBase
lipo -remove x86_64 AipOcrSdk.framework/AipOcrSdk -o AipOcrSdk.framework/AipOcrSdk
lipo -remove i386 AipOcrSdk.framework/AipOcrSdk -o AipOcrSdk.framework/AipOcrSdk
# see the architectures again
lipo -info AipBase.framework/AipBase # Architectures in the fat file: AipBase are: armv7 armv7s arm64
```


#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.laughing.ocr.ReactNativeBaiduOcrScannerPackage;` to the imports at the top of the file
  - Add `new ReactNativeBaiduOcrScannerPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-baidu-ocr-idcard-scanner'
  	project(':react-native-baidu-ocr-idcard-scanner').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-baidu-ocr-idcard-scanner/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-baidu-ocr-idcard-scanner')
  	```


## Usage

```javascript
import ReactNativeBaiduOcrScanner from 'react-native-baidu-ocr-idcard-scanner';

// Authorize by BaiDu App key and App securetKey
// this method must be invoke before you invoke IDCardFrontScanner and IDCardBackScanner.
ReactNativeBaiduOcrScanner.initAccessTokenWithAkSk('ak','sk');

// Scan IDCard Front
ReactNativeBaiduOcrScanner.IDCardFrontScanner().then(function (result) {
		// Success do something by yourself
},function (error) {
    // Faild do something by yourself
});

// Scan IDCard Back
ReactNativeBaiduOcrScanner.IDCardBackScanner().then(function (result) {
		// Success do something by yourself
},function (error) {
    // Faild do something by yourself
});
```

## License

This project is provided under the MIT license. See LICENSE file for details.
