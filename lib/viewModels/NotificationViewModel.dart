import 'base_view_model.dart';
import '../models/notification_model.dart';
import '../networking/http_util.dart';
import '../networking/app_constants.dart';
import '../networking/base_response.dart';

class NotificationViewModel extends BaseViewModel {
  List<NotificationModel> _notifications = [];
  int _unreadCount = 0;
  Map<String, dynamic>? _notificationSettings;
  
  List<NotificationModel> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  Map<String, dynamic>? get notificationSettings => _notificationSettings;
  
  Future<void> loadNotifications({int page = 1, int limit = 20}) async {
    await makeApiCall<BaseResponse<PaginatedResponse<NotificationModel>>>(
      () async {
        final response = await HttpUtil.get(
          '/notifications',
          queryParameters: {
            'page': page,
            'limit': limit,
          },
        );
        return BaseResponse.fromJson(
          response.data,
          (json) => PaginatedResponse.fromJson(
            json as Map<String, dynamic>,
            (item) => NotificationModel.fromJson(item as Map<String, dynamic>),
          ),
        );
      },
      onSuccess: (response) {
        if (response.success && response.data != null) {
          if (page == 1) {
            _notifications = response.data!.items;
          } else {
            _notifications.addAll(response.data!.items);
          }
          _updateUnreadCount();
        }
      },
    );
  }
  
  Future<bool> markAsRead(String notificationId) async {
    final result = await makeApiCall<BaseResponse<dynamic>>(
      () async {
        final response = await HttpUtil.put(
          '/notifications/$notificationId/read',
        );
        return BaseResponse.fromJson(
          response.data,
          (json) => json,
        );
      },
      onSuccess: (response) {
        if (response.success) {
          final index = _notifications.indexWhere((n) => n.notificationId == notificationId);
          if (index != -1) {
            _notifications[index] = _notifications[index].copyWith(isRead: true);
            _updateUnreadCount();
          }
        }
      },
    );
    
    return result?.success ?? false;
  }
  
  Future<bool> markAllAsRead() async {
    final result = await makeApiCall<BaseResponse<dynamic>>(
      () async {
        final response = await HttpUtil.put('/notifications/read-all');
        return BaseResponse.fromJson(
          response.data,
          (json) => json,
        );
      },
      onSuccess: (response) {
        if (response.success) {
          _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
          _unreadCount = 0;
        }
      },
    );
    
    return result?.success ?? false;
  }
  
  Future<bool> deleteNotification(String notificationId) async {
    final result = await makeApiCall<BaseResponse<dynamic>>(
      () async {
        final response = await HttpUtil.delete(
          '/notifications/$notificationId',
        );
        return BaseResponse.fromJson(
          response.data,
          (json) => json,
        );
      },
      onSuccess: (response) {
        if (response.success) {
          _notifications.removeWhere((n) => n.notificationId == notificationId);
          _updateUnreadCount();
        }
      },
    );
    
    return result?.success ?? false;
  }
  
  Future<void> loadNotificationSettings() async {
    await makeApiCall<BaseResponse<Map<String, dynamic>>>(
      () async {
        final response = await HttpUtil.get(AppConstants.NOTIFICATION_SETTINGS);
        return BaseResponse.fromJson(
          response.data,
          (json) => json as Map<String, dynamic>,
        );
      },
      onSuccess: (response) {
        if (response.success && response.data != null) {
          _notificationSettings = response.data;
        }
      },
    );
  }
  
  Future<bool> updateNotificationSettings(Map<String, dynamic> settings) async {
    final result = await makeApiCall<BaseResponse<dynamic>>(
      () async {
        final response = await HttpUtil.put(
          AppConstants.NOTIFICATION_SETTINGS,
          data: settings,
        );
        return BaseResponse.fromJson(
          response.data,
          (json) => json,
        );
      },
      onSuccess: (response) {
        if (response.success) {
          _notificationSettings = settings;
        }
      },
    );
    
    return result?.success ?? false;
  }
  
  void _updateUnreadCount() {
    _unreadCount = _notifications.where((n) => !n.isRead).length;
    notifyListeners();
  }
  
  Future<void> refreshNotifications() async {
    await loadNotifications();
  }
}