//
//  PrivacyAgreeViewController.h
//  Mobrisk-iOS-Sample
//
//  Created by 隐姓埋名 on 2023/7/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PrivacyAgreeViewController;
@protocol PrivacyAgreeViewControllerDelegate <NSObject>
- (void)privacyAgreeViewController:(PrivacyAgreeViewController *)paViewController result:(BOOL)result;
@end

@interface PrivacyAgreeViewController : UIViewController
@property (nonatomic, weak) id<PrivacyAgreeViewControllerDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
