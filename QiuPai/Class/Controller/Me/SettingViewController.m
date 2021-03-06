//
//  SettingViewController.m
//  QiuPai
//
//  Created by bigqiang on 15/11/21.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingCell.h"
#import "AboutQPKViewController.h"

@interface SettingViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
    NSArray *_configArr;
    UITableView *_settingTV;
    CGFloat _cacheSize;
}
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _configArr = @[@[@"清除缓存"], @[@"关于", @"去评分"], @[@"退出登录"]];
    if ([[QiuPaiUserModel getUserInstance] isTimeOut]) {
        _configArr = @[@[@"清除缓存"], @[@"关于", @"去评分"]];
    }
    
//    , @"意见反馈"
    _cacheSize = [[SDImageCache sharedImageCache] getSize] / 1024.0 / 1024.0;
    
    
    [self initSettingTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:IdentifierAboutQPK]) {
        AboutQPKViewController *vc = [[AboutQPKViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.title = @"关于";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)initSettingTableView {
    _settingTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, kFrameHeight) style:UITableViewStylePlain];
    [_settingTV setDelegate:self];
    [_settingTV setDataSource:self];
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    [_settingTV setBackgroundColor:Gray240Color];
    [_settingTV setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_settingTV];
    
    UIView *tmpView = [[UIView alloc] init];
    [tmpView setBackgroundColor:[UIColor clearColor]];
    [_settingTV setTableFooterView:tmpView];
}

- (void)updateViewAfterClearDisk {
    _cacheSize = [[SDImageCache sharedImageCache] getSize] / 1024.0 / 1024.0;
    [_settingTV reloadData];
}

#pragma mark - TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_configArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_configArr[section] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 17.0f)];
    [tmpView setBackgroundColor:[UIColor clearColor]];
    return tmpView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 17.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 43.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"setttingCell";
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSString *tipStr = [_configArr[indexPath.section] objectAtIndex:indexPath.row];
    NSString *valueStr = [NSString stringWithFormat:@"%.2fM", _cacheSize];
    if (_cacheSize < 0.000001) {
        valueStr = @"0M";
    }
    [cell bindCellWithData:tipStr valueStr:valueStr indexPath:(NSIndexPath*)indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确定清除缓存么？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            [alert show];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self performSegueWithIdentifier:IdentifierAboutQPK sender:nil];
        } else if (indexPath.row == 1) {
            NSURL * url = [NSURL URLWithString:AppStoreUrlString];
            [[UIApplication sharedApplication] openURL:url];
        }
        
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            // 退出登录
            NSLog(@"退出登录");
            [[QiuPaiUserModel getUserInstance] userLogout];
            [self backToPreVC:nil];
        }
    }
}

#pragma -mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        __weak __typeof(self)weakSelf = self;
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [weakSelf updateViewAfterClearDisk];
        }];
        
        [[SDImageCache sharedImageCache] cleanDiskWithCompletionBlock:^{}];
        
    } else if (buttonIndex == 1) {
        
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
