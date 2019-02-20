
#import "ReactNativeBaiduOcrScanner.h"
#import "YYModel.h"

@implementation ReactNativeBaiduOcrScanner
@synthesize bridge = _bridge;
RCT_EXPORT_MODULE()

-(instancetype) init{
    self = [super init];
    
    return self;
}

// ViewController
- (UIViewController*) getRootVC {
    UIViewController *root = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (root.presentedViewController != nil) {
        root = root.presentedViewController;
    }
    return root;
}

//初始化
RCT_EXPORT_METHOD(initAccessTokenWithAkSk:(NSString*)ak  sk:(NSString*)sk)
{
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSLog(@"ak=%@ sk=%@ bundleID=%@", ak, sk,bundleIdentifier);
    [[AipOcrService shardService] authWithAK:ak andSK:sk];
//    callback(@[[NSNumber numberWithInt:0]]);
}


// 扫描身份证正面
RCT_REMAP_METHOD(IDCardFrontScanner,
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseResolveBlock)reject){
    UIViewController * vc =
    [AipCaptureCardVC ViewControllerWithCardType:CardTypeLocalIdCardFont andImageHandler:^(UIImage *image) {
        // 成功扫描出身份证
        [[AipOcrService shardService] detectIdCardFrontFromImage:image
                                                     withOptions:nil
                                                  successHandler:^(id result){
                                                      // 在成功回调中，保存图片到系统相册
                                                      UIImageWriteToSavedPhotosAlbum(image, nil, nil, (__bridge void *)self);
                                                      // 打印出识别结果
                                                      NSDictionary *dict = [result yy_modelToJSONObject];
                                                      NSLog(@"识别成功回调= %@", [result yy_modelToJSONString]);
                                                      NSInteger resultNum = [dict[@"words_result_num"] integerValue];
                                                      if (resultNum>0) {
                                                          // Promise resolve
                                                          resolve([result yy_modelToJSONString]);
                                                      }else{
                                                          // Promise reject
                                                          reject([result yy_modelToJSONString]);
                                                      }
                                                      // 关闭扫描界面
                                                      [[self getRootVC].presentingViewController dismissViewControllerAnimated:YES completion:nil ];
                                                  }
                                                     failHandler:^(NSError *error){
                                                         NSLog(@"%@", [error localizedDescription]);
                                                         // Promise reject
                                                         reject([error yy_modelToJSONString]);
                                                     }];
    }];
    // 展示ViewController
    [[self getRootVC] presentViewController: vc animated:YES completion:nil];
}

// 扫描身份证反面
RCT_REMAP_METHOD(IDCardBackScanner,
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseResolveBlock)reject){
    UIViewController * vc =
    [AipCaptureCardVC ViewControllerWithCardType:CardTypeLocalIdCardFont andImageHandler:^(UIImage *image) {
        // 成功扫描出身份证
        [[AipOcrService shardService] detectIdCardBackFromImage:image
                                                    withOptions:nil
                                                 successHandler:^(id result){
                                                     // 在成功回调中，保存图片到系统相册
                                                     UIImageWriteToSavedPhotosAlbum(image, nil, nil, (__bridge void *)self);
                                                     // 打印出识别结果
                                                     NSDictionary *dict = [result yy_modelToJSONObject];
                                                     NSLog(@"识别成功回调= %@", [result yy_modelToJSONString]);
                                                     NSInteger resultNum = [dict[@"words_result_num"] integerValue];
                                                     if (resultNum>0) {
                                                         // Promise resolve
                                                          resolve([result yy_modelToJSONString]);
                                                     }else{
                                                         // Promise reject
                                                          reject([result yy_modelToJSONString]);
                                                     }
                                                     // 关闭扫描界面
                                                     [[self getRootVC].presentingViewController dismissViewControllerAnimated:YES completion:nil ];
                                                 }
                                                    failHandler:^(NSError *error){
                                                        NSLog(@"%@", [error localizedDescription]);
                                                        // Promise reject
                                                        reject([error yy_modelToJSONString]);
                                                    }];
    }];
    // 展示ViewController
    [[self getRootVC] presentViewController: vc animated:YES completion:nil];
}

-(void) idCardFrontScanner:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject{
    
}

// 扫描身份证反面
-(void) idCardBackScanner{
    
}
@end
  
