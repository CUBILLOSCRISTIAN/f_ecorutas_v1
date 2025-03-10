import 'package:f_ecorutas_v1/core/services/task_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'foreground_event.dart';
import 'foreground_state.dart';

class ForegroundBloc extends Bloc<ForegroundEvent, ForegroundState> {
  ForegroundBloc() : super(TrackingStopped()) {
    on<StartTracking>(_startService);
    on<StopTracking>(_stopService);

    _initService();
  }

  Future<void> _startService(
      StartTracking event, Emitter<ForegroundState> emit) async {
    await FlutterForegroundTask.startService(
      notificationTitle: '🚀 Tracking Activo',
      notificationText: 'Capturando ubicación continua con el recorrido...',
      callback: startCallback,
    );
    emit(TrackingRunning());
  }

  Future<void> _stopService(
      StopTracking event, Emitter<ForegroundState> emit) async {
    await FlutterForegroundTask.stopService();
    emit(TrackingStopped());
  }

  void _initService() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'foreground_service',
        channelName: 'Foreground Service Notification',
        channelDescription:
            'This notification appears when the foreground service is running.',
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(5000),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }
}
