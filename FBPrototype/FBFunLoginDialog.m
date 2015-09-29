//
//  FBFunLoginDialog.m
//  FBPrototype
//
//  Created by Marek Tomaszewski on 29/09/2015.
//  Copyright © 2015 CodeImagination. All rights reserved.
//

#import "FBFunLoginDialog.h"

@interface FBFunLoginDialog ()

@end

@implementation FBFunLoginDialog
@synthesize webView = _webView;
@synthesize apiKey = _apiKey;
@synthesize requestedPermissions = _requestedPermissions;
@synthesize delegate = _delegate;

-(id)initWithAppId:(NSString *)apiKey requestedPermissions:(NSString *)requestedPermissions delegate:(id<FBFunLoginDialogDelegate>)delegate{
    
    if (self = [super initWithNibName:@"FBFunLoginDialog" bundle:[NSBundle mainBundle]]) {
        
        self.apiKey = apiKey;
        self.requestedPermissions = requestedPermissions;
        self.delegate = _delegate;
    }
    
    return self;
}
-(void)closeTapped:(id)sender{
    
}
-(void)checkForAccessToken:(NSString *)urlString{
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"access_token=(.*)&"
                                  options:0 error:&error];
    if (regex != nil) {
        NSTextCheckingResult *firstMatch =
        [regex firstMatchInString:urlString
                          options:0 range:NSMakeRange(0, [urlString length])];
        if (firstMatch) {
            NSRange accessTokenRange = [firstMatch rangeAtIndex:1];
            NSString *accessToken = [urlString substringWithRange:accessTokenRange];
            accessToken = [accessToken
                           stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [_delegate accessTokenFound:accessToken];
        }
    }
    
}
-(void)checkLoginRequired:(NSString *)urlString{
    
    
}
-(void)login{
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    
    NSString *redirectURLString = @"http://www.facebook.com/connect/login_success.html";
    NSString *authFormatString =@"https://graph.facebook.com/oauth/authorize?client_id=%@&redirect_uri=%@&scope=%@&type=user_agent&display=touch";
    NSString *urlString = [NSString stringWithFormat:authFormatString, _apiKey, redirectURLString, _requestedPermission];
    NSURL *url =[NSURL URLWithString:urlString];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [_webView loadRequest:urlRequest];
    
}
-(void)logout{
    
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie* cookie in
         [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [cookies deleteCookie:cookie];
    }
    
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *urlString = request.URL.absoluteString;
    [self checkForAccessToken:urlString];
    [self checkLoginRequired:urlString];
    
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
