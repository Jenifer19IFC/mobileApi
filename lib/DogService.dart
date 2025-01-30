import 'dart:convert';
import "package:http/http.dart" as http;

// OK

class DogService {
  static const String _baseUrl = 'https://api.thedogapi.com/v1/breeds';

  Future<List<dynamic>> buscaRacas() async {
    try {
      final resposta = await http.get(Uri.parse(_baseUrl));
      if (resposta.statusCode == 200) {
        return json.decode(resposta.body);
      } else {
        throw Exception('Falha ao carregar raças de cachorros.');
      }
    } catch (error) {
      throw Exception('Erro ao buscar raças: $error');
    }
  }
}
