//
//  SMHook.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/9.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "SMHook.h"
#import <objc/runtime.h>

@implementation SMHook

+ (void)hookClass:(Class)classObject originSelector:(SEL)originSelector targetSelector:(SEL)targetSelector {
    Class class = classObject;
    
    Method originMethod = class_getInstanceMethod(class, originSelector);
    Method targetMethod = class_getInstanceMethod(class, targetSelector);
    
    IMP targetIMP = method_getImplementation(targetMethod);
    
    BOOL didAdd = class_addMethod(class, originSelector, targetIMP, method_getTypeEncoding(targetMethod));
    if (didAdd) {
        class_replaceMethod(classObject, targetSelector, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    } else {
        method_exchangeImplementations(originMethod, targetMethod);
    }
}

@end
