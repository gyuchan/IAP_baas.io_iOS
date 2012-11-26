//
//  AppDelegate.h
//  InAppPurchaseTEST
//
//  Created by Jeon Gyuchan on 12. 11. 14..
//  Copyright (c) 2012년 Jeon Gyuchan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/SKProductsRequest.h>
#import <StoreKit/SKProduct.h>
#import <StoreKit/SKPaymentQueue.h>
#import <StoreKit/SKPaymentTransaction.h>

@class LoginViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) LoginViewController *loginViewController;

@end
