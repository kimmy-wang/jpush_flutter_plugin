#import "JpushFlutterPluginPlugin.h"
#import <JCore/JGInforCollectionAuth.h>
// 引入 JPush 功能所需头文件
#import <JPush/JPUSHService.h>

@interface JpushFlutterPluginPlugin () <JPUSHRegisterDelegate>

@property(strong, readonly) FlutterMethodChannel *channel;

@property(strong) NSDictionary *launchOptions;

@end

@implementation JpushFlutterPluginPlugin

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel {
    self = [super init];
    if (self) {
        _channel = channel;
    }
    return self;
}

+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel =
            [FlutterMethodChannel methodChannelWithName:@"plugins.kimmy.me/jpush_flutter_plugin_ios"
                                        binaryMessenger:registrar.messenger];
    JpushFlutterPluginPlugin *instance = [[JpushFlutterPluginPlugin alloc] initWithChannel:channel];
    [registrar addApplicationDelegate:instance];
    [registrar addMethodCallDelegate:instance channel:channel];
}

#pragma mark - <FlutterPlugin> protocol

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"getPlatformName" isEqualToString:call.method]) {
        result(@"iOS");
    } else if ([@"setDebugMode" isEqualToString:call.method]) {
        [self setDebugMode:[call.arguments[@"debugMode"] boolValue] result:result];
    } else if ([@"setAuth" isEqualToString:call.method]) {
        [self setAuth:[call.arguments[@"auth"] boolValue] result:result];
    } else if ([@"init" isEqualToString:call.method]) {
        NSString *appKey = call.arguments[@"appKey"];
        NSString *channel = call.arguments[@"channel"];
        [self initJPush: appKey channel:channel result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)setDebugMode:(Boolean)debugMode result:(FlutterResult)result {
    if (debugMode) {
        [JPUSHService setDebugMode];
    } else {
        [JPUSHService setLogOFF];
    }
    result(nil);
}

- (void)setAuth: (Boolean)auth result:(FlutterResult)result {
    [JGInforCollectionAuth JCollectionAuth:^(JGInforCollectionAuthItems * _Nonnull authInfo) {
        authInfo.isAuth = auth;
    }];
    result(nil);
}

- (void)initJPush:(NSString *) appKey channel:(NSString *) channel result:(FlutterResult)result {
    // Optional
    // 获取 IDFA
    // 如需使用 IDFA 功能请添加此代码并在初始化方法的 advertisingIdentifier 参数中填写对应值
    __block NSString *advertisingId = nil;
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                advertisingId = [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
            }
        }];
    } else {
        // 使用原方式访问 IDFA
        advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }

    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert | JPAuthorizationOptionBadge | JPAuthorizationOptionSound | JPAuthorizationOptionProvidesAppNotificationSettings;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];

    // Required
    // init Push
    // notice: 2.1.5 版本的 SDK 新增的注册方法，改成可上报 IDFA，如果没有使用 IDFA 直接传 nil
    [JPUSHService setupWithOption:self.launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:FALSE
            advertisingIdentifier:advertisingId];

    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if (resCode == 0) {
            NSLog(@"registrationID获取成功：%@", registrationID);

        } else {
            NSLog(@"registrationID获取失败，code：%d", resCode);
        }
    }];
    result(nil);

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.launchOptions = launchOptions;
    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert | JPAuthorizationOptionBadge | JPAuthorizationOptionSound | JPAuthorizationOptionProvidesAppNotificationSettings;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    const unsigned int *tokenBytes = [deviceToken bytes];
    NSString *tokenString = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                    ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                    ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                    ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    NSLog(@"Device Token: %@", tokenString);
    //sdk注册DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

# pragma mark- JPUSHRegisterDelegate

// iOS 12 Support
#ifdef __IPHONE_12_0

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification {
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
    } else {
        //从通知设置界面进入应用
    }
}

#endif

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
            [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                         withString:@"\\U"];
    NSString *tempStr2 =
            [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
            [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
            [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
    return str;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS6及以下系统，收到通知:%@", [self logDic:userInfo]);
//  [rootViewController addNotificationCount];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
      fetchCompletionHandler:
              (void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);

    if ([[UIDevice currentDevice].systemVersion floatValue] < 10.0 || application.applicationState > 0) {
//    [rootViewController addNotificationCount];
    }

    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}


#ifdef NSFoundationVersionNumber_iOS_9_x_Max

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容

    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题

    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);

    } else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}", body, title, subtitle, badge, sound, userInfo);
    }

    NSDictionary *settingsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:title, @"title", subtitle, @"subtitle", body, @"body", badge, @"badge", userInfo, @"userInfo", nil];

    [self.channel invokeMethod:@"sendNotificationMessage" arguments:settingsDictionary];

    completionHandler();  // 系统要求执行这个方法
}


- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary *userInfo = notification.request.content.userInfo;

    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容

    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题

    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);

//      [rootViewController addNotificationCount];

        // TODO:

    } else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}", body, title, subtitle, badge, sound, userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationAuthorization:(JPAuthorizationStatus)status withInfo:(NSDictionary *)info {
    NSLog(@"receive notification authorization status:%lu, info:%@", status, info);
    [self alertNotificationAuthorization:status];
}

#endif

#pragma mark - 通知权限引导

// 检测通知权限授权情况
- (void)checkNotificationAuthorization {
    [JPUSHService requestNotificationAuthorization:^(JPAuthorizationStatus status) {
        // run in main thread, you can custom ui
        NSLog(@"notification authorization status:%lu", status);
        [self alertNotificationAuthorization:status];
    }];
}

// 通知未授权时提示，是否进入系统设置允许通知，仅供参考
- (void)alertNotificationAuthorization:(JPAuthorizationStatus)status {
    if (status < JPAuthorizationStatusAuthorized) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"允许通知" message:@"是否进入设置允许通知？" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alertView show];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (@available(iOS 8.0, *)) {
            [JPUSHService openSettingsForNotification:^(BOOL success) {
                NSLog(@"open settings %@", success ? @"success" : @"failed");
            }];
        }
    }
}


@end
