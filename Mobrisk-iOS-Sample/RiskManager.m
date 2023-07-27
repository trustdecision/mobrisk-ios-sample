//
//  RiskManager.m
//  Mobrisk-iOS-Sample
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
- (void)initTrustDeviceSDK {
    // Get riskManager
    TDMobRiskManager_t *riskManager = [TDMobRiskManager sharedManager];
    // Initialization Configuration
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    
    /*************************** Mandatory Parameter ***************************/
    //Partner code, Refer to `Required Configuration`
    [options setValue:@"tongdun" forKey:@"partner"];
    //App key, Refer to `Required Configuration`
    [options setValue:@"0d2e7e22f9737acbac739056aa23c738" forKey:@"appKey"];
    //App name, Refer to `Required Configuration`
    [options setValue:@"tongdun_ios" forKey:@"appName"];
    //Country code, Refer to `Required Configuration`
    [options setValue:@"cn" forKey:@"country"];
    
    /*************************** Optional Parameter ***************************/
#ifdef DEBUG
    // !!! If not set this parameter in DEBUG mode, the app will terminate
    [options setValue:@(YES) forKey:@"allowed"];
#endif
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

- (void)getBlackBoxAsync:(void (^)(NSString *blackbox))callback  {
    TDMobRiskManager_t *riskManager = [TDMobRiskManager sharedManager];
    if (_isInitSDK) {// Please confirm that you have executed the function initWithOptions once after the App starts, otherwise the SDK will be abnormal.
        riskManager->getBlackBoxAsync(^(NSString *blackBox) {
            if (callback) {
                callback(blackBox);
            }
        });
    }
}

- (void)showCaptcha:(void (^)(TDShowCaptchaResultStruct resultStruct))callback {
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    TDMobRiskManager_t *riskManager = [TDMobRiskManager sharedManager];
    riskManager->showCaptcha(keyWindow,^(TDShowCaptchaResultStruct resultStruct) {
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
