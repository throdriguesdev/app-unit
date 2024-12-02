import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/asset.dart';

class AssetService {
  static const String baseUrl = 'http://192.168.10.142:8000/assets';

  Future<List<Asset>> fetchAssets() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        return body.map((dynamic item) => Asset.fromJson(item)).toList();
      } else {
        throw Exception('Falha ao carregar ativos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  Future<Asset> createAsset(Asset asset) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(asset.toJson()),
      );

      if (response.statusCode == 200) {
        return Asset.fromJson(json.decode(response.body));
      } else {
        throw Exception('Falha ao criar ativo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  Future<void> deleteAsset(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode != 200) {
        throw Exception('Falha ao deletar ativo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  Future<Asset> updateAsset(Asset asset) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${asset.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(asset.toJson()),
      );

      if (response.statusCode == 200) {
        return Asset.fromJson(json.decode(response.body));
      } else {
        throw Exception('Falha ao atualizar ativo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}
