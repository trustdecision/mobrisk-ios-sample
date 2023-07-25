//
//  PrivacyAgreeViewController.m
//  Mobrisk-iOS-Sample
//

#import "PrivacyAgreeViewController.h"
#import <WebKit/WebKit.h>

@interface PrivacyAgreeViewController ()
@property (weak, nonatomic) IBOutlet WKWebView *webView;
@end

@implementation PrivacyAgreeViewController

#pragma mark - view Func
- (void)viewDidLoad {
    [super viewDidLoad];
    // Set Navigation Title
    self.navigationItem.title = @"Privacy Agreement";
    // Load Local Privacy Policy Html
    NSString *privacyPolicyPath = [[NSBundle mainBundle] pathForResource:@"PrivacyAgreement" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:privacyPolicyPath encoding:NSUTF8StringEncoding error:nil];
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    [self.webView loadHTMLString:htmlString baseURL:nil];
}

#pragma mark - IB Event
- (IBAction)acceptClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(privacyAgreeViewController:result:)]) {
        [self.delegate privacyAgreeViewController:self result:YES];
    }
}

- (IBAction)refuseClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(privacyAgreeViewController:result:)]) {
        [self.delegate privacyAgreeViewController:self result:NO];
    }
}

@end
