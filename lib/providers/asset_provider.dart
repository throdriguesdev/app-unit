import 'package:flutter/foundation.dart';
import '../models/asset.dart';
import '../services/asset_service.dart';

class AssetProvider with ChangeNotifier {
  List<Asset> _assets = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Asset> get assets => _assets;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchAssets() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _assets = await AssetService().fetchAssets();
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  Future<void> addAsset(Asset asset) async {
    try {
      final newAsset = await AssetService().createAsset(asset);
      _assets.add(newAsset);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Erro ao adicionar ativo: $e';
      notifyListeners();
    }
  }

  Future<void> updateAsset(Asset asset) async {
    try {
      final updatedAsset = await AssetService().updateAsset(asset);
      final index = _assets.indexWhere((a) => a.id == updatedAsset.id);
      if (index != -1) {
        _assets[index] = updatedAsset;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Erro ao atualizar ativo: $e';
      notifyListeners();
    }
  }

  Future<void> removeAsset(int id) async {
    try {
      await AssetService().deleteAsset(id);
      _assets.removeWhere((asset) => asset.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Erro ao remover ativo: $e';
      notifyListeners();
    }
  }
}
