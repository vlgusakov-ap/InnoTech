//
//  AppDelegate.m
//  InnoTech
//
//  Created by Vladyslav Gusakov on 7/3/16.
//  Copyright © 2016 NYCAppStudio. All rights reserved.
//

#import "AppDelegate.h"
#import "HelpshiftCore.h"
#import "HelpshiftAll.h"
#import "HelpshiftSupport.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "RNCachingURLProtocol.h"
#import "Constants.h"

@import AFNetworking;
@import Firebase;
@import FirebaseMessaging;
@import FirebaseInstanceID;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self initHelpShift]; //init helpshift

    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes: (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound) categories:nil];
    
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];

    
    [self initGlobalUI]; //fonts and appearance
    [FBSDKLoginButton class];
    [NSURLProtocol registerClass:[RNCachingURLProtocol class]]; //init web caching - offline mode
    [FIRApp configure];
    [FIRDatabase database].persistenceEnabled = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:)
                                                 name:kFIRInstanceIDTokenRefreshNotification object:nil];
    
    if (launchOptions != nil) //Handle PushNotification when app is opened
    {
        NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (userInfo != nil && [[userInfo objectForKey:@"origin"] isEqualToString:@"helpshift"])
        {
            UIWindow* mainWindow = [[UIApplication sharedApplication] keyWindow];

            [HelpshiftCore handleRemoteNotification:userInfo withController: mainWindow.rootViewController ];
        }
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"APN device token: %@", deviceToken);
    [[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeSandbox];
    [HelpshiftCore registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Pring full message.
    NSLog(@"Push received: %@", userInfo);
    
    // Print message ID.
    NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
    
    if ([[userInfo objectForKey:@"origin"] isEqualToString:@"helpshift"]) {
        [HelpshiftCore handleRemoteNotification:userInfo withController:[[UIApplication sharedApplication] keyWindow].rootViewController];
    }

}

- (void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if ([[notification.userInfo objectForKey:@"origin"] isEqualToString:@"helpshift"]) {
        [HelpshiftCore handleLocalNotification:notification withController:[[UIApplication sharedApplication] keyWindow].rootViewController];
    }
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%@", error.localizedDescription);
}

- (void)tokenRefreshNotification:(NSNotification *)notification {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token: %@", refreshedToken);
    
    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFcm];
    
    // TODO: If necessary send token to appliation server.
}

- (void) connectToFcm {
    
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            NSLog(@"Connected to FCM.");
            [[FIRMessaging messaging] subscribeToTopic:@"/topics/news"];
        }
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[FIRMessaging messaging] disconnect];
    NSLog(@"Disconnected from FCM");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self connectToFcm];
    [FBSDKAppEvents activateApp];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"applicationDidBecomeActive"
     object:self];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) initHelpShift {
    [HelpshiftCore initializeWithProvider:[HelpshiftAll sharedInstance]];
    [HelpshiftCore installForApiKey:kHelpShiftApiKey domainName:kHelpShiftDomainName appID:kHelpShiftAppID];
}

- (void) initGlobalUI {
    
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //    [[UILabel appearance] setFont:[UIFont fontWithName:@"Avenir Next" size:17.0]];
}

@end
