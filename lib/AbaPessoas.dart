import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AbaPessoas extends StatefulWidget {
  const AbaPessoas({super.key});

  @override
  _AbaPessoasState createState() => _AbaPessoasState();
}

class _AbaPessoasState extends State<AbaPessoas> {
  List<dynamic> vinculos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    buscaVinculos();
  }

  Future<void> buscaVinculos() async {
    try {
      final resposta =
          await http.get(Uri.parse('http://127.0.0.1:5000/listar_vinculos'));
      if (resposta.statusCode == 200) {
        final vinculosList = json.decode(resposta.body);
        setState(() {
          vinculos = vinculosList;
          isLoading = false;
        });
      } else {
        throw Exception('Erro ao carregar vínculos');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      throw Exception('Erro: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: vinculos.length,
              itemBuilder: (context, index) {
                final vinculo = vinculos[index];
                return ListTile(
                  title: Text(vinculo['pessoa']),
                  subtitle: Text(vinculo['cachorro']),
                );
              },
            ),
    );
  }
}
