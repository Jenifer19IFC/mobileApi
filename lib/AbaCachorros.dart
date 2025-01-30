import 'package:flutter/material.dart';
import 'DogService.dart';
import 'RacaDetalhe.dart';

class AbaCachorros extends StatefulWidget {
  const AbaCachorros({super.key});

  @override
  _AbaCachorrosState createState() => _AbaCachorrosState();
}

class _AbaCachorrosState extends State<AbaCachorros> {
  List<dynamic> racas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    buscaRacas();
  }

  Future<void> buscaRacas() async {
    try {
      final dogService = DogService();
      final listaRacas = await dogService.buscaRacas();
      setState(() {
        racas = listaRacas;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      throw Exception('Erro ao buscar raças: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: racas.length,
              itemBuilder: (context, index) {
                final raca = racas[index];
                return ListTile(
                  title: Text(raca['name']),
                  subtitle: Text(raca['origin'] ?? 'Desconhecida'),
                  leading: raca['image'] != null
                      ? Image.network(
                          raca['image']['url'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.pets),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RacaDetalhe(raca: raca),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
