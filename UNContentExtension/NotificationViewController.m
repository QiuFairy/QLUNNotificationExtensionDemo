//
//  NotificationViewController.m
//  UNContentExtension
//
//  Created by HXYZQ on 2021/7/2.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface NotificationViewController () <UNNotificationContentExtension>
// 创建的时候默认的是这个
@property IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.
    
    // 修改大小
    self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 140);
    
}
// 只要你收到通知，并且保证categoryIdentifier的设置，跟info.plist里面设置的一样，你就会调用这个方法。
// 注意：一个会话的多个通知，每个通知收到时，都可以调用这个方法。
- (void)didReceiveNotification:(UNNotification *)notification {
    NSLog(@"notification.request.content.userInfo%@",notification.request.content.userInfo);
    UNNotificationContent *content = notification.request.content;
    
    UIImage *image = nil;
    if (content.attachments.count) {
        UNNotificationAttachment * attachment_img = content.attachments[0];
        if (attachment_img.URL.startAccessingSecurityScopedResource) {
            image = [UIImage imageWithContentsOfFile:attachment_img.URL.path];
            self.imageView.image = image;
        }
    }
    self.imageView.frame = self.view.frame;
    self.label.text = notification.request.content.body;
}
/*
// 返回 默认的button样式
- (UNNotificationContentExtensionMediaPlayPauseButtonType)mediaPlayPauseButtonType{
    return UNNotificationContentExtensionMediaPlayPauseButtonTypeDefault;
}
// 返回 button的frame
- (CGRect)mediaPlayPauseButtonFrame{
    return CGRectMake(100, 100, 100, 100);
}
// 返回 button的颜色
- (UIColor *)mediaPlayPauseButtonTintColor{
    return [UIColor blueColor];
}
// 点击 button的点击事件
- (void)mediaPlay{
    NSLog(@">>func mediaPlay,开始播放");
    // 点击播放按钮后，4s后暂停播放
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 控制暂停
        [self.extensionContext mediaPlayingPaused];
    });
    
    
}
- (void)mediaPause{
    NSLog(@">>func mediaPause，暂停播放");
    // 点击暂停按钮，10s后开始播放
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 控制播放
        [self.extensionContext mediaPlayingStarted];
    });
}
*/
@end
