//
//  LoginViewController.m
//  InAppPurchaseTEST
//
//  Created by Jeon Gyuchan on 12. 11. 26..
//  Copyright (c) 2012년 Jeon Gyuchan. All rights reserved.
//

#import "LoginViewController.h"
#import "ViewController.h"

#import "BaasClient.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize usernameTextField, passwordTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)loginTouched:(id)sender{
    BaasClient *client = [BaasClient createInstance];
    [client setDelegate:self];
    [client logInUser:usernameTextField.text password:passwordTextField.text];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)goToMainPage{
    ViewController *viewController = [[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
    [self presentViewController:viewController animated:NO completion:nil];

}

- (void)ugClientResponse:(UGClientResponse *)response
{
    NSDictionary *resp = (NSDictionary *)response.rawResponse;
    if (response.transactionState == kUGClientResponseFailure) {
        NSLog(@"실패\n response : %@", resp);
    } else if (response.transactionState == kUGClientResponseSuccess) {
        NSString *access_token = [resp objectForKey:@"access_token"];
        NSDictionary *user = [resp objectForKey:@"user"];
        //NSLog(@"로그인 정보 response : %@", resp);
        [[NSUserDefaults standardUserDefaults] setObject:access_token forKey:@"access_token"];
        [[NSUserDefaults standardUserDefaults] setObject:user forKey:@"user"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self goToMainPage];
    }
}

@end
