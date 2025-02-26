import 'package:equatable/equatable.dart';
import 'package:get/get.dart';

class GpsController extends GetxController {
  final gpsState = GpsState(
    isGpsEnabled: false,
    isGpsPermissionGranted: false,
  ).obs;

  void setGpsState({
    required bool isGpsEnabled,
    required bool isGpsPermissionGranted,
  }) {
    gpsState.value = GpsState(
      isGpsEnabled: isGpsEnabled,
      isGpsPermissionGranted: isGpsPermissionGranted,
    );
  }

  bool get isGpsEnabled => gpsState.value.isGpsEnabled;
  bool get isGpsPermissionGranted => gpsState.value.isGpsPermissionGranted;



  
}

class GpsState extends Equatable {
  final bool isGpsEnabled;
  final bool isGpsPermissionGranted;

  const GpsState({
    required this.isGpsEnabled,
    required this.isGpsPermissionGranted,
  });

  @override
  List<Object> get props => [isGpsEnabled, isGpsPermissionGranted];
}
