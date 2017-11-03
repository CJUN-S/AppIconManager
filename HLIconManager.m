//
//  HLIconManager.m
//
//

#import "HLIconManager.h"
#import <objc/runtime.h>

@implementation HLIconManager
+ (instancetype) getHLIconManagerInstance
{
    static dispatch_once_t onceToken;
    static HLIconManager *_single;
    dispatch_once(&onceToken, ^{
        if (_single == nil)
        {
            _single = [[HLIconManager alloc] init];
        }
    });
    return _single;
}

/*
 <key>CFBundleIcons</key>
	<dict>
 <key>CFBundleAlternateIcons</key>
 <dict>
 <key>test2</key>
 <dict>
 <key>CFBundleIconFiles</key>
 <array>
 <string>test2</string>
 </array>
 <key>UIPrerenderedIcon</key>
 <false/>
 </dict>
 <key>test1</key>
 <dict>
 <key>CFBundleIconFiles</key>
 <array>
 <string>test1</string>
 </array>
 <key>UIPrerenderedIcon</key>
 <false/>
 </dict>
 </dict>
 <key>CFBundlePrimaryIcon</key>
 <dict>
 <key>CFBundleIconFiles</key>
 <array>
 <string>87</string>
 </array>
 </dict>
	</dict>

 */
//////更换之前需要在inf.plist进行相应设置
-(void)iconType:(NSString *)type{
    ////该方法10.3以后的系统才支持:
    if ([UIApplication  instancesRespondToSelector:@selector(setAlternateIconName:completionHandler:)]) {
        NSLog(@"you can change this app's icon");
    }else{
        NSLog(@"you can not change this app's icon");////该方法10.3以后的系统才支持
        return;
    }
    if ([UIApplication  sharedApplication].supportsAlternateIcons) {
        NSLog(@"you can change this app's icon");
    }else{
        NSLog(@"you can not change this app's icon");
        return;
    }
    ///NSString *iconName = [[UIApplication sharedApplication] alternateIconName]; .supportsAlternateIcons
    
    switch ([type intValue]) {
        case 1:
            
            [[UIApplication sharedApplication] setAlternateIconName:nil completionHandler:^(NSError * _Nullable error) {
                DLog(@"原始图标");
            }];
            break;
        case 2:
            
            [[UIApplication sharedApplication] setAlternateIconName:@"test1" completionHandler:^(NSError * _Nullable error) {
                DLog(@"新换图标");
            }];
            break;
        case 3:
            
            [[UIApplication sharedApplication] setAlternateIconName:@"test2" completionHandler:^(NSError * _Nullable error) {
                DLog(@"新换图标");
            }];
            break;
            
        default:
            break;
    }
  
}

/////在当前viewController下执行以下两个方法   替换更换图标的弹窗
// 利用runtime来替换展现弹出框的方法
- (void)runtimeReplaceAlert:(UIViewController *)controller
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method presentM = class_getInstanceMethod(controller.class, @selector(presentViewController:animated:completion:));
        Method presentSwizzlingM = class_getInstanceMethod(self.class, @selector(ox_presentViewController:animated:completion:));
        // 交换方法实现
        method_exchangeImplementations(presentM, presentSwizzlingM);
    });
}

// 自己的替换展示弹出框的方法
- (void)ox_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    
    if ([viewControllerToPresent isKindOfClass:[UIAlertController class]]) {
        NSLog(@"title : %@",((UIAlertController *)viewControllerToPresent).title);
        NSLog(@"message : %@",((UIAlertController *)viewControllerToPresent).message);
        
        // 换图标时的提示框的title和message都是nil，由此可特殊处理
        UIAlertController *alertController = (UIAlertController *)viewControllerToPresent;
        if (alertController.title == nil && alertController.message == nil) { // 是换图标的提示
            return;
        } else {// 其他提示还是正常处理
            [self ox_presentViewController:viewControllerToPresent animated:flag completion:completion];
            return;
        }
    }
    
    [self ox_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

@end
