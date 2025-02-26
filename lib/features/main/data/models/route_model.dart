import 'package:f_ecorutas_v1/features/main/domain/entity/route.dart';

class RouteModel extends RouteEntity {
  RouteModel({
    required super.id,
    required super.codigo,
    super.estado,
    super.visitantes = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'codigo': codigo,
      'estado': estado,
      'visitantes': visitantes,
    };
  }

  factory RouteModel.fromMap(Map<String, dynamic> map) {
    return RouteModel(
      id: map['id'],
      codigo: map['codigo'],
      estado: RouteStatus.values
          .firstWhere((e) => e.toString() == 'RouteStatus.${map['estado']}'),
      visitantes: List<String>.from(map['visitantes']),
    );
  }

  factory RouteModel.toEntity(RouteEntity entity) {
    return RouteModel(
      id: entity.id,
      codigo: entity.codigo,
      estado: RouteStatus.values.firstWhere((e) => e == entity.estado),
      visitantes: entity.visitantes,
    );
  }
}
