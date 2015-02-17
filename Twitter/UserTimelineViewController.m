//
//  UserTimelineViewController.m
//  Twitter
//
//  Created by Bishwajit Aich. on 2/16/15.
//  Copyright (c) 2015 Bishwajit Aich. All rights reserved.
//

#import "UserTimelineViewController.h"
#import "TweetViewCell.h"
#import "TwitterClient.h"
#import "HederViewController.h"

@interface UserTimelineViewController () <UITableViewDelegate, UITableViewDataSource, TweetViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) TweetViewCell *prototypeCell;
@property (nonatomic, strong) NSMutableArray* tweets;
@property (nonatomic, strong) HederViewController* profileHeader;

@end

@implementation UserTimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.tweet.user.username ,@"screen_name", nil];
    [[TwitterClient sharedInstance]userTimelineWithParams:params completion:^(NSArray *tweets, NSError *error) {
        if (error == nil) {
            self.tweets = [tweets mutableCopy];
            UIView *headerView = self.profileHeader.view;
            headerView.frame = CGRectMake(0, 0, 320, 151);
            self.tableView.tableHeaderView = headerView;
            [self.tableView reloadData];
        }
    }];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.profileHeader = [[HederViewController alloc] init];
    self.profileHeader.user = self.user;
    self.tableView.tableHeaderView = self.profileHeader.view;
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetViewCell" bundle:nil] forCellReuseIdentifier:@"TweetViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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

#pragma mark - tweet cell delegate

- (void)didUpdateCell:(UITableViewCell *) cell withTweet:(Tweet*)tweet {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.tweets  replaceObjectAtIndex:indexPath.row withObject:tweet];
}

- (void)onImageTap:(UITableViewCell *)cell withTweet:(Tweet *)tweet {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    UserTimelineViewController* vc = [[UserTimelineViewController alloc] init];
    vc.tweet = self.tweets[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
