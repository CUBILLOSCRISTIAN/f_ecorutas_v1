import 'package:f_ecorutas_v1/core/services/service_locator.dart';
import 'package:f_ecorutas_v1/features/gps_permision/presentation/blocs/gps/gps_bloc.dart';
import 'package:f_ecorutas_v1/features/gps_permision/presentation/screen/loading_screen.dart';
import 'package:f_ecorutas_v1/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter binding is initialized

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Initialize Firebase
  setupServiceLocator();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GpsBloc()),
      ],
      child: const MainApp(),
    ),
  );
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
