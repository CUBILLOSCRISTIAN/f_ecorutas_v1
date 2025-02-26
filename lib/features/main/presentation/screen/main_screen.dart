import 'package:f_ecorutas_v1/core/services/service_locator.dart';
import 'package:f_ecorutas_v1/features/main/presentation/blocs/role_selection/role_selection_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    // Obtén la instancia del BLoC desde get_it
    final RoleSelectionBloc roleSelectionBloc = getIt<RoleSelectionBloc>();

    return Scaffold(
      appBar: AppBar(title: Text('Selecciona tu rol')),
      body: BlocBuilder<RoleSelectionBloc, RoleSelectionState>(
        bloc: roleSelectionBloc, // Usa el BLoC obtenido de get_it
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                RadioListTile(
                  title: Text('Guía'),
                  value: true,
                  groupValue: state is GuiaSelectedState,
                  onChanged: (value) {
                    if (value != null && value) {
                      roleSelectionBloc.add(SelectGuiaEvent());
                    }
                  },
                ),
                RadioListTile(
                  title: Text('Participante'),
                  value: true,
                  groupValue: state is ParticipantSelectedState,
                  onChanged: (value) {
                    if (value != null && value) {
                      roleSelectionBloc.add(SelectParticipantEvent());
                    }
                  },
                ),
                SizedBox(height: 20),
                if (state is GuiaSelectedState)
                  _guiaSection()
                else if (state is ParticipantSelectedState)
                  _participantSection()
                else
                  Text('Selecciona un rol'),
              ],
            ),
          );
        },
      ),
    );
  }

  Column _guiaSection() {
    return Column(
      children: [
        Text('Has seleccionado el rol de Guía'),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            // Acción al presionar el botón
          },
          child: Text('Crear una ruta'),
        ),
      ],
    );
  }

  Column _participantSection() {
    return Column(
      children: [
        Text('Has seleccionado el rol de Participante'),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            labelText: 'Código de sala',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            // Acción al presionar el botón para unirse
          },
          child: Text('Unirse a la sala'),
        ),
      ],
    );
  }
}
