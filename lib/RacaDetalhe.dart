import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RacaDetalhe extends StatelessWidget {
  final Map<String, dynamic> raca;

  const RacaDetalhe({super.key, required this.raca});

  Future<List<Map<String, dynamic>>> _buscaPessoas() async {
    final url = Uri.parse('http://127.0.0.1:5000/pessoas');
    final resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      final List<dynamic> dadosPessoa = jsonDecode(resposta.body);
      return dadosPessoa
          .map((persona) => {"id": persona["id"], "name": persona["nome"]})
          .toList();
    } else {
      throw Exception('Erro ao buscar pessoas');
    }
  }

  Future<void> _selecaoPessoas(BuildContext context) async {
    List<Map<String, dynamic>> pessoa;

    try {
      pessoa = await _buscaPessoas();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar pessoas')),
      );
      return;
    }

    String nomeRaca = raca['name'];
    int idDog = raca['id'];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Vincular $nomeRaca a uma pessoa'),
          content: pessoa.isEmpty
              ? const Text('Nenhuma pessoa disponível.')
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: pessoa.map((persona) {
                    return ListTile(
                      title: Text(persona['name']),
                      onTap: () async {
                        Navigator.of(context).pop();
                        await _vinculaDog(
                            context, persona['id'], nomeRaca, idDog);
                      },
                    );
                  }).toList(),
                ),
        );
      },
    );
  }

  Future<void> _vinculaDog(
      BuildContext context, int personaId, String nomeRaca, int idDog) async {
    final url = Uri.parse('http://127.0.0.1:5000/vincular');
    try {
      final resposta = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {"id_pessoa": personaId, "id_cachorro": idDog, "raca": nomeRaca}),
      );

      if (resposta.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('$nomeRaca vinculado com sucesso à pessoa ID: $personaId'),
          ),
        );
      } else {
        final erroDado = jsonDecode(resposta.body);
        final erroMsg = erroDado['erro'] ?? 'Falha ao vincular cachorro';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(erroMsg)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao conectar à API: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String? idImagem = raca['reference_image_id'];
    String? imagemUrl = idImagem != null
        ? "https://cdn2.thedogapi.com/images/$idImagem.jpg"
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(raca['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Raça: ${raca['name']}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Origem: ${raca['origin'] ?? 'Desconhecida'}',
                style: const TextStyle(fontSize: 16)),
            Text('Vida Útil: ${raca['life_span'] ?? 'Desconhecido'}',
                style: const TextStyle(fontSize: 16)),
            Text('Temperamento: ${raca['temperament'] ?? 'Desconhecido'}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            if (imagemUrl != null)
              Image.network(
                imagemUrl,
                height: 200,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _selecaoPessoas(context),
              child: const Text('Vincular'),
            ),
          ],
        ),
      ),
    );
  }
}
