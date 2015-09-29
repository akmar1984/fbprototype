//
//  FBFunLoginDialog.h
//  FBPrototype
//
//  Created by Marek Tomaszewski on 29/09/2015.
//  Copyright © 2015 CodeImagination. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FBFunLoginDialogDelegate
- (void)accessTokenFound:(NSString *)accessToken;
- (void)displayRequired;
- (void)closeTapped;
@end
@interface FBFunLoginDialog : UIViewController <UIWebViewDelegate>{
    UIWebView *_webView;
    NSString *_apiKey;
    NSString *_requestedPermission;
    id <FBFunLoginDialogDelegate> delegate;
}
@property (retain) IBOutlet UIWebView *webView;
@property (copy) NSString *apiKey;
@property (copy) NSString *requestedPermissions;
@property (assign) id <FBFunLoginDialogDelegate> delegate;

- (id)initWithAppId:(NSString *)apiKey
requestedPermissions:(NSString *)requestedPermissions
           delegate:(id<FBFunLoginDialogDelegate>)delegate;
- (IBAction)closeTapped:(id)sender;
- (void)login;
- (void)logout;

-(void)checkForAccessToken:(NSString *)urlString;
-(void)checkLoginRequired:(NSString *)urlString;

@end
