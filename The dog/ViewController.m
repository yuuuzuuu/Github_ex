//
//  ViewController.m
//  The dog
//
//  Created by 木村 友真 on 2014/06/20.
//  Copyright (c) 2014年 yuma kimura. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *accountDisplayLabel;
@property (nonatomic, strong) ACAccountStore *accountStre;
@property (nonatomic, copy) NSArray *twitterAccounts;
@property (nonatomic, copy) NSString *identifier;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.accountStre = [[ACAccountStore alloc] init];
    ACAccountType *twitterType =
    [self.accountStre accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [self.accountStre requestAccessToAccountsWithType:twitterType options:NULL completion:^(BOOL granted, NSError *error) {
        if (granted) {
            self.twitterAccounts = [self.accountStre accountsWithAccountType:twitterType];
            if (self.twitterAccounts.count > 0) {
                ACAccount *account = self.twitterAccounts[0];
                self.identifier = account.identifier;
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.accountDisplayLabel.text = account.username;
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.accountDisplayLabel.text = @"アカウントなし";
                });
            }
        } else {
            NSLog(@"Account Error: %@", [error localizedDescription]);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.accountDisplayLabel.text = @"アカウント認証エラー";
            });
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tweet:(id)sender {
    //最小限のtweetコード
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        NSString *serviceType = SLServiceTypeTwitter;
        SLComposeViewController *composeCtl =
        [SLComposeViewController composeViewControllerForServiceType:serviceType];
        [composeCtl setCompletionHandler:^(SLComposeViewControllerResult result) {
            if (result == SLComposeViewControllerResultCancelled) {
                NSLog(@"tweet成功");
            }
        }];
        [self presentViewController:composeCtl animated:YES completion:nil];
    }
}
- (IBAction)setAccountAction:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] init];
    sheet.delegate = self;
    
    sheet.title = @"選択してください";
    for (ACAccount *account in self.twitterAccounts) {
        [sheet addButtonWithTitle:account.username];
    }
    [sheet addButtonWithTitle:@"キャンセル"];
    sheet.cancelButtonIndex = self.twitterAccounts.count;
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.twitterAccounts.count > 0) {
        if (buttonIndex != self.twitterAccounts.count) {
            ACAccount *account = self.twitterAccounts[buttonIndex];
            self.identifier = account.identifier;
            self.accountDisplayLabel.text = account.username;
            NSLog(@"Account set! %@", account.username);
        } else {
            NSLog(@"cancel!");
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"timeLineSegue"]) { //セグエのidを確認
        TimeLineTableViewController *timeLineVC = segue.destinationViewController;
        if ([timeLineVC isKindOfClass:[TimeLineTableViewController class]]) {
            timeLineVC.identifier = self.identifier; //アカウントidをもち回す
        }
    }
}
@end