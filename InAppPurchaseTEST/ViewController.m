//
//  ViewController.m
//  InAppPurchaseTEST
//
//  Created by Jeon Gyuchan on 12. 11. 14..
//  Copyright (c) 2012년 Jeon Gyuchan. All rights reserved.
//

#import "ViewController.h"
#import "BaasClient.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize name, description, price, backgroundImage;


- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([SKPaymentQueue canMakePayments]) {	// 스토어가 사용 가능하다면
        NSLog(@"Start Shop!");
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];	// Observer를 등록한다.
        NSString *access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
        BaasClient *client = [BaasClient createInstance];
        [client setDelegate:self];
        [client setAuth:access_token];
        [client getEntities:[NSString stringWithFormat:@"product"] query:nil];
    }
    else {
        NSLog(@"Failed Shop!");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"SKPaymentTransactionStateRestored");
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"SKPaymentTransactionStateFailed");
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
	NSLog(@"SKPaymentTransactionStatePurchased");
    
	NSLog(@"Trasaction Identifier : %@", transaction.transactionIdentifier);
	NSLog(@"Trasaction Date : %@", transaction.transactionDate);
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    NSDictionary *object = [[NSDictionary alloc]init];
    object = [productList objectAtIndex:0];
    NSString *productUUID = [[NSString alloc]initWithFormat:@"%@",[object objectForKey:@"uuid"]];
    orderNumber = [[object objectForKey:@"order"] intValue];
    orderNumber++;

    NSString *access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    
    NSMutableDictionary *entity = [[NSMutableDictionary alloc]init];
    NSString * outputOrderNumber = [NSString stringWithFormat:@"%d", orderNumber];
    [entity setObject:outputOrderNumber forKey:@"order"];
    
    BaasClient *client = [BaasClient createInstance];
    [client setLogging:NO];
    [client setAuth:access_token];
    [client updateEntity:@"product" entityID:productUUID entity:entity];
    
    NSString *productURL = [[NSString alloc]initWithFormat:@"%@/files/%@",[client getAPIURL],[object objectForKey:@"download"]];
    NSData *productData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:productURL]];
    UIImage *productImage = [UIImage imageWithData:productData];
    [backgroundImage setImage:productImage];

}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}


- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
	NSLog(@"SKProductRequest got response");
	if( [response.products count] > 0 ) {
		product = [response.products objectAtIndex:0];
		NSLog(@"Title : %@", product.localizedTitle);
		NSLog(@"Description : %@", product.localizedDescription);
		NSLog(@"Price : %@", product.price);
        
        [name setText:product.localizedTitle];
        [description setText:product.localizedDescription];
        [price setText:[NSString stringWithFormat:@"%@",product.price]];
	}
	
	if( [response.invalidProductIdentifiers count] > 0 ) {
		NSString *invalidString = [response.invalidProductIdentifiers objectAtIndex:0];
		NSLog(@"Invalid Identifiers : %@", invalidString);
	}
}

-(IBAction)pay:(id)sender{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}



- (void)ugClientResponse:(UGClientResponse *)response
{
    NSDictionary *resp = (NSDictionary *)response.rawResponse;
    if (response.transactionState == kUGClientResponseFailure) {
        NSLog(@"실패\n response : %@", resp);
    } else if (response.transactionState == kUGClientResponseSuccess) {
        productList = [[NSMutableArray alloc]initWithArray:[response.rawResponse objectForKey:@"entities"]];
        NSLog(@"상품 정보 response : %@", productList);
        NSDictionary *object = [[NSDictionary alloc]init];
        object = [productList objectAtIndex:0];
        NSString *productID = [[NSString alloc]initWithFormat:@"%@",[object objectForKey:@"productIdentifier"]];
        
        
        SKProductsRequest *productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:productID]];
        productRequest.delegate = self;
        [productRequest start];
    }
}
@end
