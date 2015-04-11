//
//  chooseFriendTableViewCell.h
//  Sportplus
//
//  Created by 虎猫儿 on 15/3/9.
//  Copyright (c) 2015年 JiaZai. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "spUser.h"

@class chooseFriendTableViewCell ;

@protocol chooseFriendTableViewCellStateDelegate <NSObject>
@required

- (void)didClickedCell:(chooseFriendTableViewCell *)cell changeCellStateTo:(BOOL)state ;

@end

@interface chooseFriendTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *academyLabel;

@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;

@property id<chooseFriendTableViewCellStateDelegate> delegate ;

- (IBAction)btnClicked:(id)sender;

- (void)initWithSpUser:(spUser *)user andState:(BOOL)selected ;

@end
