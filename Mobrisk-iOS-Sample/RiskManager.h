//
//  RiskManager.h
//  Mobrisk-iOS-Sample
//

#import <Foundation/Foundation.h>
#import <TDMobRisk/TDMobRisk.h>

NS_ASSUME_NONNULL_BEGIN

@interface RiskManager : NSObject
/// Get a manager
+ (instancetype)sharedManager;
/// Init SDK
- (void)initTrustDeviceSDK;
/// Get blackBox
- (NSString *)getBlackBox;
/// Get blackBox Async callback
- (void)getBlackBoxAsync:(void (^)(NSString *blackbox))callback;
/// Get sdkVersion
- (NSString *)getSDKVersion;
/// Show captcha
- (void)showCaptcha:(void (^)(TDShowCaptchaResultStruct resultStruct))callback;

/// isInitSDK
@property (atomic, assign) BOOL isInitSDK;
@end

NS_ASSUME_NONNULL_END
