//
//  FriendInviteManageViewController.m
//  Sportplus
//
//  Created by 虎猫儿 on 15/2/27.
//  Copyright (c) 2015年 JiaZai. All rights reserved.
//

#import "FriendInviteManageViewController.h"
#import "spCommon.h"
#import "SPInviteService.h"

#define BtnSelectedColor RGBCOLOR(0, 0, 0)
#define BtnNormalColor RGBCOLOR(234, 234, 234)

typedef enum {
    FriendNavBtnStateLeftBtnSelected = 0 ,
    FriendNavBtnStateRightBtnSelected = 1 ,
} FriendNavBtnState;


@interface FriendInviteManageViewController () {
    NSMutableArray *_dataSourceOfFriendEngagement ;//别人发来的邀请。
    NSMutableArray *_dataSourceOfMySendedEngagement ;//自己发送的邀约。
    
    NSMutableArray *_dataSourceToDisplay ;//要显示的数据,以上两种之一。更具BtnState判断。
    
    FriendNavBtnState _BtnState ;
    UIRefreshControl *_refreshControl ;
}

@end

@implementation FriendInviteManageViewController

#pragma mark - Life Cycle

- (void)setBtnState:(FriendNavBtnState)state {
    _BtnState = state ;
    if (_BtnState == FriendNavBtnStateLeftBtnSelected) {
        _dataSourceToDisplay = _dataSourceOfMySendedEngagement ;
        
        [self.LeftBtnHignLightLine setHidden:FALSE] ;
        [self.checkSendedInviteBtn setTitleColor:BtnSelectedColor forState:UIControlStateNormal] ;
        
        [self.RightBtnHighLightLine setHidden:TRUE] ;
        [self.checkReceivedInviteBtn setTitleColor:BtnNormalColor forState:UIControlStateNormal] ;
    } else {
        _dataSourceToDisplay = _dataSourceOfFriendEngagement ;
        
        [self.RightBtnHighLightLine setHidden:FALSE] ;
        [self.checkSendedInviteBtn setTitleColor:BtnNormalColor forState:UIControlStateNormal] ;
        
        [self.LeftBtnHignLightLine setHidden:TRUE] ;
        [self.checkReceivedInviteBtn setTitleColor:BtnSelectedColor forState:UIControlStateNormal] ;
    }
    
    [self.tableView reloadData] ;
}

- (void)initTableView {
    self.tableView.dataSource = self ;
    self.tableView.delegate = self ;
    
    [self setBtnState:FriendNavBtnStateLeftBtnSelected] ;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init] ;
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged] ;
    
    [self.tableView addSubview:refreshControl] ;
    _refreshControl = refreshControl ;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataSourceToDisplay count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"InviteInfoTableViewCellID" ;
    InviteInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier] ;
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"InviteInfoTableViewCell" owner:self options:nil] lastObject];
    }
    
    cell.delegate = self ;
//    [cell setTag:indexPath.row] ;
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    if (_BtnState == FriendNavBtnStateLeftBtnSelected) {
        
        [leftUtilityButtons sw_addUtilityButtonWithColor:RGBCOLOR(248, 45, 64) title:@"删除"] ;
    } else {
        //FriendNavBtnStateRightBtnSelected ;

        [rightUtilityButtons sw_addUtilityButtonWithColor:RGBCOLOR(56, 204, 90) title:@"接受"] ;
        [rightUtilityButtons sw_addUtilityButtonWithColor:RGBCOLOR(248, 45 , 64) title:@"拒绝"] ;
        cell.leftUtilityButtons = leftUtilityButtons ;
        [cell setRightUtilityButtons:rightUtilityButtons WithButtonWidth:70] ;
    }
    
    return cell ;
}

#pragma mark - SWTableViewCellDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    NSInteger cellIndex = [[self.tableView indexPathForCell:cell] row] ;
    
    if (_BtnState == FriendNavBtnStateLeftBtnSelected) {
        //删除
        NSLog(@"删除") ;
        [self deleteEngagementAtIndex:cellIndex] ;
    } else {
        //FriendNavBtnStateRightBtnSelected ;
        switch ( index ) {
            case 0:
                NSLog(@"接收") ;
                [self acceptEngagementAtIndex:cellIndex] ;
                break;
            case 1 :
                NSLog(@"拒绝") ;
                [self rejectEngagementAtIndex:cellIndex] ;
                break ;
            default:
                break;
        }
    }
    NSLog(@"index = %ld",(long)index) ;
}

#pragma mark - IBAction
- (IBAction)backBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)checkSendedBtnClicked:(id)sender {
    [self setBtnState:FriendNavBtnStateLeftBtnSelected] ;
}

- (IBAction)checkReceivedBtnClicked:(id)sender {
    [self setBtnState:FriendNavBtnStateRightBtnSelected] ;
}

#pragma mark - NetWork Method

- (void)refresh:(UIRefreshControl *)refreshView {
    BOOL networkOnly = refreshView == nil ? FALSE : TRUE ;
    
    [SPUtils showNetworkIndicator] ;
    
    if (_BtnState == FriendNavBtnStateLeftBtnSelected) {
        //邀请我的人
        [SPInviteService findEngagementOfFriendsIsNetWorkOnly:networkOnly ToUser:[spUser currentUser] WithBlock:^(NSArray *objects, NSError *error) {
            
            [SPUtils hideNetworkIndicator] ;
            [SPUtils stopRefreshControl:_refreshControl] ;
            
            if (!error) {
                _dataSourceOfFriendEngagement = [objects mutableCopy];
                NSLog(@"收到的邀约 %@",_dataSourceOfFriendEngagement) ;
                [self.tableView reloadData] ;
            } else {
                [SPUtils alertError:error] ;
            }
        }] ;
    } else {
        //我邀请的人
        [SPInviteService findEngagementOfFriendsIsNetWorkOnly:networkOnly FromUser:[spUser currentUser] WithBlock:^(NSArray *objects, NSError *error) {
            [SPUtils hideNetworkIndicator] ;
            [SPUtils stopRefreshControl:_refreshControl] ;
            
            if (!error) {
                _dataSourceOfMySendedEngagement = [objects mutableCopy] ;
                NSLog(@"我发送的邀约 %@",_dataSourceOfMySendedEngagement) ;
                [self.tableView reloadData] ;
            } else {
                [SPUtils alertError:error] ;
            }
        }] ;
    }
}

#pragma mark - Normal Method

- (void)acceptEngagementAtIndex:(NSInteger)index {
    //接收
    spEngagement_Friend *engagement = (spEngagement_Friend *)[_dataSourceOfFriendEngagement objectAtIndex:index] ;
//    [SPInviteService ]
    [SPInviteService acceptEngagementFriend:engagement withBlock:^(id object, NSError *error) {
#warning !!!
        [self.tableView reloadData] ;
    }] ;

}

- (void)rejectEngagementAtIndex:(NSInteger)index {
    //拒绝
    spEngagement_Friend *engagement = (spEngagement_Friend *)[_dataSourceOfFriendEngagement objectAtIndex:index] ;
    [SPInviteService rejectEngagementFriend:engagement withBlock:^(id object, NSError *error) {
#warning !!!
        [self.tableView reloadData] ;
    }] ;
}

- (void)deleteEngagementAtIndex:(NSInteger)index {
    //本地删除记录
    
    [self.tableView reloadData] ;
}


@end
