
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
                                                      NSInteger resultNum = [dict[@"words_result_num"] integerValue];
                                                      
                                                      if (resultNum>0) {
                                                          // Promise resolve
                                                          // 保存图片到相册并且获得file path
                                                          NSString* filePath =[self saveImage:image];
                                                          NSLog(@"照片路径= %@",filePath);
                                                          // 扫描的具体结果
                                                          NSDictionary* wordResult = [dict objectForKey:@"words_result"];
                                                          NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
                                                          [mutableDict setValue:filePath forKey:@"imgFilePath"];
                                                          [mutableDict setValue:[dict objectForKey:@"log_id"] forKey:@"logId"];
                                                          [mutableDict setValue:[dict objectForKey:@"words_result_num"] forKey:@"wordsResultNum"];
                                                          [mutableDict setValue:[dict objectForKey:@"image_status"] forKey:@"imageStatus"];
                                                          // 设置身份证扫描信息
                                                          [mutableDict setValue:[wordResult objectForKey:@"姓名"] forKey:@"name"];
                                                          [mutableDict setValue:[wordResult objectForKey:@"出生"] forKey:@"birthday"];
                                                          [mutableDict setValue:[wordResult objectForKey:@"公民身份号码"] forKey:@"idNumber"];
                                                          [mutableDict setValue:[wordResult objectForKey:@"性别"] forKey:@"gender"];
                                                          [mutableDict setValue:[wordResult objectForKey:@"住址"] forKey:@"address"];
                                                          [mutableDict setValue:[wordResult objectForKey:@"民族"] forKey:@"ethnic"];
                                                          // 设置方向
                                                          [mutableDict setValue:[wordResult objectForKey:@"direction"] forKey:@"direction"];
                                                          NSLog(@"识别成功回调= %@", [mutableDict yy_modelToJSONString]);
                                                          resolve([mutableDict yy_modelToJSONString]);
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
                                                     // 打印出识别结果
                                                     NSDictionary *dict = [result yy_modelToJSONObject];
                                                     
                                                     NSInteger resultNum = [dict[@"words_result_num"] integerValue];
                                                     if (resultNum>0) {
                                                        // Promise resolve
                                                        // 保存图片到相册并且获得file path
                                                        NSString* filePath =[self saveImage:image];
                                                        NSLog(@"照片路径= %@",filePath);
                                                         // 扫描的具体结果
                                                         NSDictionary* wordResult = [dict objectForKey:@"words_result"];
                                                         NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
                                                         [mutableDict setValue:filePath forKey:@"imgFilePath"];
                                                         [mutableDict setValue:[dict objectForKey:@"log_id"] forKey:@"logId"];
                                                         [mutableDict setValue:[dict objectForKey:@"words_result_num"] forKey:@"wordsResultNum"];
                                                         [mutableDict setValue:[dict objectForKey:@"image_status"] forKey:@"imageStatus"];
                                                         // 设置身份证扫描信息
                                                         [mutableDict setValue:[wordResult objectForKey:@"姓名"] forKey:@"name"];
                                                         [mutableDict setValue:[wordResult objectForKey:@"出生"] forKey:@"birthday"];
                                                         [mutableDict setValue:[wordResult objectForKey:@"公民身份号码"] forKey:@"idNumber"];
                                                         [mutableDict setValue:[wordResult objectForKey:@"性别"] forKey:@"gender"];
                                                         [mutableDict setValue:[wordResult objectForKey:@"住址"] forKey:@"address"];
                                                         [mutableDict setValue:[wordResult objectForKey:@"民族"] forKey:@"ethnic"];
                                                         // 设置方向
                                                         [mutableDict setValue:[wordResult objectForKey:@"direction"] forKey:@"direction"];
                                                        NSLog(@"识别成功回调= %@", [mutableDict yy_modelToJSONString]);
                                                        resolve([mutableDict yy_modelToJSONString]);
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

//获取当前时间戳
- (NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}


// 保存图片
- (NSString *)saveImage: (UIImage*)image
{
    if (image != nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *fileName = [[self currentTimeStr] stringByAppendingString:@".png"];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithString: fileName] ];
        NSData* data = UIImagePNGRepresentation(image);
        [data writeToFile:path atomically:YES];
        return path;
    }else{
         return @"";
    }
}

// 重写底层事件支持，以防止debug时的事件中断
- (NSArray<NSString *> *)supportedEvents {
    return @[@"onSessionConnect"];
}

@end
  
