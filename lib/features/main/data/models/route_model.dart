import 'package:f_ecorutas_v1/features/main/domain/entity/route.dart';

class RouteModel extends RouteEntity {
  RouteModel({
    required super.id,
    required super.code,
    super.status,
    super.participants = const [],
  });

  //tojson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'status': status.toString().split('.').last,
      'participants': participants,
    };
  }

  factory RouteModel.fromMap(Map<String, dynamic> map) {
    return RouteModel(
      id: map['id'],
      code: map['code'],
      status: RouteStatus.values
          .firstWhere((e) => e.toString() == 'RouteStatus.${map['estado']}'),
      participants: List<String>.from(map['participants']),
    );
  }

  factory RouteModel.toEntity(RouteEntity entity) {
    return RouteModel(
      id: entity.id,
      code: entity.code,
      status: entity.status,
      participants: entity.participants,
    );
  }
}
