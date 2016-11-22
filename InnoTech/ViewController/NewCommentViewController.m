//
//  NewCommentViewController.m
//  InnoTech
//
//  Created by Vladyslav Gusakov on 5/14/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import "NewCommentViewController.h"
#import "MyManager.h"
#import "LoginManager.h"
#import "UIViewController+Addons.h"

@interface NewCommentViewController () <UITextViewDelegate> {
    MyManager *dao;
    LoginManager *login;
}
@property (weak, nonatomic) IBOutlet UITextView *comment;
@property (weak, nonatomic) IBOutlet UILabel *currentTextLength;
- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;
@end

@implementation NewCommentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dao = [MyManager sharedManager];
    login = [LoginManager new];
    self.comment.layer.borderWidth = 0.5;
    self.comment.layer.cornerRadius = 8;
    self.comment.layer.borderColor = [[UIColor blackColor] CGColor];
    self.comment.delegate = self;
    self.comment.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.comment.scrollEnabled = false;
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    dao.toNewMsg = false;
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done:(id)sender
{
    if (self.comment.text.length > 3)
    {
        [dao publishComment: self.comment.text];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self showAlertWithTitle:@"Oops.." description:@"Your message is too short."];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.currentTextLength.text = [NSString stringWithFormat:@"Min: 3 | %lu/200", (unsigned long)textView.text.length];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return textView.text.length + (text.length - range.length) <= 200;
}

@end
