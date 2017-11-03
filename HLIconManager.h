//
//  HLIconManager.h
//
//

#import <Foundation/Foundation.h>

@interface HLIconManager : NSObject


+ (instancetype) getHLIconManagerInstance;


//////更换之前需要在inf.plist进行相应设置
/////在当前viewController下执行以下两个方法   替换更换图标的弹窗
-(void)iconType:(NSString *)type;
- (void)runtimeReplaceAlert:(UIViewController *)controller;
@end
