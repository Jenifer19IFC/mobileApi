import 'package:flutter/material.dart';
import 'AbaPessoas.dart';
import 'AbaCachorros.dart';
import 'SplashScreen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Raças de Cachorros',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(), // Inicial
    );
  }
}

class Principal extends StatelessWidget {
  const Principal({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Duas abas
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gerenciador'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Raças', icon: Icon(Icons.pets)),
              Tab(text: 'Pessoas', icon: Icon(Icons.people)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AbaCachorros(), // Tela de raças de cachorros
            AbaPessoas(), // Tela de vínculos
          ],
        ),
      ),
    );
  }
}
