//
//  SettingViewController.h
//  Sportplus
//
//  Created by Forever.H on 14/12/21.
//  Copyright (c) 2014年 JiaZai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate>{
    NSMutableArray *titleArray;
    NSMutableArray *cellTitle;
}
@property (weak, nonatomic) IBOutlet UITableView *settingTable;

@end
