import 'dart:math';

import 'package:f_ecorutas_v1/core/services/service_locator.dart';
import 'package:f_ecorutas_v1/features/main/domain/entity/route.dart';
import 'package:f_ecorutas_v1/features/main/presentation/blocs/role_selection/role_selection_bloc.dart';
import 'package:f_ecorutas_v1/features/main/presentation/blocs/route/route_bloc.dart';
import 'package:f_ecorutas_v1/features/main/presentation/screen/wating_room_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Obtén las instancias de los BLoCs desde get_it
    final RoleSelectionBloc roleSelectionBloc = getIt<RoleSelectionBloc>();
    final RouteBloc routeBloc = getIt<RouteBloc>();

    return Scaffold(
      appBar: AppBar(title: Text('EcoRutas')),
      body: BlocBuilder<RoleSelectionBloc, RoleSelectionState>(
        bloc: roleSelectionBloc,
        builder: (context, roleState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildRoleSelection(roleSelectionBloc, roleState),
                SizedBox(height: 20),
                if (roleState is GuiaSelectedState)
                  _guiaSection(routeBloc)
                else if (roleState is ParticipantSelectedState)
                  _participantSection(routeBloc)
                else
                  Text('Selecciona un rol'),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRoleSelection(RoleSelectionBloc bloc, RoleSelectionState state) {
    return Column(
      children: [
        RadioListTile(
          title: Text('Guía'),
          value: true,
          groupValue: state is GuiaSelectedState,
          onChanged: (value) {
            if (value != null && value) {
              bloc.add(SelectGuiaEvent());
            }
          },
        ),
        RadioListTile(
          title: Text('Participante'),
          value: true,
          groupValue: state is ParticipantSelectedState,
          onChanged: (value) {
            if (value != null && value) {
              bloc.add(SelectParticipantEvent());
            }
          },
        ),
      ],
    );
  }

  Widget _guiaSection(RouteBloc bloc) {
    return BlocConsumer<RouteBloc, RouteState>(
      bloc: bloc,
      listener: (context, state) {
        print('State: $state');
        if (state is OperationSuccessState) {
          // Navegar a otra pantalla cuando la operación es exitosa
          //TODO CAMBIAR ESTO POR UNA SERVICIO DE NAVEGACION GLOBAL
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => WatingRoomScreen(
                isGuide: true,
                code: state.code,
              ),
            ),
          );
        } else if (state is RouteErrorState) {
          // Mostrar un SnackBar con el mensaje de error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is RouteLoadingState) {
          return Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            Text('Has seleccionado el rol de Guía'),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {});
                // Funcion de generar codigo
                var code = _generateCode();
                debugPrint('Código generado: $code');
                // Acción al presionar el botón
                bloc.add(
                  CreateEvent(
                    route: RouteEntity(
                      id: code,
                      code: code,
                    ),
                  ),
                );
              },
              child: Text('Crear una ruta'),
            ),
          ],
        );
      },
    );
  }

  Widget _participantSection(RouteBloc bloc) {
    return BlocConsumer<RouteBloc, RouteState>(
      bloc: bloc,
      listener: (context, state) {
        if (state is OperationSuccessState) {
          // Navegar a otra pantalla cuando la operación es exitosa
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => WatingRoomScreen(
                isGuide: false,
                code: state.code,
              ),
            ),
          );
        } else if (state is RouteErrorState) {
          // Mostrar un SnackBar con el mensaje de error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is RouteLoadingState) {
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.red,
          ));
        }
        return Column(
          children: [
            Text('Has seleccionado el rol de Participante'),
            SizedBox(height: 10),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: 'Código de sala',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _codeController.text.isEmpty
                  ? null
                  : () async {
                      final userName = await _showNameDialog(context);
                      if (userName != null && userName.isNotEmpty) {
                        // Enviar el evento JoinEvent con el código y el nombre del usuario
                        bloc.add(
                          JoinEvent(
                            code: _codeController.text,
                            userName: userName,
                          ),
                        );
                      }
                    },
              child: Text('Unirse a la sala'),
            ),
          ],
        );
      },
    );
  }

  String _generateCode() {
    final random = Random();
    final code = 'EC${random.nextInt(9000) + 1000}';
    return code;
  }
}

// Método para mostrar el diálogo de nombre
Future<String?> _showNameDialog(BuildContext context) async {
  String? userName;
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Ingresa tu nombre'),
        content: TextField(
          onChanged: (value) {
            userName = value;
          },
          decoration: InputDecoration(
            hintText: 'Nombre',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Aceptar'),
          ),
        ],
      );
    },
  );
  return userName;
}

// Pantalla de éxito (puedes personalizarla)
class SuccessScreen extends StatelessWidget {
  final String message;

  const SuccessScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Éxito')),
      body: Center(
        child: Text(message),
      ),
    );
  }
}
