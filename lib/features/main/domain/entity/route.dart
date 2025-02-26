class RouteEntity {
  String id;
  String codigo;
  RouteStatus estado;
  List<String> visitantes;

  RouteEntity(
      {required this.id,
      required this.codigo,
      this.estado = RouteStatus.esperando,
      this.visitantes = const []});

  // //toMap
  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     'codigo': codigo,
  //     'estado': estado,
  //     'visitantes': visitantes,
  //   };
  // }

  // //fromMap
  // factory RouteEntity.fromMap(Map<String, dynamic> map) {
  //   return RouteEntity(
  //     id: map['id'],
  //     codigo: map['codigo'],
  //     estado: map['estado'],
  //     visitantes: List<String>.from(map['visitantes']),
  //   );
  // }
}

enum RouteStatus {
  esperando,
  iniciado,
  finalizado,
}
