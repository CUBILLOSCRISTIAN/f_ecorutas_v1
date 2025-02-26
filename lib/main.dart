import 'package:f_ecorutas_v1/feature/gps_permision/presentation/screen/gps_access_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: GpsAccessScreen(),
    );
  }
}
