import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(LocationTaskHandler.instance);
}

class LocationTaskHandler extends TaskHandler {
  LocationTaskHandler._privateConstructor();

  static final LocationTaskHandler instance =
      LocationTaskHandler._privateConstructor();

  final List<Map<String, dynamic>> _locations = [];

  List<Map<String, dynamic>> get locations => _locations;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    print('Servicio en primer plano iniciado');
  }

  @override
  void onRepeatEvent(DateTime timestamp) async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      // Envía la posición a la UI (opcional)

      _locations.add({
        "latitude": position.latitude,
        "longitude": position.longitude,
        "timestamp": DateTime.now().toIso8601String(),
      });
      print("📍 Ubicación guardada: $_locations");

      // Enviar la ubicación a la UI
      FlutterForegroundTask.sendDataToMain({
        "latitude": position.latitude,
        "longitude": position.longitude,
        "timestamp": DateTime.now().toIso8601String(),
      });

      // FlutterForegroundTask.sendDataToMain({
      //   "latitude": position.latitude,
      //   "longitude": position.longitude,
      // });
    } catch (e) {
      print('Error obteniendo ubicación: $e');
    }
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    // Solicita el routeId y userId de alguna manera, por ejemplo, desde un servicio o almacenamiento local
    FlutterForegroundTask.sendDataToMain({
      "action": "finish",
      "locations": _locations,
    });
    print('Servicio en primer plano detenido');
  }
}
