import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text('EcoRutas')),
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Código: $code, Esperando a que se unan los participantes...',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
      ),
      floatingActionButton: isGuide ? _buildStartButton() : null,
    );
  }

  FloatingActionButton _buildStartButton() {
    return FloatingActionButton(
      onPressed: () {},
      child: Icon(Icons.play_arrow),
    );
  }
}
