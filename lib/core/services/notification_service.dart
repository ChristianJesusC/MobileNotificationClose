import 'package:logger/logger.dart';
import '../constants/app_constants.dart';
import 'secure_storage_service.dart';

class NotificationService {
  final SecureStorageService _secureStorageService;
  final Logger _logger = Logger();

  final List<Function()> _dataWipedCallbacks = [];

  NotificationService(this._secureStorageService);

  void handleNotificationAction(String action, Map<String, dynamic> data) {
    _logger.i('Procesando accion: $action');

    print('');
    print('🎯 NOTIFICATION SERVICE - handleNotificationAction');
    print('🎯 Acción recibida: "$action"');
    print('🎯 Constante esperada: "${AppConstants.wipeDataAction}"');
    print('🎯 ¿Son iguales? ${action == AppConstants.wipeDataAction}');
    print('🎯 Data recibido: $data');

    switch (action) {
      case AppConstants.wipeDataAction:
        print('✅ ENTRANDO AL CASE WIPE_DATA');
        _handleWipeData(data);
        break;
      default:
        print('❌ DEFAULT CASE - Acción no reconocida');
        _logger.w('Accion desconocida: $action');
    }
    print('');
  }

  Future<void> _handleWipeData(Map<String, dynamic> data) async {
    _logger.w('Comando de eliminacion recibido');

    print('');
    print('🗑️ _handleWipeData INICIADO');
    print('🗑️ Data completo: $data');

    final notificationType = data['type'];

    print('🎯 Type recibido: "$notificationType"');
    print('🎯 Constante esperada: "${AppConstants.wipeDataNotificationType}"');
    print(
      '🎯 ¿Son iguales? ${notificationType == AppConstants.wipeDataNotificationType}',
    );

    if (notificationType == AppConstants.wipeDataNotificationType) {
      print('');
      print('💥💥💥 INICIANDO BORRADO DE DATOS 💥💥💥');

      await _secureStorageService.wipeAllSensitiveData();

      print('💥 Llamando callbacks...');
      _notifyDataWiped();

      _logger.w('Datos sensibles eliminados exitosamente');
      print('✅✅✅ BORRADO COMPLETADO ✅✅✅');
      print('');
    } else {
      print('❌ NO ENTRÓ AL IF - Type no coincide');
      print('❌ Esperaba: "${AppConstants.wipeDataNotificationType}"');
      print('❌ Recibió: "$notificationType"');
    }
  }

  void registerDataWipedCallback(Function() callback) {
    _dataWipedCallbacks.add(callback);
  }

  void unregisterDataWipedCallback(Function() callback) {
    _dataWipedCallbacks.remove(callback);
  }

  void _notifyDataWiped() {
    for (var callback in _dataWipedCallbacks) {
      callback();
    }
  }
}
