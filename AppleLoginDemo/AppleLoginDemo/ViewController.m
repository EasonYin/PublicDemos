//
//  ViewController.m
//  AppleLoginDemo
//
//  Created by 尹华东 on 2019/9/16.
//  Copyright © 2019 EasonY. All rights reserved.
//

#import "ViewController.h"
#import <AuthenticationServices/AuthenticationServices.h>
#import <SSKeychain/SSKeychain-umbrella.h>
#import "AppDelegate.h"

@interface ViewController ()<ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>
{
    
}

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self performExistingAccountSetupFlows];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ASAuthorizationAppleIDButton *loginBtn = [ASAuthorizationAppleIDButton buttonWithType:(ASAuthorizationAppleIDButtonTypeDefault) style:(ASAuthorizationAppleIDButtonStyleBlack)];
    [loginBtn addTarget:self action:@selector(handleAuthorizationAppleIDButtonPress:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:loginBtn];
    [loginBtn setBounds:CGRectMake(0, 0, 300, 44)];
    [loginBtn setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    
    
}

- (void)handleAuthorizationAppleIDButtonPress:(id)sender{
    ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc]init];
    ASAuthorizationAppleIDRequest *request = [appleIDProvider createRequest];
    request.requestedScopes = @[ASAuthorizationScopeFullName,ASAuthorizationScopeEmail];
    
    ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc]initWithAuthorizationRequests:@[request]];
    authorizationController.delegate = self;
    authorizationController.presentationContextProvider = self;
    [authorizationController performRequests];
}

- (void)performExistingAccountSetupFlows{
    ASAuthorizationAppleIDRequest *appleId = [[ASAuthorizationAppleIDProvider new] createRequest];
    ASAuthorizationPasswordRequest *password = [[ASAuthorizationPasswordProvider new] createRequest];
    NSArray *requests = @[appleId,password];
    
    ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc]initWithAuthorizationRequests:requests];
    authorizationController.delegate = self;
    authorizationController.presentationContextProvider = self;
    [authorizationController performRequests];
}

#pragma mark - ASAuthorizationControllerDelegate
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error{
    NSLog(@"error:%@",error);
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
            
        default:
            break;
    }
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization{
    
    NSLog(@"authorization:%@",authorization);
    
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]){
        ASAuthorizationAppleIDCredential *appleIDCredential = authorization.credential;
        if (appleIDCredential){
            
            NSString *user = appleIDCredential.user;
            NSPersonNameComponents *fullName = appleIDCredential.fullName;
            NSString *familyName = appleIDCredential.fullName.familyName;
            NSString *givenName = appleIDCredential.fullName.givenName;
            NSString *email = appleIDCredential.email;
            NSData *identityToken = appleIDCredential.identityToken;
            NSData *authorizationCode = appleIDCredential.authorizationCode;
            ASUserDetectionStatus realUserStatus = appleIDCredential.realUserStatus;
            
            [SSKeychain setPassword:user forService:ServerceName account:Account];
            
            
        }
    }
    else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]){
        ASPasswordCredential *passwordCredential = authorization.credential;
        NSString *username = passwordCredential.user;
        NSString *password = passwordCredential.password;
        
    }
    
    
}

#pragma mark - ASAuthorizationControllerPresentationContextProviding
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller{
    return self.view.window;
}

@end
