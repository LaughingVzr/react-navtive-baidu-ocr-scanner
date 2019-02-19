
#import "ReactNativeBaiduOcrScanner.h"

@implementation ReactNativeBaiduOcrScanner
@synthesize bridge = _bridge;
- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()


-(instancetype) init{
    self = [super init];
    
    //添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessageContent:) name:@"Scan_Send_Message" object:nil];
    
    return self;
}

- (UIViewController*) getRootVC {
    UIViewController *root = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (root.presentedViewController != nil) {
        root = root.presentedViewController;
    }
    return root;
}

//初始化
RCT_EXPORT_METHOD(initAccessTokenWithAkSk:(NSString*)ak  sk:(NSString*)sk  callback:(RCTResponseSenderBlock)callback)
{
    NSLog(@"ak=%@ sk=%@", ak, sk);
    [[AipOcrService shardService] authWithAK:ak andSK:sk];
    callback(@[[NSNumber numberWithInt:0]]);
}

-(void) IDCardFrontScanner{
    UIViewController * vc =
    [AipCaptureCardVC ViewControllerWithCardType:CardTypeLocalIdCardFont andImageHandler:^(UIImage *image) {
        // 成功扫描出身份证
        [[AipOcrService shardService] detectIdCardFrontFromImage:image
                                                     withOptions:nil
                                                  successHandler:^(id result){
                                                      // 在成功回调中，保存图片到系统相册
                                                      UIImageWriteToSavedPhotosAlbum(image, nil, nil, (__bridge void *)self);
                                                      // 打印出识别结果
                                                      NSLog(@"%@", result);
                                                  }
                                                     failHandler:^(NSError *error){
                                                         
                                                     }];
    }];
    // 展示ViewController
    [[self getRootVC] presentViewController: vc animated:YES completion:nil];
}

-(void) IDCardBackScanner{
    UIViewController * vc =
    [AipCaptureCardVC ViewControllerWithCardType:CardTypeLocalIdCardFont andImageHandler:^(UIImage *image) {
        // 成功扫描出身份证
        [[AipOcrService shardService] detectIdCardBackFromImage:image
                                                     withOptions:nil
                                                  successHandler:^(id result){
                                                      // 在成功回调中，保存图片到系统相册
                                                      UIImageWriteToSavedPhotosAlbum(image, nil, nil, (__bridge void *)self);
                                                      // 打印出识别结果
                                                      NSLog(@"%@", result);
                                                  }
                                                    failHandler:^(NSError *error){
                                                        
                                                    }];
    }];
    // 展示ViewController
    [[self getRootVC] presentViewController: vc animated:YES completion:nil];
}
@end
  
