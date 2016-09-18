//
//  NewCommentViewController.m
//  InnoTech
//
//  Created by Vladyslav Gusakov on 5/14/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import "NewCommentViewController.h"
#import "MyManager.h"
#import "Login.h"

@interface NewCommentViewController () {
    MyManager *dao;
    Login *login;
}
@property (weak, nonatomic) IBOutlet UITextView *comment;
- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;
@end

@implementation NewCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dao = [MyManager sharedManager];
    login = [Login new];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    dao.toNewMsg = false;
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done:(id)sender {
//    []
    
    [dao publishComment: self.comment.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
