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
#import "ComposeViewController.h"
#import "TweetDetailViewController.h"
#import "UserTimelineViewController.h"

@interface TweetViewController () <UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate, TweetViewCellDelegate, TweetDetailViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *twitterHandle;
@property (weak, nonatomic) IBOutlet UILabel *numberTweets;
@property (weak, nonatomic) IBOutlet UILabel *numberFollowing;
@property (weak, nonatomic) IBOutlet UILabel *numberFollower;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) TweetViewCell *prototypeCell;
@property (nonatomic, strong) NSMutableArray* tweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

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
    
    // Register Nib and Cell Height
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetViewCell" bundle:nil] forCellReuseIdentifier:@"TweetViewCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // Refresh Control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    [self refreshTweets];
    [self loadUserProfile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - compose view delegate

- (void) didPostTweet:(Tweet *)tweet {
    [self.tweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

#pragma mark - tweet cell delegate

- (void)didUpdateCell:(UITableViewCell *) cell withTweet:(Tweet*)tweet {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.tweets  replaceObjectAtIndex:indexPath.row withObject:tweet];
}

- (void)onImageTap:(UITableViewCell *)cell withTweet:(Tweet *)tweet {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    UserTimelineViewController* vc = [[UserTimelineViewController alloc] init];
    vc.tweet = self.tweets[indexPath.row];
    vc.user = vc.tweet.user;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - detail view delegate

- (void)didUpdateTweet:(Tweet *)tweet atIndexPath:(NSInteger)row {
    [self.tweets  replaceObjectAtIndex:row withObject:tweet];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    NSArray* indexArray = [NSArray arrayWithObjects:indexPath, nil];
    [self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - action handlers

- (void)onLogout {
    [User logout];
}

- (void)onNewTweet {
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    vc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

#pragma mark - Table View methods

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetViewCell"];
    cell.tweet = self.tweets[indexPath.row];
    cell.delegate = self;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    TweetDetailViewController *vc = [[TweetDetailViewController alloc] init];
    vc.tweet = self.tweets[indexPath.row];
    vc.tweetIndex = indexPath.row;
    vc.delegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - private methods

- (void)refreshTweets {
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        if (error != nil) {
            NSLog(@"Error while loading tweets");
        }
        [self.refreshControl endRefreshing];
        self.tweets = [tweets mutableCopy];
        [self.tableView reloadData];
    }];
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
    self.profileImage.layer.cornerRadius = 5;
    self.profileImage.clipsToBounds = YES;
    
}
@end
