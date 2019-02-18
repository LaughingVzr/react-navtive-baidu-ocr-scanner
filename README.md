
# react-native-react-native-baidu-ocr-scanner

## Getting started

`$ npm install react-native-react-native-baidu-ocr-scanner --save`

### Mostly automatic installation

`$ react-native link react-native-react-native-baidu-ocr-scanner`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-react-native-baidu-ocr-scanner` and add `ReactNativeBaiduOcrScanner.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libReactNativeBaiduOcrScanner.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.laughing.ocr.ReactNativeBaiduOcrScannerPackage;` to the imports at the top of the file
  - Add `new ReactNativeBaiduOcrScannerPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-react-native-baidu-ocr-scanner'
  	project(':react-native-react-native-baidu-ocr-scanner').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-react-native-baidu-ocr-scanner/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-react-native-baidu-ocr-scanner')
  	```


## Usage
```javascript
import ReactNativeBaiduOcrScanner from 'react-native-react-native-baidu-ocr-scanner';

// TODO: What to do with the module?
ReactNativeBaiduOcrScanner;
```
  