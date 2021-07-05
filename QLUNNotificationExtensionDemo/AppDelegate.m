//
//  AppDelegate.m
//  QLUNNotificationExtensionDemo
//
//  Created by HXYZQ on 2021/7/2.
//

#import "AppDelegate.h"
//iOS10通知新框架
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self requestAuth:application];
    [self setCategoryNotification];
    return YES;
}
-(void)requestAuth:(UIApplication *)application{
    //iOS10特有
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        if (granted) {
            // 点击允许
            [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                NSLog(@"%@", settings);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [application registerForRemoteNotifications];
                    });
            }];
        } else {
            // 点击不允许
         
        }
        
    }];
}

#pragma mark - 创建通知分类(交互按钮)
-(void)setCategoryNotification{
    //文本交互(iOS10之后支持对通知的文本交互)
     
    /**options
     UNNotificationActionOptionAuthenticationRequired  用于文本
     UNNotificationActionOptionForeground  前台模式，进入APP
     UNNotificationActionOptionDestructive  销毁模式，不进入APP
     */
    UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:@"action1" title:@"关闭" options:UNNotificationActionOptionAuthenticationRequired ];
    
    //打开应用按钮
    UNNotificationAction *action2 = [UNNotificationAction actionWithIdentifier:@"action2" title:@"启动app" options:UNNotificationActionOptionForeground];
    
    //不打开应用按钮
    UNNotificationAction *action3 = [UNNotificationAction actionWithIdentifier:@"action3" title:@"红色样式" options:UNNotificationActionOptionDestructive];
    
    //创建分类
    /**
     Identifier:分类的标识符，通知可以添加不同类型的分类交互按钮
     actions：交互按钮
     intentIdentifiers：分类内部标识符  没什么用 一般为空就行
     options:通知的参数   UNNotificationCategoryOptionCustomDismissAction:自定义交互按钮   UNNotificationCategoryOptionAllowInCarPlay:车载交互
     */
    UNNotificationCategory  *category1 = [UNNotificationCategory categoryWithIdentifier:@"category1" actions:@[action1,action2,action3] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
    
    UNTextInputNotificationAction *action5 =  [UNTextInputNotificationAction  actionWithIdentifier:@"textInputAction" title:@"" options:UNNotificationActionOptionForeground textInputButtonTitle:@"回复" textInputPlaceholder:@"写你想写的"];
    
    UNNotificationCategory *category2 = [UNNotificationCategory categoryWithIdentifier:@"category2" actions:@[action5] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
    
    [[UNUserNotificationCenter currentNotificationCenter]setNotificationCategories:[NSSet setWithObjects:category1,category2, nil]];
}

// 处理弹框
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler  {
    if (@available(iOS 14.0, *)) {
        completionHandler(UNNotificationPresentationOptionList | UNNotificationPresentationOptionBanner);
    }else{
        completionHandler(UNNotificationPresentationOptionAlert);
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = [notification.request.content.badge integerValue];
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler{
    
    UNNotificationContent *content = [response.notification.request.content mutableCopy];
    NSString *category = content.categoryIdentifier;
    NSLog(@"category:12121212 ==== %@",category);
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            NSLog(@"iOS10 收到远程通知:12121212");
    }else {
        //按钮点击事件
        if ([response.actionIdentifier isEqualToString:@"textInputAction"]) {
         
                //获取文本响应
                UNTextInputNotificationResponse *textResponse = (UNTextInputNotificationResponse *)response;
         
                NSLog(@"输入的内容为：%@",textResponse.userText);

        }
        
        // 判断为本地通知
        NSLog(@"iOS10  121212 收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",content.body,content.title,content.subtitle,content.badge,content.sound,content.userInfo);
      }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    completionHandler();
}
// 用户允许通知，会进入此回调
//- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
//    // 注册通知
//    [application registerForRemoteNotifications];
//}
// 注册成功的回调 获取token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    // 在此回调中获得deviceToken
    NSString *tokenString = [NSString stringWithFormat:@"%@",deviceToken];
    // 对数据进行处理，删除<、>、空格
    tokenString = [tokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    tokenString = [tokenString stringByReplacingOccurrencesOfString:@"<" withString:@""];
    tokenString = [tokenString stringByReplacingOccurrencesOfString:@">" withString:@""];
    // 将处理好的tokenString上传给服务器
}
// 注册失败的回调
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"输入的内容为：%@",error.userInfo);
}
@end
