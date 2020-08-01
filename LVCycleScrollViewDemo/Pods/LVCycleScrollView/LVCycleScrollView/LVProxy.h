//
//  LVProxy.h
//  LVCycleScrollView
//
//  Created by Levi on 2020/7/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 用来解决定时器循环引用,因为网上说不推荐在viewWillDisappear中销毁timer,用官方的block不可以设置NSRunLoopCommonModes这个模式,导致滑动其他scrollView的时候,定时器会暂停
 */

@interface LVProxy : NSProxy

/// 通过创建对象
- (instancetype)initWithObjc:(id)object;

/// 通过类方法创建创建
+ (instancetype)proxyWithObjc:(id)object;


@end

NS_ASSUME_NONNULL_END
