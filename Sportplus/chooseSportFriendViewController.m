//
//  chooseSportFriendViewController.m
//  Sportplus
//
//  Created by 虎猫儿 on 15/3/9.
//  Copyright (c) 2015年 JiaZai. All rights reserved.
//

#import "chooseSportFriendViewController.h"
#import "chooseFriendTableViewCell.h"

#import "spCommon.h"
#import "SPCacheService.h"

#import "SPChineseStringUtils.h"

@interface chooseSportFriendViewController () {
    NSMutableDictionary *_choosedState ;
    //请调用Set方法赋值
    NSMutableArray *_dataSourceOfFriendList ;
    
    NSString *_searchText ;//搜索的姓名
    NSMutableArray *_dataSourceOfDisplayFriendList ;//要显示的朋友列表 ;
//    NSMutableDictionary *_choosedStateOfDisplayFriendList ;//要显示的选中状态 ;
    
    NSMutableArray *_chineseArray ;//排序后的chineseString数组
    NSMutableArray *_sectionTitleArray ;//sectionTitle
    
    UIRefreshControl *_refreshControl ;
}

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

- (NSString *)searchText ;

@end

@implementation chooseSportFriendViewController

- (void)setDataSourceOfFriendList:(NSArray *)FriendList {
    _dataSourceOfFriendList = [FriendList mutableCopy] ;
    
    for (spUser *user in _dataSourceOfFriendList) {
        NSString *key = user.objectId ;
        if ([_choosedState valueForKey:key] == nil) {
            NSNumber *value = [NSNumber numberWithBool:FALSE] ;
            [_choosedState setValue:value forKey:key] ;
        }
    }
    
    [self setDataSourceOfDisplayFriendListWithSearchText] ;
}

- (NSString *)searchText {
    if (_searchText == nil) {
        _searchText = self.searchTextField.text ;
    }
    
    return _searchText ;
}

- (NSMutableArray *)searchFriendListWithName:(NSString *)name {
    if ([name isEqualToString:@""]) {
        return [_dataSourceOfFriendList mutableCopy] ;
    }
    
    
    NSMutableArray *searchedFriendList = [NSMutableArray array];
    
    for (spUser *user in _dataSourceOfFriendList) {
        BOOL res = [user.sP_userName containsString:name] ;
        
        if (res) {
            [searchedFriendList addObject:user] ;
        }
    }
    return searchedFriendList ;
}

/**
 *  搜索用户的方法并设置数据源的方法，调用此方法后应当调用reloadData方法。
 */
- (void)setDataSourceOfDisplayFriendListWithSearchText {
    NSString *searchText = self.searchText ;
    
    _dataSourceOfDisplayFriendList = [self searchFriendListWithName:searchText] ;
    
    _chineseArray =
    [SPChineseStringUtils getChineseStringArrWithSpUserArray:_dataSourceOfDisplayFriendList] ;
    _sectionTitleArray = [SPChineseStringUtils getTitleArray] ;
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    BOOL networkOnly= refreshControl!=nil;
    
    NSLog(@"开始刷新朋友列表") ;
    
    [SPUtils showNetworkIndicator] ;
    [SPUserService findFriendsIsNetworkOnly:networkOnly callback:^(NSArray *objects, NSError *error) {
        [SPUtils hideNetworkIndicator] ;
        [SPUtils stopRefreshControl:refreshControl] ;
        
        CDBlock callback = ^ {
            [self setDataSourceOfFriendList:objects] ;
            [SPCacheService registerUsers:_dataSourceOfFriendList] ;
            [SPCacheService setFriends:_dataSourceOfFriendList] ;
            [self.tableView reloadData] ;
        } ;
        
        if (error && (error.code == kAVErrorCacheMiss || error.code == 1)) {
            objects = [NSMutableArray array] ;
            callback() ;
        } else {
            [SPUtils filterError:error callback:callback] ;
        }
    }] ;
}

#pragma mark - Life Cycle

- (void)initTableView {
    
    self.tableView.delegate = self ;
    self.tableView.dataSource = self ;
    {
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init] ;
        [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged] ;
        
        _refreshControl = refreshControl ;
        [self.tableView addSubview:_refreshControl] ;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableView] ;
    
    self.searchTextField.returnKeyType = UIReturnKeySearch ;
    self.searchTextField.clearsOnBeginEditing = YES ;
    
    [self refresh:nil] ;
    
    _choosedState = [[NSMutableDictionary alloc] init] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.searchTextField resignFirstResponder] ;
    [self setDataSourceOfDisplayFriendListWithSearchText] ;
    [self.tableView reloadData] ;
    return YES ;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.searchTextField resignFirstResponder];
    [self setDataSourceOfDisplayFriendListWithSearchText] ;
    [self.tableView reloadData] ;
}

#pragma mark - IBAction

- (IBAction)backBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)ensureBtnClicked:(id)sender {
    NSLog(@"确定") ;
    
    NSMutableArray *choosedUserIds = [NSMutableArray array] ;
    
    for (NSString* key in _choosedState) {
        BOOL res = [_choosedState[key] boolValue] ;
        
        if (res) {
            [choosedUserIds addObject:key] ;
        }
    }
    
    [SPUserService findUsersByIds:choosedUserIds callback:^(NSArray *objects, NSError *error) {
        if (!error) {
            [sp_notificationCenter postNotificationName:NOTIFICATION_FRIENDS_CHOOSED object:objects] ;
            [self.navigationController popViewControllerAnimated:YES] ;
        } else {
            [SPUtils alertError:error] ;
        }
    }] ;

}

#pragma mark - UITableViewDelegate

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *sectionTitle = [[UILabel alloc]init];
    sectionTitle.frame = CGRectMake(20, 2, 200, 22);
    sectionTitle.numberOfLines = 0;
    sectionTitle.textColor = [UIColor whiteColor];
    sectionTitle.font = [UIFont fontWithName:@"Menlo-Bold" size:12];
    sectionTitle.text = [_sectionTitleArray objectAtIndex:section];
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 22)];
    UIImage *sectionImg = [UIImage imageNamed:@"sectionBackground"];
    UIImageView *sectionBackground = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 22)];
    sectionBackground.image=sectionImg;
    [sectionView addSubview:sectionBackground];
    [sectionView addSubview:sectionTitle];
    
    return sectionView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_chineseArray[section] count] ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_sectionTitleArray count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"chooseFriendTableViewCellID" ;
    
    chooseFriendTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID] ;
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"chooseFriendTableViewCell" owner:self options:nil] lastObject];
    }
    
    spUser *userForCell = [((ChineseString *)_chineseArray[indexPath.section][indexPath.row]) myUser] ;
    
    cell.delegate = self ;
    
    BOOL state = [[_choosedState valueForKey:userForCell.objectId] boolValue] ;
    
    [cell initWithSpUser:userForCell andState:state] ;
    
    
    return cell ;
}

#pragma mark - chooseFriendTableViewCellStateDelegate

- (void)didClickedCell:(chooseFriendTableViewCell *)cell changeCellStateTo:(BOOL)state {
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell] ;
    spUser *userForCell = [((ChineseString *)_chineseArray[indexPath.section][indexPath.row]) myUser] ;
    
    [_choosedState setValue:[NSNumber numberWithBool:state] forKey:userForCell.objectId] ;
}

@end