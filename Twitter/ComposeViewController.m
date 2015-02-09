//
//  ComposeViewController.m
//  Twitter
//
//  Created by Bishwajit Aich. on 2/8/15.
//  Copyright (c) 2015 Bishwajit Aich. All rights reserved.
//

#import "ComposeViewController.h"
#import "TwitterClient.h"

@interface ComposeViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
- (IBAction)onSend:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *remainingCount;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    
    self.textView.contentInset = UIEdgeInsetsMake(-7.0,0.0,0,0.0);
    [self.textView becomeFirstResponder];
    
    self.textView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) onCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onSend:(id)sender {
    NSString *status = self.textView.text;
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:status,@"status", nil];
    [[TwitterClient sharedInstance]postTweetWithParams:dictionary completion:^(Tweet *tweet, NSError *error) {
        if (error != nil) {
            NSLog(@"Error occurred while posting tweet.");
        } else {
            [self.delegate didPostTweet:tweet];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

#pragma mark - TextView delegate methods
- (void)textViewDidChange:(UITextView *)textView {
    NSInteger count = 140 - textView.text.length;
    if (count < 0) {
        self.remainingCount.textColor = [UIColor redColor];
    } else {
        self.remainingCount.textColor = [UIColor blackColor];
    }
    self.remainingCount.text = [NSString stringWithFormat:@"%ld characters left",140 - textView.text.length];
}
@end
