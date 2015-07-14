//
//  ViewController.m
//  Tutorial_42
//
//  Created by Admin on 14.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController ()<UITextFieldDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *barView;
@property (weak, nonatomic) IBOutlet UITextField *urlField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *reloadButton;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.barView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    
    self.backButton.enabled = NO;
    self.forwardButton.enabled = NO;
    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectZero];
    self.webView.navigationDelegate = self;
    [self.progressView.layer setZPosition:2];
    [self.webView.layer setZPosition:1];
    [self.view addSubview:self.webView];
    
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1 constant:-44];
    
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    
    [self.view addConstraint:height];
    [self.view addConstraint:width];
    
    
    [self.webView addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    NSURL *url = [NSURL URLWithString:@"http://www.appcoda.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self.barView setFrame:CGRectMake(0, 0, size.width, 30)];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.urlField isFirstResponder])
    {
        [self.urlField resignFirstResponder];
    }
    
    NSURL *url = [NSURL URLWithString:self.urlField.text];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    return NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"loading"]) {
        self.backButton.enabled = self.webView.canGoBack;
        self.forwardButton.enabled = self.webView.canGoForward;
    }
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.hidden = self.webView.estimatedProgress == 1;
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
    }
}
- (IBAction)back:(UIBarButtonItem *)sender {
    [self.webView goBack];
}
- (IBAction)forward:(UIBarButtonItem *)sender {
    [self.webView goForward];
}
- (IBAction)reload:(UIBarButtonItem *)sender {
    NSURLRequest *request = [NSURLRequest requestWithURL:self.webView.URL];
    [self.webView loadRequest:request];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    if (error)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self.progressView setProgress:0.0 animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
