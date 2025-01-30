import 'package:flutter/material.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacidade = 0.0;

  @override
  void initState() {
    super.initState();
    _iniciaAnimacao();
    _navegaParaPrincipal();
  }

  void _iniciaAnimacao() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _opacidade = 1.0; // Aumenta a opacidade para criar o efeito de fade-in
      });
    });
  }

  void _navegaParaPrincipal() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Principal()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor, // Roxinho (padrão)
      body: Center(
        child: AnimatedOpacity(
          duration: const Duration(seconds: 2), // Tempo da animação
          opacity: _opacidade,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.pets,
                  size: 100, color: Colors.white), // Ícone de cachorro
              SizedBox(height: 20),
              Text(
                'Raças de Cachorros',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
