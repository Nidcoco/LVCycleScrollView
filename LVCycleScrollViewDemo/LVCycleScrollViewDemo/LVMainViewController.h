//
//  LVMainViewController.h
//  LVCycleScrollViewDemo
//
//  Created by Levi on 2020/7/30.
//  Copyright © 2020 None. All rights reserved.
//

#import <UIKit/UIKit.h>

#define iPhoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

NS_ASSUME_NONNULL_BEGIN

@interface LVMainViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
