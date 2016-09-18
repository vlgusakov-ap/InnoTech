//
//  DescriptionViewController.h
//  InnoTech
//
//  Created by Vladyslav Gusakov on 5/3/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController: UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) NSString *link;
@property (nonatomic) NSUInteger selectedRow;
@property (strong, nonatomic) NSURLRequest *request;


@end
