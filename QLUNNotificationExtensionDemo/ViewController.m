//
//  ViewController.m
//  QLUNNotificationExtensionDemo
//
//  Created by HXYZQ on 2021/7/2.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 200, 200)];
    btn.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(sendLocalNotification:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)sendLocalNotification:(id)sender {
 
    //1.创建通知中心
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
 
    //2.检查当前用户授权
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
 
        NSLog(@"当前授权状态：%zd",[settings authorizationStatus]);
 
        //3.创建通知
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
 
        //3.1通知标题
        content.title = [NSString localizedUserNotificationStringForKey:@"我是title" arguments:nil];
        //3.2小标题
        content.subtitle = @"hellow world";
        //3.3通知内容
        content.body = @"欢迎来到HX";
        //3.4通知声音
        content.sound = [UNNotificationSound defaultSound];
        //3.5通知小圆圈数量
        content.badge = @2;
        
        //4.指定通知的分类
        /**
         (1) identifer表示创建分类时的唯一标识符
         (2）该代码一定要在创建通知请求之前设置，否则无效
         (3) 一般与delegate中注册一样
         */
        // 可以自行尝试将此处ID换成其他的，查看展示UI效果
        content.categoryIdentifier = @"category1";
 
        //5.给通知添加附件(图片 音乐 电影都可以)
        NSString *path = [[NSBundle mainBundle] pathForResource:@"imageName@2x" ofType:@"png"];
        NSURL *url = nil;
        if (path.length != 0) {
            url = [NSURL fileURLWithPath:path];
        }
        UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"image" URL:url options:nil error:nil];
        if (attachment){
            content.attachments = @[attachment];
        }
 
        //6.创建触发器(相当于iOS9中通知触发的时间)
        /**通知触发器主要有三种
         UNTimeIntervalNotificationTrigger  指定时间触发
         UNCalendarNotificationTrigger  指定日历时间触发
         UNLocationNotificationTrigger 指定区域触发
         */
        UNTimeIntervalNotificationTrigger *timeTrigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2.0 repeats:NO];
        
        //7.创建通知请求
        /**
         Identifier:通知请求标识符，用于删除或者查找通知
         content：通知的内容
         trigger：通知触发器
         */
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"localNotification" content:content trigger:timeTrigger];
 
        //8.通知中心发送通知请求
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (error == nil) {
                NSLog(@"通知发送成功");
            }else{
                NSLog(@"%@",error);
            }
        }];
 
    }];
}
- (void)dealloc{
    [self removeAllNotification];
}
#pragma mark - 移除所有通知
- (void)removeAllNotification{
 
    //1.创建通知中心
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
 
    //2.删除已经推送过得通知
    [center removeAllDeliveredNotifications];
 
    //3.删除未推送的通知请求
    [center removeAllPendingNotificationRequests];
}
 
// 移除指定通知
- (void)removeSingleNotification{
 
    //1.创建通知中心
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
 
    //2.删除指定identifer的已经发送的通知
    [center removeDeliveredNotificationsWithIdentifiers:@[@"localNotification"]];
 
    //3.删除指定identifer未发送的同志请求
    [center removeDeliveredNotificationsWithIdentifiers:@[@"localNotification"]];
}

// 影片
// 按日期 / 地点 推送
/**
 // 2.设置通知附件内容
 NSMutableDictionary *optionsDict = [NSMutableDictionary dictionary];
 // 一个包含描述文件的类型统一类型标识符（UTI）一个NSString。如果不提供该键，附件的文件扩展名来确定其类型，常用的类型标识符有 kUTTypeImage,kUTTypeJPEG2000,kUTTypeTIFF,kUTTypePICT,kUTTypeGIF ,kUTTypePNG,kUTTypeQuickTimeImage等。
 
 // 需要导入框架 #import<MobileCoreServices/MobileCoreServices.h>
 optionsDict[UNNotificationAttachmentOptionsTypeHintKey] = (__bridge id _Nullable)(kUTTypeImage);
 // 是否隐藏缩略图
 optionsDict[UNNotificationAttachmentOptionsThumbnailHiddenKey] = @YES;
 // 剪切缩略图
 optionsDict[UNNotificationAttachmentOptionsThumbnailClippingRectKey] = (__bridge id _Nullable)((CGRectCreateDictionaryRepresentation(CGRectMake(0.25, 0.25, 0.5 ,0.5))));
 // 如果附件是影片，则以第几秒作为缩略图
 optionsDict[UNNotificationAttachmentOptionsThumbnailTimeKey] = @1;
 // optionsDict如果不需要，可以不设置，直接传nil即可
 UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"identifier" URL:[NSURL fileURLWithPath:path] options:optionsDict error:&error];
 if (error) {
     NSLog(@"attachment error %@", error);
 }
 content.attachments = @[att];
 content.launchImageName = @"imageName@2x";
 // 2.设置声音
 UNNotificationSound *sound = [UNNotificationSound defaultSound];
 content.sound = sound;
 // 3.触发模式 多久触发，是否重复
  // 3.1 按秒
 UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
  // 3.2 按日期
//    // 周二早上 9：00 上班
//    NSDateComponents *components = [[NSDateComponents alloc] init];
//    // 注意，weekday是从周日开始的计数的
//    components.weekday = 3;
//    components.hour = 9;
//    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
 // 3.3 按地理位置
 // 一到某个经纬度就通知，判断包含某一点么
 // 不建议使用！！！！！！CLRegion *region = [[CLRegion alloc] init];
 
//    CLCircularRegion *circlarRegin = [[CLCircularRegion alloc] init];
//    // 经纬度
//    CLLocationDegrees latitudeDegrees = 123.00; // 维度
//    CLLocationDegrees longitudeDegrees = 123.00; // 经度
//
//    [circlarRegin containsCoordinate:CLLocationCoordinate2DMake(latitudeDegrees, longitudeDegrees)];
//    UNLocationNotificationTrigger *trigger = [UNLocationNotificationTrigger triggerWithRegion:circlarRegin repeats:NO];
 */

@end
