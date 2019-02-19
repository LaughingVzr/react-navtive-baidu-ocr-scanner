
#import <React/RCTBridgeModule.h>

#import <React/RCTEventEmitter.h>
#import <AipOcrSdk/AipOcrSdk.h>
#import <Foundation/Foundation.h>

@interface ReactNativeBaiduOcrScanner :RCTEventEmitter <RCTBridgeModule, UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) RCTPromiseResolveBlock resolve;
@property (nonatomic, strong) RCTPromiseRejectBlock reject;
@end
  
