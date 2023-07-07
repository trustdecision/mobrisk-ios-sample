//
//  RiskManager.m
//  Mobrisk-iOS-Sample
//
//  Created by 隐姓埋名 on 2023/7/7.
//

#import "RiskManager.h"
#import <UIKit/UIKit.h>

@implementation RiskManager
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static RiskManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[RiskManager alloc] init];
    });
    return manager;
}

- (NSString *)getSDKVersion {
    TDMobRiskManager_t *riskManager = [TDMobRiskManager sharedManager];
    NSString *sdkVersion = riskManager->getSDKVersion();
    return sdkVersion;
}

#pragma mark - TrustDevice SDK
- (void)initTrustDeviceSDK:(void (^)(NSString *blackbox))callback {
    // Get riskManager
    TDMobRiskManager_t *riskManager = [TDMobRiskManager sharedManager];
    // Initialization Configuration
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    
    /*************************** Mandatory Parameter ***************************/
    //Partner code, Refer to `Required Configuration`
    [options setValue:@"[Your partner]" forKey:@"partner"];
    //App key, Refer to `Required Configuration`
    [options setValue:@"[Your appKey]" forKey:@"appKey"];
    //App name, Refer to `Required Configuration`
    [options setValue:@"[Your appName]" forKey:@"appName"];
    //Country code, Refer to `Required Configuration`
    [options setValue:@"cn" forKey:@"country"];
    
    /*************************** Optional Parameter ***************************/
#ifdef DEBUG
    // !!! If not set this parameter in DEBUG mode, the app will terminate
    [options setValue:@"allowed" forKey:@"allowed"];
#endif
    [options setValue:^(NSString *blackbox) {
        // The callback here is in the sub-thread
        // Under normal network conditions, the results will be returned within 200-300ms.
        // If the network is abnormal, it will return after the timeout timeLimit (default: 15s).
        if (callback) {
            callback(blackbox);
        }
    } forKey:@"callback"];
    
    /*************************** Captcha Optional Parameter ***************************/
    // If you need to add captcha, please set the config
    NSDictionary *captchaOptions = [self getTrustDecisionSDKCaptchaOptions];
    [options setValuesForKeysWithDictionary:captchaOptions];
    riskManager->initWithOptions(options);
    
    _isInitSDK = YES;
}

- (NSString *)getBlackBox {
    TDMobRiskManager_t *riskManager = [TDMobRiskManager sharedManager];
    NSString *blackBox = @"InitWithOptions is not executed";
    if (_isInitSDK) {// Please confirm that you have executed the function initWithOptions once after the App starts, otherwise the SDK will be abnormal.
        blackBox = riskManager->getBlackBox();
    }
    return blackBox;
}

- (void)showCaptcha:(void (^)(TongdunShowCaptchaResultStruct resultStruct))callback {
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    TDMobRiskManager_t *riskManager = [TDMobRiskManager sharedManager];
    riskManager->showCaptcha(keyWindow,^(TongdunShowCaptchaResultStruct resultStruct) {
        if (callback) {
            callback(resultStruct);
        }
    });
}

#pragma mark - Private Method
- (NSDictionary *)getTrustDecisionSDKCaptchaOptions {
    NSMutableDictionary *captchaOptions = [NSMutableDictionary dictionary];
    /*
     1-Simplified Chinese,
     2-Traditional Chinese,
     3-English,
     4-Japanese,
     5-Korean,
     6-Malay,
     7-Thai,
     8-Indonesian,
     9-Russian
     */
    [captchaOptions setValue:@"1" forKey:@"language"];
    return [captchaOptions copy];
}

@end
