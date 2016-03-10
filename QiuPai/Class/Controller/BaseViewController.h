//
//  BaseViewController.h
//  QiuPai
//
//  Created by bigqiang on 15/11/28.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MBLoadingCB)(void);

@interface BaseViewController : UIViewController

@property (nonatomic, strong) DDActivityIndicatorView *netIndicatorView;
@property (nonatomic, strong) NoDataTipView *noDataTipV;
@property (nonatomic, strong) NoDataTipView *noDataTipView;
@property (nonatomic, strong) BadNetTipView *badNetTipV;

// 返回上一个ViewController
- (void)backToPreVC:(id)sender;

- (void)loadingViewDismiss;

- (void)loadingViewShow:(NSString *)tipStr;

- (void)loadingTipView:(NSString *)tipStr callBack:(MBLoadingCB)callBack;

- (void)showMoreOperationBtn;

@end
