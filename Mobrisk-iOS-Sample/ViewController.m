//
//  ViewController.m
//  Mobrisk-iOS-Sample
//
//

#import "ViewController.h"
#import "PrivacyAgreeViewController.h"
#import "RiskManager.h"

@interface ViewController () <PrivacyAgreeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *outputTextView;
@end

@implementation ViewController

#pragma mark - view Func
- (void)viewDidLoad {
    [super viewDidLoad];
    // Show Tips
    [self showTipsWithCallback:nil];
    // UI config
    [self initUI];
    
}

#pragma mark - UI
- (void)initUI {
    self.outputTextView.layer.cornerRadius = 5;
    self.outputTextView.layer.borderColor = UIColor.grayColor.CGColor;
    self.outputTextView.layer.borderWidth = 0.5;
}

#pragma mark - IB Event
- (IBAction)getSDKVersionClick:(id)sender {
    RiskManager *manager = [RiskManager sharedManager];
    NSString *sdkVersion = [manager getSDKVersion];
    self.outputTextView.text = [NSString stringWithFormat:@"sdkVersion: %@",sdkVersion];
}

- (IBAction)initWithOptionCallbackClick:(id)sender {
    // You need to initialize the SDK for data collection after the user agrees to your company's privacy agreement
    BOOL isAgreeAgreement = [[NSUserDefaults standardUserDefaults] boolForKey:@"td_isAgreeAgreement"];
    if (!isAgreeAgreement) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PrivacyAgreeViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"PrivacyAgreeViewController"];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [self initSDK];
    }
}

- (IBAction)getBlackBoxClick:(id)sender {
    // Get BlackBox
    RiskManager *manager = [RiskManager sharedManager];
    if (manager.isInitSDK) {
        NSString *blackbox = manager.getBlackBox;
        self.outputTextView.text =  [NSString stringWithFormat:@"blackBox: %@",blackbox];
    }else {
        self.outputTextView.text = [NSString stringWithFormat:@"❗️❗️❗️An exception will occur in the SDK, because you have not executed the initWithOptions function once after the application starts❗️❗️❗️"];
    }
}

- (IBAction)showCaptchaClick:(id)sender {
    // Show captcha
    [self showTipsWithCallback:^{
        RiskManager *manager = [RiskManager sharedManager];
        [manager showCaptcha:^(TongdunShowCaptchaResultStruct resultStruct) {
            switch (resultStruct. resultType) {
                case TongdunShowCaptchaResultTypeSuccess:
                {
                    NSString * validateToken = resultStruct.validateToken;
                    self.outputTextView.text = [NSString stringWithFormat:@"🎉🎉🎉Obtain TrustDecision Captcha successfully!!!🎉🎉🎉\nValidateToken:%@",validateToken];
                    NSLog(@"🎉🎉🎉Obtain TrustDecision Captcha successfully!!!🎉🎉🎉\nValidateToken:%@",validateToken);
                }
                    break;
                case TongdunShowCaptchaResultTypeFailed:
                {
                    NSString * errorMsg = resultStruct. errorMsg;
                    self.outputTextView.text = [NSString stringWithFormat:@"😫😫😫Get TrustDecision Captcha failed!!!😫😫😫\nErrorCode:%ld, errorMsg:%@",resultStruct.errorCode,errorMsg];
                    NSLog(@"😫😫😫Get TrustDecision Captcha failed😫😫😫\nErrorCode:%ld, errorMsg:%@",resultStruct.errorCode,errorMsg);
                }
                    break;
                case TongdunShowCaptchaResultTypeReady:
                    self.outputTextView.text = @"⌛️⌛️⌛️Captcha window popup is successful, waiting to be verified!!!⌛️⌛️⌛️";
                    NSLog(@"⌛️⌛️⌛️Captcha window popup is successful, waiting to be verified!!!⌛️⌛️⌛️");
                    break;
                default:
                    break;
            }
        }];
    }];
}

#pragma mark - PrivacyAgreeViewControllerDelegate
- (void)privacyAgreeViewController:(PrivacyAgreeViewController *)paViewController result:(BOOL)result {
    if (result) {
        [self initSDK];
    }
}

#pragma mark - Private Methods
- (void)initSDK {
    [self showTipsWithCallback:^{
        RiskManager *manager = [RiskManager sharedManager];
        [manager initTrustDeviceSDK:^(NSString * _Nonnull blackbox) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.outputTextView.text = [NSString stringWithFormat:@"blackBox:%@",blackbox];
            });
        }];
        // set use's privacy agreement status
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"td_isAgreeAgreement"];
    }];
}

- (void)showTipsWithCallback:(void (^)(void))callback {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Tip" message:@"Please fill in your own initialization parameters (partner, appKey, appName, country), otherwise the SDK will be abnormal." preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"Sure" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (callback) {
            callback();
        }
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - Touch Event
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
