import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_foreground_task/models/notification_permission.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

part 'gps_event.dart';
part 'gps_state.dart';

/// `GpsBloc` es una clase que extiende `Bloc` y maneja eventos y estados relacionados con el GPS.
///
/// Esta clase se encarga de:
/// - Verificar si el servicio de GPS está habilitado.
/// - Escuchar cambios en el estado del servicio de GPS.
/// - Emitir eventos y actualizar el estado en consecuencia.
///
/// Propiedades:
/// - `gpsServiceSubscription`: Una suscripción al stream que escucha los cambios en el estado del servicio de GPS.
///
/// Constructor:
/// - `GpsBloc()`: Inicializa el estado con `isGpsEnabled` y `isGpsPermissionGranted` en `false`, y configura el manejador de eventos para `GpsPermissionEvent`.
///
/// Métodos:
/// - `_init()`: Método privado que verifica el estado inicial del GPS y emite un evento `GpsPermissionEvent`.
/// - `_checkGpsStatus()`: Método privado que verifica si el servicio de GPS está habilitado y escucha cambios en el estado del servicio.
/// - `close()`: Cancela la suscripción al stream del servicio de GPS antes de cerrar el `Bloc`.
class GpsBloc extends Bloc<GpsEvent, GpsState> {
  StreamSubscription? gpsServiceSubscription;

  GpsBloc()
      : super(GpsState(isGpsEnabled: false, isGpsPermissionGranted: false)) {
    on<GpsPermissionEvent>(
      (event, emit) => emit(
        state.copyWith(
            isGpsEnabled: event.isGpsEnabled,
            isGpsPermissionGranted: event.isGpsPermissionGranted),
      ),
    );

    _init();
  }

  Future<void> _init() async {
    await _requestPermissions();
    //Ejecuto en simultaneo las peticiones
    final gpsInitStatus = await Future.wait([
      _checkGpsStatus(),
      _isPermissionGranted(),
    ]);

    add(GpsPermissionEvent(
      isGpsEnabled: gpsInitStatus[0],
      isGpsPermissionGranted: gpsInitStatus[1],
    ));
  }

  Future<bool> _isPermissionGranted() async {
    final PermissionStatus status = await Permission.location.status;
    return status.isGranted;
  }

  Future<bool> _checkGpsStatus() async {
    final bool isGpsEnabled = await Geolocator.isLocationServiceEnabled();

    gpsServiceSubscription =
        Geolocator.getServiceStatusStream().listen((status) {
      final isGpsEnabled = (status.index == 1) ? true : false;

      add(GpsPermissionEvent(
        isGpsEnabled: isGpsEnabled,
        isGpsPermissionGranted: state.isGpsPermissionGranted,
      ));
    });

    return isGpsEnabled;
  }

  Future<void> askGpsAccess() async {
    //Pantalla de solicitud
    final status = await Permission.location.request();

    switch (status) {
      case PermissionStatus.granted:
        add(GpsPermissionEvent(
          isGpsEnabled: state.isGpsEnabled,
          isGpsPermissionGranted: true,
        ));
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.provisional:
        add(GpsPermissionEvent(
          isGpsEnabled: state.isGpsEnabled,
          isGpsPermissionGranted: false,
        ));
        openAppSettings();
    }
  }

  Future<void> _requestPermissions() async {
    // Android 13+, you need to allow notification permission to display foreground service notification.
    //
    // iOS: If you need notification, ask for permission.
    final NotificationPermission notificationPermission =
        await FlutterForegroundTask.checkNotificationPermission();
    if (notificationPermission != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }

    if (Platform.isAndroid) {
      // Android 12+, there are restrictions on starting a foreground service.
      //
      // To restart the service on device reboot or unexpected problem, you need to allow below permission.
      if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
        // This function requires `android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` permission.
        await FlutterForegroundTask.requestIgnoreBatteryOptimization();
      }

      // Use this utility only if you provide services that require long-term survival,
      // such as exact alarm service, healthcare service, or Bluetooth communication.
      //
      // This utility requires the "android.permission.SCHEDULE_EXACT_ALARM" permission.
      // Using this permission may make app distribution difficult due to Google policy.
      if (!await FlutterForegroundTask.canScheduleExactAlarms) {
        // When you call this function, will be gone to the settings page.
        // So you need to explain to the user why set it.
        await FlutterForegroundTask.openAlarmsAndRemindersSettings();
      }
    }
  }

  @override
  Future<void> close() {
    gpsServiceSubscription?.cancel();
    return super.close();
  }
}
