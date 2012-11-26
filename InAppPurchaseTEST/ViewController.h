//
//  ViewController.h
//  InAppPurchaseTEST
//
//  Created by Jeon Gyuchan on 12. 11. 14..
//  Copyright (c) 2012년 Jeon Gyuchan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/SKProductsRequest.h>
#import <StoreKit/SKProduct.h>
#import <StoreKit/StoreKit.h>
#import <StoreKit/SKPaymentQueue.h>
#import <StoreKit/SKPaymentTransaction.h>

@interface ViewController : UIViewController <SKPaymentTransactionObserver,SKProductsRequestDelegate>{
    SKProduct *product;
    NSMutableArray *productList;
    int orderNumber;
    
}

@property (nonatomic, retain) IBOutlet UILabel *name, *description, *price;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundImage;

-(IBAction)pay:(id)sender;

@end
