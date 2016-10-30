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
#import "ProductComment.h"

@interface CommentsViewController () <MyManagerDelegate>{
    MyManager *dao;
    LoginManager *login;
}
@property (strong,nonatomic) UIViewController *modal;

- (IBAction)openNewMsg:(id)sender;

@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dao.toNewMsg = false;
    login = [LoginManager new];
    self.tableView.estimatedRowHeight = 80.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    dao = [MyManager sharedManager];
    dao.commentsDelegate = self;
    if (dao.toNewMsg == false  && dao.currentComments.count == 0) {
        [dao addListenerToProductWithKey:dao.currentProduct.key];
    }
    [self.tableView reloadData];
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
    
    if (index < 0 || index > dao.currentComments.count-1) {
        return;
    }
    
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
    ProductComment *productComment = dao.currentComments[indexPath.row];
    cell.commentTextView.text = productComment.commentText;
    NSURL *imgUrl = [NSURL URLWithString:productComment.imageUrl];
    BOOL isPremium = productComment.isPremium;
    cell.nameLabel.text = productComment.userName;
    [cell.personPicture sd_setImageWithURL:imgUrl];
    cell.personPicture.layer.cornerRadius = CGRectGetWidth(cell.personPicture.bounds)/2.0f;
    cell.personPicture.clipsToBounds = true;
    cell.crownImageView.image = (isPremium) ? [UIImage imageNamed:@"crown.png"] : nil;
    cell.commentTime.text = [MyManager chatTimeFormat:productComment.commentTime];
    
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

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
//            [self showNewComment];
        }
    } else {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No internet connection!" message:@"Please make sure you are connected to the Internet" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:true completion:nil];
        
    }
}

//- (void) showNewComment
//{
//    if (self.childViewControllers.count == 0)
//    {
//        self.modal = [self.storyboard instantiateViewControllerWithIdentifier:@"newComment"];
//
//        [self addChildViewController:self.modal];
//        self.modal.view.frame = CGRectMake(0, 568, 320, 284);
//        [self.view addSubview:self.modal.view];
//        [UIView animateWithDuration:1 animations:^{
//            self.modal.view.frame = CGRectMake(0, 284, 320, 284);;
//        } completion:^(BOOL finished) {
//            [self.modal didMoveToParentViewController:self];
//        }];
//    }
//    else
//    {
//        [UIView animateWithDuration:1 animations:^{
//            self.modal.view.frame = CGRectMake(0, 568, 320, 284);
//        } completion:^(BOOL finished) {
//            [self.modal.view removeFromSuperview];
//            [self.modal removeFromParentViewController];
//            self.modal = nil;
//        }];
//    }
//
//}
@end
