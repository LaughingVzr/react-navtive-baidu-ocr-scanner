
#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif

#import <React/RCTEventEmitter.h>
#import <AipOcrSdk/AipOcrSdk.h>
#import <Foundation/Foundation.h>

@interface ReactNativeBaiduOcrScanner :RCTEventEmitter <RCTBridgeModule, UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) RCTPromiseResolveBlock resolve;
@property (nonatomic, strong) RCTPromiseRejectBlock reject;
@end
  
