import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../networking/app_shared_preferences.dart';
import '../utils/log_utils.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  
  StreamController<RemoteMessage>? _messageStreamController;
  Stream<RemoteMessage>? get messageStream => _messageStreamController?.stream;
  
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      // Initialize local notifications
      await _initializeLocalNotifications();
      
      // Request permissions
      await requestPermission();
      
      // Get FCM token
      await getToken();
      
      // Configure message handlers
      _configureMessageHandlers();
      
      _initialized = true;
      LogUtils.logInfo('NotificationService', 'Notification service initialized successfully');
    } catch (e) {
      LogUtils.logError('NotificationService', 'Failed to initialize notification service', error: e);
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const settings = InitializationSettings(android: android, iOS: iOS);
    
    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  Future<void> requestPermission() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    
    LogUtils.logInfo(
      'NotificationService',
      'Permission status: ${settings.authorizationStatus}',
    );
  }

  Future<String?> getToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      if (token != null) {
        await AppSharedPreferences.setFirebaseToken(token);
        LogUtils.logInfo('NotificationService', 'FCM Token obtained and saved');
      }
      return token;
    } catch (e) {
      LogUtils.logError('NotificationService', 'Failed to get FCM token', error: e);
      return null;
    }
  }

  void _configureMessageHandlers() {
    _messageStreamController = StreamController<RemoteMessage>.broadcast();
    
    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LogUtils.logInfo('NotificationService', 'Received foreground message: ${message.messageId}');
      _messageStreamController?.add(message);
      _showLocalNotification(message);
    });
    
    // Background message tap
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      LogUtils.logInfo('NotificationService', 'Message opened app: ${message.messageId}');
      _handleNotificationTap(message.data);
    });
    
    // Check if app was opened from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        LogUtils.logInfo('NotificationService', 'App opened from terminated state: ${message.messageId}');
        _handleNotificationTap(message.data);
      }
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;
    
    const androidDetails = AndroidNotificationDetails(
      'yono_business_channel',
      'YONO Business Notifications',
      channelDescription: 'Notifications for YONO Business app',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      notification.title ?? 'YONO Business',
      notification.body ?? '',
      details,
      payload: message.data.toString(),
    );
  }

  void _onNotificationTapped(NotificationResponse response) {
    LogUtils.logInfo('NotificationService', 'Local notification tapped: ${response.payload}');
    // Handle notification tap
    if (response.payload != null) {
      _handleNotificationTap({'payload': response.payload});
    }
  }

  void _handleNotificationTap(Map<String, dynamic> data) {
    // Navigate based on notification data
    final type = data['type'] ?? '';
    final id = data['id'] ?? '';
    
    switch (type) {
      case 'transaction':
        // Navigate to transaction details
        break;
      case 'payment':
        // Navigate to payment details
        break;
      case 'approval':
        // Navigate to approval screen
        break;
      default:
        // Navigate to notifications screen
        break;
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      LogUtils.logInfo('NotificationService', 'Subscribed to topic: $topic');
    } catch (e) {
      LogUtils.logError('NotificationService', 'Failed to subscribe to topic: $topic', error: e);
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      LogUtils.logInfo('NotificationService', 'Unsubscribed from topic: $topic');
    } catch (e) {
      LogUtils.logError('NotificationService', 'Failed to unsubscribe from topic: $topic', error: e);
    }
  }

  Future<void> clearAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  Future<void> clearNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  Future<void> setBadgeCount(int count) async {
    if (Platform.isIOS) {
      // iOS badge handling
    }
  }

  void dispose() {
    _messageStreamController?.close();
  }
}