import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';
import 'notification_service.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final logger = Logger();
  logger.i('Mensaje en background: ${message.messageId}');
}

class FirebaseService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final Logger _logger = Logger();

  Future<void> initialize(NotificationService notificationService) async {
    await _requestPermission();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _logger.i('Mensaje recibido en foreground: ${message.messageId}');
      _handleMessage(message, notificationService);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _logger.i('Notificacion abierta: ${message.messageId}');
      _handleMessage(message, notificationService);
    });

    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _logger.i('App abierta desde notificacion: ${initialMessage.messageId}');
      _handleMessage(initialMessage, notificationService);
    }

    final token = await getToken();
    _logger.i('FCM Token: $token');
  }

  Future<void> _requestPermission() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    _logger.i('Permisos de notificacion: ${settings.authorizationStatus}');
  }

  Future<String?> getToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      _logger.e('Error obteniendo token: $e');
      return null;
    }
  }

  void _handleMessage(
    RemoteMessage message,
    NotificationService notificationService,
  ) {
    final data = message.data;

    // LOGS DE DEBUG
    print('');
    print('🔥🔥🔥 NOTIFICACIÓN RECIBIDA 🔥🔥🔥');
    print('📱 MessageId: ${message.messageId}');
    print('📦 Data completo: $data');
    print('🔍 Keys en data: ${data.keys.toList()}');
    print('🔍 Tiene "action"? ${data.containsKey('action')}');
    print('🔍 Tiene "type"? ${data.containsKey('type')}');

    if (data.containsKey('action')) {
      final action = data['action'];
      print('⚡ Acción encontrada: "$action"');
      print('⚡ Tipo: ${action.runtimeType}');
      _logger.w('Accion recibida: $action');

      if (action == 'WIPE_DATA') {
        print('✅ ES WIPE_DATA - Procesando...');
      } else {
        print('❌ NO ES WIPE_DATA - Es: "$action"');
      }

      notificationService.handleNotificationAction(action, data);
    } else {
      print('❌ ERROR: NO SE ENCONTRÓ LA KEY "action"');
      print('❌ Keys disponibles: ${data.keys.toList()}');
    }
    print('🔥🔥🔥 FIN PROCESAMIENTO 🔥🔥🔥');
    print('');
  }

  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    _logger.i('Suscrito al topic: $topic');
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    _logger.i('Desuscrito del topic: $topic');
  }
}
