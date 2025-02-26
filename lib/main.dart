import 'package:f_ecorutas_v1/features/gps_permision/presentation/blocs/gps/gps_bloc.dart';
import 'package:f_ecorutas_v1/features/gps_permision/presentation/screen/gps_access_screen.dart';
import 'package:f_ecorutas_v1/features/gps_permision/presentation/screen/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => GpsBloc()),
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoadingScreen(),
    );
  }
}
