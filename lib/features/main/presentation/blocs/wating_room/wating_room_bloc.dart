import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'wating_room_event.dart';
part 'wating_room_state.dart';

class WatingRoomBloc extends Bloc<WatingRoomEvent, WatingRoomState> {
  final FirebaseFirestore firestore;
  StreamSubscription? _subscription;

  WatingRoomBloc({required this.firestore}) : super(WatingRoomInitial()) {
    on<LoadParticipantsEvent>(_onLoadParticipants);
    on<LoadParticipantsSuccess>(_onLoadParticipantsSuccess);
    on<InitialRouteEvent>(_onInitialRoute);
    // on<LoadParticipantsError>(_onLoadParticipantsError);
  }

  Future<void> _onLoadParticipants(
    LoadParticipantsEvent event,
    Emitter<WatingRoomState> emit,
  ) async {
    emit(WatingRoomLoading());

    _subscription?.cancel(); // Cancelar la suscripción anterior si existe

    final roomRef = firestore.collection('rutas').doc(event.code);

    _subscription = roomRef.snapshots().listen((snapshot) {
      if (!snapshot.exists) {
        add(LoadParticipantsError('No se encontró la sala'));
        return;
      }

      final data = snapshot.data() ?? {};

      // Verificar si la ruta ha sido iniciada
      if (data['status'] == 'iniciado') {
        add(InitialRouteEvent());
        return;
      }

      final participants = List<Map<String, dynamic>>.from(
        data['participantes'] ?? [],
      ).map((participant) => participant['nombre'] as String).toList();

      add(LoadParticipantsSuccess(participants));
    }, onError: (error) {
      add(LoadParticipantsError('Error al cargar los participantes: $error'));
    });
  }

  void _onLoadParticipantsSuccess(
    LoadParticipantsSuccess event,
    Emitter<WatingRoomState> emit,
  ) {
    emit(WatingRoomLoaded(event.participants));
  }

  void _onInitialRoute(
    InitialRouteEvent event,
    Emitter<WatingRoomState> emit,
  ) {
    emit(RouteStartedState());
  }

  @override
  Future<void> close() {
    _subscription?.cancel(); // Cancelar la suscripción cuando el BLoC se cierre
    return super.close();
  }
}
