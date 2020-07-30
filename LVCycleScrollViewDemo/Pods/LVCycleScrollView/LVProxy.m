//
//  LVProxy.m
//  LVCycleScrollView
//
//  Created by Levi on 2020/7/31.
//

#import "LVProxy.h"

@interface LVProxy ()

@property (nonatomic, weak) id object;

@end

@implementation LVProxy

- (instancetype)initWithObjc:(id)object {
    
    self.object = object;
    return self;
}

+ (instancetype)proxyWithObjc:(id)object {
    
    return [[self alloc] initWithObjc:object];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    
    if ([self.object respondsToSelector:invocation.selector]) {
        
        [invocation invokeWithTarget:self.object];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    
    return [self.object methodSignatureForSelector:sel];
}

@end
