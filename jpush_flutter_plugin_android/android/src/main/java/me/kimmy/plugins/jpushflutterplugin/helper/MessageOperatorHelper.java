package me.kimmy.plugins.jpushflutterplugin.helper;

import android.annotation.SuppressLint;
import android.util.Log;

import java.util.HashMap;

import cn.jpush.android.api.CustomMessage;
import cn.jpush.android.api.NotificationMessage;
import io.flutter.plugin.common.MethodChannel;

public final class MessageOperatorHelper {
    private static final String TAG = "MessageOperatorHelper";

    private MethodChannel channel;

    private MessageOperatorHelper() {
    }

    public static MessageOperatorHelper getInstance() {
        return NotificationMessageOperatorHelperHelper.instance;
    }

    private static class NotificationMessageOperatorHelperHelper {
        private static final MessageOperatorHelper instance = new MessageOperatorHelper();
    }

    public void setChannel(MethodChannel channel) {
        this.channel = channel;
    }

    public void sendCustomMessage(CustomMessage message) {
        if (channel == null) {
            Log.e(TAG, "Please call the 'setChannel()' method first.");
            return;
        }
        channel.invokeMethod("sendCustomMessage", new HashMap<String, Object>(){{
            put("message", message.message);
            put("messageId", message.messageId);
            put("platform", message.platform);
            put("contentType", message.contentType);
            put("extra", message.extra);
            put("senderId", message.senderId);
            put("title", message.title);
        }});
    }

    public void sendNotificationMessage(NotificationMessage message) {
        if (channel == null) {
            Log.e(TAG, "Please call the 'setChannel()' method first.");
            return;
        }
        channel.invokeMethod("sendNotificationMessage", new HashMap<String, Object>(){{
            put("notificationId", message.notificationId);
            put("msgId", message.msgId);
            put("notificationContent", message.notificationContent);
            put("notificationAlertType", message.notificationAlertType);
            put("notificationTitle", message.notificationTitle);
            put("notificationSmallIcon", message.notificationSmallIcon);
            put("notificationLargeIcon", message.notificationLargeIcon);
            put("notificationExtras", message.notificationExtras);
            put("notificationStyle", message.notificationStyle);
            put("notificationBuilderId", message.notificationBuilderId);
            put("notificationBigText", message.notificationBigText);
            put("notificationBigPicPath", message.notificationBigPicPath);
            put("notificationInbox", message.notificationInbox);
            put("notificationPriority", message.notificationPriority);
            put("notificationCategory", message.notificationCategory);
            put("developerArg0", message.developerArg0);
            put("platform", message.platform);
            put("notificationChannelId", message.notificationChannelId);
            put("displayForeground", message.displayForeground);
            put("notificationType", message.notificationType);
            put("inAppMsgType", message.inAppMsgType);
            put("inAppMsgShowType", message.inAppMsgShowType);
            put("inAppMsgShowPos", message.inAppMsgShowPos);
            put("inAppMsgTitle", message.inAppMsgTitle);
            put("inAppMsgContentBody", message.inAppMsgContentBody);
            put("inAppType", message.inAppType);
        }});
    }

}
