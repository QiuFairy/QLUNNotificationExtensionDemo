//
//  NotificationService.h
//  UNServiceExtension
//
//  Created by HXYZQ on 2021/7/2.
//
/**
 这个是对接收到的数据进行的一次处理
 APNs --> 此service --> iphone展示
 */
#import <UserNotifications/UserNotifications.h>

@interface NotificationService : UNNotificationServiceExtension

@end
