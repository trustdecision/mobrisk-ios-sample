//
//  RiskManager.h
//  Mobrisk-iOS-Sample
//
//

#import <Foundation/Foundation.h>
#import <TDMobRisk/TDMobRisk.h>

NS_ASSUME_NONNULL_BEGIN

@interface RiskManager : NSObject
/// Get a manager
+ (instancetype)sharedManager;
/// Init SDK
- (void)initTrustDeviceSDK:(void (^)(NSString *blackbox))callback;
/// Get blackBox
- (NSString *)getBlackBox;
/// Get sdkVersion
- (NSString *)getSDKVersion;
/// Show captcha
- (void)showCaptcha:(void (^)(TongdunShowCaptchaResultStruct resultStruct))callback;

/// isInitSDK
@property (atomic, assign) BOOL isInitSDK;
@end

NS_ASSUME_NONNULL_END
