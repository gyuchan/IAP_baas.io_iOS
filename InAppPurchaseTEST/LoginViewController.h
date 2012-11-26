//
//  LoginViewController.h
//  InAppPurchaseTEST
//
//  Created by Jeon Gyuchan on 12. 11. 26..
//  Copyright (c) 2012년 Jeon Gyuchan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController{
    UIButton *loginButton;
}

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

-(IBAction)loginTouched:(id)sender;

@end
