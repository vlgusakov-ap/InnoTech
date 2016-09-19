//
//  CommentsViewController.m
//  InnoTech
//
//  Created by Vladyslav Gusakov on 5/14/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import "CommentsViewController.h"
#import "MyManager.h"
#import "CommentTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Constants.h"
#import "SettingsViewController.h"
#import "LoginManager.h"
@import AFNetworking;

@interface CommentsViewController () <MyManagerDelegate>{
    MyManager *dao;
    LoginManager *login;
}
- (IBAction)openNewMsg:(id)sender;
@property (weak, nonatomic) UITableView *tableViewRef;

@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dao.toNewMsg = false;
    login = [LoginManager new];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    dao = [MyManager sharedManager];
    dao.commentsDelegate = self;
    if (dao.toNewMsg == false  && dao.currentComments.count == 0) {
        [dao addListenerToProductWithKey:dao.currentProduct.key];
    }
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (dao.toNewMsg == false) {
        [dao removeListenersForProduct:dao.currentProduct.key];

    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createNoCommentsView {
    
    UIView *noCommentsView = nil;
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"NoCommentsView"
                                                     owner:self
                                                   options:nil];
    if ([objects.firstObject isKindOfClass:[UIView class]]) {
        noCommentsView = objects.firstObject;
    }
    self.view = noCommentsView;
    
}
-(void) tableViewAction: (FireBaseAction) action atIndex: (NSUInteger) index {
    
    [self.tableView beginUpdates];
    switch (action) {
        case Add:
        {
            [self.tableView insertRowsAtIndexPaths:@[
                                                     [NSIndexPath indexPathForRow:index inSection:0]
                                                     ]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
            break;
            
        case Delete:
        {
            [self.tableView deleteRowsAtIndexPaths:@[
                                                     [NSIndexPath indexPathForRow:index inSection:0]
                                                     ]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
        }
            break;
            
        case Update:
        {
            [self.tableView reloadRowsAtIndexPaths:@[
                                                     [NSIndexPath indexPathForRow:index inSection:0]
                                                     ]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
            break;
        default:
            break;
    }
    
    [self.tableView endUpdates];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dao.currentComments.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentTableViewCell *cell = (CommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
    
    // Configure the cell...
//    NSLog(@"%@", dao.currentComments[indexPath.row]);
    NSString *name = [dao.currentComments[indexPath.row] objectForKey:@"name"];
    NSString *comment = [dao.currentComments[indexPath.row] objectForKey:@"comment"];
    cell.commentTextView.text = comment;
    NSString *imgStr = [dao.currentComments[indexPath.row] objectForKey:@"img"];
    NSURL *imgUrl = [NSURL URLWithString:imgStr];
    cell.nameLabel.text = name;
    [cell.personPicture sd_setImageWithURL:imgUrl];
    cell.personPicture.layer.cornerRadius = 36.75;
    cell.personPicture.clipsToBounds = true;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"newMsg"]) {
        dao.toNewMsg = true;
    }
}


- (IBAction)openNewMsg:(id)sender {
    
    BOOL reachable = [AFNetworkReachabilityManager sharedManager].reachable;
    
    if (reachable) {
    
        if ([[NSUserDefaults standardUserDefaults] objectForKey:kFacebookName] == nil) {
            //not logged in
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"You are not logged in!" message:@"Please login to leave a comment" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *openSettings = [UIAlertAction actionWithTitle:@"Open Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                SettingsViewController *settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"settingsVC"];
                dao.toNewMsg = true;
                [self presentViewController:settingsVC animated:YES completion:nil];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:openSettings];
            [alertController addAction:cancel];
            
            [self presentViewController:alertController animated:true completion:nil];

            
        }
        else {
            
            [self performSegueWithIdentifier:@"newMsg" sender:self];
            
        }
    } else {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No internet connection!" message:@"Please make sure you are connected to the Internet" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:true completion:nil];
        
    }
}
@end
