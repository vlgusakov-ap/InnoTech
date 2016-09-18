//
//  PremiumViewController.m
//  InnoTech
//
//  Created by Vladyslav Gusakov on 5/14/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import "PremiumViewController.h"
#import "SWRevealViewController.h"
#import "IAPShare.h"
#import "Constants.h"
#import "MyManager.h"
#import "MBProgressHUD.h"
#import "PremiumManager.h"

@interface PremiumViewController ()
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *upgradeButton;
- (IBAction)restorePurchase:(id)sender;
- (IBAction)upgradeToPremium:(id)sender;

@end

@implementation PremiumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setMenuVC];
    
    UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 80)];
    titleImage.image = [UIImage imageNamed:@"premium_title"];
    titleImage.contentMode = UIViewContentModeScaleAspectFit;
    
    self.navigationItem.titleView = titleImage;
    
//    self.upgradeButton.hidden = ([[MyManager sharedManager] premiumStatus] == Active);

}

-(void) setMenuVC {
    
    if (!_presentedModally)
    {
        SWRevealViewController *revealViewController = self.revealViewController;
        if (revealViewController)
        {
            [self.menuButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        }
    }
    else
    {
        [self.menuButton setImage:[UIImage imageNamed:@"delete_white"] forState:UIControlStateNormal];
        [self.menuButton addTarget:self action:@selector(dissmiss) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void) dissmiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)restorePurchase:(id)sender {
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"Restoring...";
    
    
        [[IAPShare sharedHelper].iap restoreProductsWithCompletion:^(SKPaymentQueue *payment, NSError *error) {
                    
            // number of restore count
            for (SKPaymentTransaction *transaction in payment.transactions)
            {
                NSString *purchased = transaction.payment.productIdentifier;
                if([purchased isEqualToString:kiTunesPremiumProductID])
                {
                    //enable the product here
                    [[PremiumManager sharedManager] enablePremium:YES];
                    
                }
            }
            hud.mode = MBProgressHUDModeCustomView;
            UIImage *image = [UIImage imageNamed:@"checkmark_black"];
            hud.customView = [[UIImageView alloc] initWithImage:image];
            hud.square = YES;
            hud.label.text = @"Done";
            [hud hideAnimated:YES afterDelay:3.f];
        }];
    
    
//        hud.mode = MBProgressHUDModeCustomView;
//        
//        UIImage *image = [UIImage imageNamed:@"warning"];
//        hud.customView = [[UIImageView alloc] initWithImage:image];
//        hud.square = YES;
//        hud.label.text = @"Nothing";
//        hud.detailsLabel.text = @"to restore";
//        [hud hideAnimated:YES afterDelay:3.f];
    
}

- (IBAction)upgradeToPremium:(id)sender {
    
    NSLog(@"%@",[IAPShare sharedHelper].iap.purchasedProducts);

    [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response)
     {
         if(response > 0 ) {
             SKProduct* product =[[IAPShare sharedHelper].iap.products objectAtIndex:0];
             
             if(![[IAPShare sharedHelper].iap isPurchasedProductsIdentifier:kiTunesPremiumProductID]) {
             [[IAPShare sharedHelper].iap buyProduct:product
                                        onCompletion:^(SKPaymentTransaction* trans){
                                            
                                            if(trans.error)
                                            {
                                                NSLog(@"Fail %@",[trans.error localizedDescription]);
                                            }
                                            else if(trans.transactionState == SKPaymentTransactionStatePurchased) {
                                                
                                                [[IAPShare sharedHelper].iap checkReceipt:[NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]] AndSharedSecret:kiTunesPremiumSharedSecret onCompletion:^(NSString *response, NSError *error) {
                                                    
                                                    //Convert JSON String to NSDictionary
                                                    NSDictionary* rec = [IAPShare toJSON:response];
                                                    
                                                    if([rec[@"status"] integerValue]==0)
                                                    {
                                                        
                                                        [[IAPShare sharedHelper].iap provideContentWithTransaction:trans];
                                                        NSLog(@"SUCCESS %@",response);
                                                        NSLog(@"Purchased %@",[IAPShare sharedHelper].iap.purchasedProducts);
                                                        [[MyManager sharedManager] enablePremium:YES];

                                                    }
                                                    else {
                                                        NSLog(@"Fail");
                                                    }
                                                }];
                                            }
                                            else if(trans.transactionState == SKPaymentTransactionStateFailed) {
                                                NSLog(@"Fail");
                                            }
                                        }];//end of buy product
             }
             else
             {
                 MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                 hud.mode = MBProgressHUDModeCustomView;
                 UIImage *image = [UIImage imageNamed:@"crown"];
                 hud.customView = [[UIImageView alloc] initWithImage:image];
                 hud.square = YES;
                 hud.label.text = @"Premium ✓";
                 [hud hideAnimated:YES afterDelay:3.f];

             }
         }
     }];
         

}

@end
