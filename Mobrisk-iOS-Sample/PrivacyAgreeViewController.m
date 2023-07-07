//
//  PrivacyAgreeViewController.m
//  Mobrisk-iOS-Sample
//
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(privacyAgreeViewController:result:)]) {
        [self.delegate privacyAgreeViewController:self result:YES];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)refuseClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(privacyAgreeViewController:result:)]) {
        [self.delegate privacyAgreeViewController:self result:NO];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
