//
//  PrivacyAgreeViewController.h
//  Mobrisk-iOS-Sample
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
