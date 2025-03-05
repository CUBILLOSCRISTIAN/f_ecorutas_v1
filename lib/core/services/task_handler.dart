import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(LocationTaskHandler());
}

class LocationTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    print('Servicio en primer plano iniciado');
  }

  @override
  void onRepeatEvent(DateTime timestamp) async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print('Nueva posición: $position');
      // Envía la posición a la UI (opcional)
      FlutterForegroundTask.sendDataToMain({
        "latitude": position.latitude,
        "longitude": position.longitude,
      });
    } catch (e) {
      print('Error obteniendo ubicación: $e');
    }
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    print('Servicio en primer plano detenido');
  }
}
