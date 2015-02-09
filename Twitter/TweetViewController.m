//
//  TweetViewController.m
//  Twitter
//
//  Created by Bishwajit Aich. on 2/8/15.
//  Copyright (c) 2015 Bishwajit Aich. All rights reserved.
//

#import "TweetViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "TweetViewCell.h"
#import "TwitterClient.h"

@interface TweetViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *twitterHandle;
@property (weak, nonatomic) IBOutlet UILabel *numberTweets;
@property (weak, nonatomic) IBOutlet UILabel *numberFollowing;
@property (weak, nonatomic) IBOutlet UILabel *numberFollower;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) TweetViewCell *prototypeCell;
@property (nonatomic, strong) NSMutableArray* tweets;

@end

@implementation TweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tweets = [NSMutableArray array];
    self.title = @"Home";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onNewTweet)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onLogout)];
    
    // Table View Initialize
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetViewCell" bundle:nil] forCellReuseIdentifier:@"TweetViewCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self refreshTweets];
    [self loadUserProfile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)onLogout {
    [User logout];
}

- (void)onNewTweet {
    
}

- (void)loadUserProfile {
    User* user = [User currentUser];
    self.name.text = user.name;
    self.twitterHandle.text = [NSString stringWithFormat:@"@%@", user.username];
    self.numberTweets.text = [NSString stringWithFormat:@"%ld", (long)user.tweetCount];
    self.numberFollower.text = [NSString stringWithFormat:@"%ld", (long)user.followerCount];
    self.numberFollowing.text = [NSString stringWithFormat:@"%ld", (long)user.followingCount];
    NSString *hqImageUrl = [user.profileImageUrl stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    [self.profileImage setImageWithURL:[NSURL URLWithString:hqImageUrl]];
    self.profileImage.layer.cornerRadius = 3;
    self.profileImage.clipsToBounds = YES;
     
}

#pragma mark - Table View methods
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetViewCell"];
    cell.tweet = self.tweets[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.prototypeCell.tweet = self.tweets[indexPath.row];
    [self.prototypeCell layoutIfNeeded];
    
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1;
}

- (TweetViewCell *)prototypeCell {
    if (!_prototypeCell) {
        _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetViewCell"];
    }
    return _prototypeCell;
}

#pragma mark - private methods

- (void)refreshTweets {
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        if (error != nil) {
            NSLog(@"Error while loading tweets");
        }
        self.tweets = [tweets mutableCopy];
        [self.tableView reloadData];
    }];
}
@end
