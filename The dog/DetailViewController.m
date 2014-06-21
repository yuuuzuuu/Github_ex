//
//  DetailViewController.m
//  The Dog
//
//  Created by 木村 友真 on 2014/06/21.
//  Copyright (c) 2014年 yuma kimura. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UITextView *nameView;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, copy) NSString *httpErrorMessage;

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Detail View";
    self.profileImageView.image = self.image;
    self.nameView.text = self.name;
    self.textView.text = self.text;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)retweetAction:(id)sender {

        ACAccountStore *accountStore = [[ACAccountStore alloc] init];
        ACAccount *account = [accountStore accountWithIdentifier:self.identifier];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com"
                                           @"/1.1/statuses/retweet/%@.json", self.idStr]];
        
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                requestMethod:SLRequestMethodPOST
                                                          URL:url
                                                   parameters:nil]; // 今回はURLにidStrを含めるので不要 
        request.account = account; 
        
        UIApplication *application = [UIApplication sharedApplication]; 
        application.networkActivityIndicatorVisible = YES; // インジケータON
    
    [request performRequestWithHandler:^(NSData *responseData,
                                         NSHTTPURLResponse *urlResponse,
                                         NSError *error) {
        if (responseData) {
            self.httpErrorMessage = nil;
            if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                NSDictionary *postResponseData =
                [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers
                                                  error:NULL];
                NSLog(@"SUCCESS! Created Retweet with ID: %@", postResponseData[@"id_str"]);
            } else { // HTTPエラー発生時
                self.httpErrorMessage =
                [NSString stringWithFormat:@"The response status code is %d",
                 urlResponse.statusCode];
                NSLog(@"HTTP Error: %@", self.httpErrorMessage);
                // リツイート時のHTTPエラーメッセージを画面に表示する領域がない。今後の課題。
            }
        } else { // リクエスト送信エラー発生時
            NSLog(@"ERROR: An error occurred while posting: %@", [error localizedDescription]); 
            // リクエスト時の送信エラーメッセージを画面に表示する領域がない。今後の課題。 
        } 
        dispatch_async(dispatch_get_main_queue(), ^{ 
            UIApplication *application = [UIApplication sharedApplication]; 
            application.networkActivityIndicatorVisible = NO; // インジケータOFF 
        }); 
    }]; 
}

@end
