part of 'gps_bloc.dart';

class GpsState extends Equatable {
  final bool isGpsEnabled;
  final bool isGpsPermissionGranted;

  //  Getter
  bool get isAllGranted => isGpsEnabled && isGpsPermissionGranted;

  const GpsState({
    required this.isGpsEnabled,
    required this.isGpsPermissionGranted,
  });

  @override
  List<Object> get props => [isGpsEnabled, isGpsPermissionGranted];

  //CopyWith
  GpsState copyWith({
    bool? isGpsEnabled,
    bool? isGpsPermissionGranted,
  }) =>
      GpsState(
        isGpsEnabled: isGpsEnabled ?? this.isGpsEnabled,
        isGpsPermissionGranted:
            isGpsPermissionGranted ?? this.isGpsPermissionGranted,
      );
}
