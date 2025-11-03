import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Sensores Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SensorPage(),
    );
  }
}

class SensorPage extends StatefulWidget {
  const SensorPage({super.key});

  @override
  State<SensorPage> createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  // Variáveis para guardar os dados do acelerômetro
  double _accelX = 0, _accelY = 0, _accelZ = 0;

  // StreamSubscription para poder "cancelar" a audição do sensor
  StreamSubscription? _accelerometerSubscription;

  @override
  void initState() {
    super.initState();
    // Começa a "ouvir" o stream do acelerômetro
    _accelerometerSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      // Atualiza o estado da UI com os novos valores
      setState(() {
        // Arredondando para 2 casas decimais para melhor visualização
        _accelX = double.parse(event.x.toStringAsFixed(2));
        _accelY = double.parse(event.y.toStringAsFixed(2));
        _accelZ = double.parse(event.z.toStringAsFixed(2));
      });
    });
  }

  @override
  void dispose() {
    // É MUITO IMPORTANTE cancelar a inscrição (subscription)
    // quando o widget for destruído para evitar vazamento de memória.
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exemplo Acelerômetro'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Valores do Acelerômetro:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Text(
              'Eixo X: $_accelX',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              'Eixo Y: $_accelY',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              'Eixo Z: $_accelZ',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
