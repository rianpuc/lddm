import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LocationPage(),
    );
  }
}

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  // Variáveis para armazenar a posição e o status
  Position? _currentPosition;
  String _statusMessage = 'Toque no botão para obter a localização.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Exemplo Prático GPS")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Exibe a mensagem de status
              Text(
                _statusMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),

              // Exibe a latitude e longitude se a posição for obtida
              if (_currentPosition != null)
                Text(
                  'Latitude: ${_currentPosition!.latitude}',
                  style: const TextStyle(fontSize: 20),
                ),
              if (_currentPosition != null)
                Text(
                  'Longitude: ${_currentPosition!.longitude}',
                  style: const TextStyle(fontSize: 20),
                ),

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _determinePosition,
                child: const Text('Obter Localização Atual'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Função principal que executa a lógica de geolocalização
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // -----
    // 1. Verificar Serviço de GPS (GPS habilitado?)
    // -----
    setState(() {
      _statusMessage = 'Verificando serviço de localização...';
    });
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Se o serviço estiver desabilitado, atualiza o status e retorna.
      setState(() {
        _statusMessage = 'O serviço de localização (GPS) está desabilitado.';
      });
      return;
    }

    // -----
    // 2. Checar Permissão (Status atual)
    // -----
    setState(() {
      _statusMessage = 'Verificando permissões...';
    });
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      // -----
      // 3. Solicitar Acesso (Se necessário)
      // -----
      setState(() {
        _statusMessage = 'Solicitando permissão de localização...';
      });
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        // Se o usuário negar a permissão, atualiza o status e retorna.
        setState(() {
          _statusMessage = 'A permissão de localização foi negada.';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Se a permissão for negada permanentemente, atualiza o status e retorna.
      // Neste caso, o app não pode mais pedir permissão.
      setState(() {
        _statusMessage =
            'A permissão de localização foi negada permanentemente. Abra as configurações para permitir.';
      });
      return;
    }

    // -----
    // 4. Obter Posição (getCurrentPosition())
    // -----
    // Se as permissões estiverem OK, obtém a posição.
    setState(() {
      _statusMessage = 'Buscando localização...';
    });
    try {
      Position position = await Geolocator.getCurrentPosition();

      // Atualiza o estado com a posição e uma mensagem de sucesso
      setState(() {
        _currentPosition = position;
        _statusMessage = 'Localização obtida com sucesso!';
      });
    } catch (e) {
      // Trata possíveis erros ao obter a localização
      setState(() {
        _statusMessage = 'Erro ao obter localização: ${e.toString()}';
      });
    }
  }
}
