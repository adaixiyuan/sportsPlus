//
//  chooseSportFriendViewController.h
//  Sportplus
//
//  Created by 虎猫儿 on 15/3/9.
//  Copyright (c) 2015年 JiaZai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "chooseFriendTableViewCell.h"

@interface chooseSportFriendViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,chooseFriendTableViewCellStateDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
