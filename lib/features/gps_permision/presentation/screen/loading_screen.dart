import 'package:f_ecorutas_v1/features/gps_permision/presentation/blocs/gps/gps_bloc.dart';
import 'package:f_ecorutas_v1/features/gps_permision/presentation/screen/gps_access_screen.dart';
import 'package:f_ecorutas_v1/features/main/presentation/screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GpsBloc, GpsState>(
        builder: (context, state) {
          return state.isAllGranted ? MainScreen() : GpsAccessScreen();
        },
      ),
    );
  }
}
