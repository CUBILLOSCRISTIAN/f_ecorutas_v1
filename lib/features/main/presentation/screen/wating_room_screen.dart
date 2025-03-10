import 'package:f_ecorutas_v1/core/services/service_locator.dart';
import 'package:f_ecorutas_v1/features/main/presentation/blocs/route/route_bloc.dart';
import 'package:f_ecorutas_v1/features/main/presentation/blocs/wating_room/wating_room_bloc.dart';
import 'package:f_ecorutas_v1/features/main/presentation/screen/guide_screen.dart';
import 'package:f_ecorutas_v1/features/main/presentation/screen/main_screen.dart';
import 'package:f_ecorutas_v1/features/main/presentation/screen/participant_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WatingRoomScreen extends StatelessWidget {
  final bool isGuide;
  final String code;

  const WatingRoomScreen({
    super.key,
    required this.isGuide,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WatingRoomBloc(
        firestore: FirebaseFirestore.instance,
      )..add(LoadParticipantsEvent(code)),
      child: _WatingRoomView(isGuide: isGuide, code: code),
    );
  }
}

class _WatingRoomView extends StatelessWidget {
  final bool isGuide;
  final String code;

  const _WatingRoomView({
    required this.isGuide,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    final RouteBloc routeBloc = getIt<RouteBloc>();

    return BlocListener<WatingRoomBloc, WatingRoomState>(
      listener: (context, state) {
        if (state is RouteStartedState) {
          // Redirigir a la nueva pantalla cuando la ruta se inicie

          isGuide
              ? Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => GuideScreen(code: code),
                  ),
                  (route) => false,
                )
              : Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => ParticipantScreen(code: code),
                  ),
                  (route) => false,
                );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('EcoRutas - Sala de espera'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Card con el código de la sala
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Código de la sala',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        code,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Esperando participantes...',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Lista de participantes en tiempo real
              Expanded(
                child: BlocBuilder<WatingRoomBloc, WatingRoomState>(
                  builder: (context, state) {
                    if (state is WatingRoomLoading) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (state is WatingRoomError) {
                      return Center(child: Text(state.message));
                    }

                    if (state is WatingRoomLoaded) {
                      final participants = state.participants;
                      return participants.isEmpty
                          ? Center(
                              child:
                                  Text('Esperando a que se unan participantes'))
                          : ListView.builder(
                              itemCount: participants.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  child: ListTile(
                                    leading:
                                        Icon(Icons.person, color: Colors.blue),
                                    title: Text(participants[index]),
                                  ),
                                );
                              },
                            );
                    }
                    return Center(child: Text('No se encontró la sala'));
                  },
                ),
              ),
            ],
          ),
        ),

        // FloatingActionButton solo para el guía
        floatingActionButton: isGuide
            ? FloatingActionButton(
                onPressed: () {
                  // Lógica para iniciar la ruta
                  routeBloc.add(StartEvent(routeId: code));
                },
                child: Icon(Icons.play_arrow),
              )
            : null,
      ),
    );
  }
}

// Pantalla de ruta en progreso (puedes personalizarla)
class RouteInProgressScreen extends StatelessWidget {
  final String message;
  const RouteInProgressScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ruta en progreso'),
      ),
      body: Center(
        child: Text('La ruta ha comenzado. ¡Buena suerte!, $message'),
      ),
    );
  }
}
