import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/asset.dart';
import '../providers/asset_provider.dart';

class AssetListScreen extends StatefulWidget {
  const AssetListScreen({Key? key}) : super(key: key);

  @override
  _AssetListScreenState createState() => _AssetListScreenState();
}

class _AssetListScreenState extends State<AssetListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AssetProvider>(context, listen: false).fetchAssets();
    });
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'hardware':
        return Icons.computer;
      case 'software':
        return Icons.folder;
      case 'network':
        return Icons.network_wifi;
      default:
        return Icons.device_unknown;
    }
  }

  String _translateStatus(String status) {
    final Map<String, String> translations = {
      'in_use': 'Em Uso',
      'inactive': 'Aposentado',
      'maintenance': 'Em Manutenção',
    };
    return translations[status.toLowerCase()] ?? 'Desconhecido';
  }

  String _translateCategory(String category) {
    final Map<String, String> translations = {
      'hardware': 'Hardware',
      'software': 'Software',
      'network': 'Rede',
    };
    return translations[category.toLowerCase()] ?? 'Outros';
  }

  void _showAssetDialog({Asset? asset}) {
    final nameController = TextEditingController(text: asset?.name);
    final descriptionController =
    TextEditingController(text: asset?.description);
    String category = asset?.category ?? 'hardware';
    String status = asset?.status ?? 'in_use';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(asset == null ? 'Adicionar Novo Ativo' : 'Editar Ativo'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                maxLines: 2,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: category,
                onChanged: (value) => setState(() => category = value!),
                decoration: const InputDecoration(labelText: 'Categoria'),
                items: const [
                  DropdownMenuItem(value: 'hardware', child: Text('Hardware')),
                  DropdownMenuItem(value: 'software', child: Text('Software')),
                  DropdownMenuItem(value: 'network', child: Text('Rede')),
                ],
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: status,
                onChanged: (value) => setState(() => status = value!),
                decoration: const InputDecoration(labelText: 'Status'),
                items: const [
                  DropdownMenuItem(value: 'in_use', child: Text('Em Uso')),
                  DropdownMenuItem(
                      value: 'inactive', child: Text('Aposentado')),
                  DropdownMenuItem(
                      value: 'maintenance', child: Text('Em Manutenção')),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final newAsset = Asset(
                id: asset?.id,
                name: nameController.text.trim(),
                description: descriptionController.text.trim(),
                category: category,
                status: status,
              );

              if (asset == null) {
                Provider.of<AssetProvider>(context, listen: false)
                    .addAsset(newAsset);
              } else {
                Provider.of<AssetProvider>(context, listen: false)
                    .updateAsset(newAsset);
              }
              Navigator.of(context).pop();
            },
            child: Text(asset == null ? 'Adicionar' : 'Atualizar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ativos de TI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => Provider.of<AssetProvider>(context, listen: false)
                .fetchAssets(),
          )
        ],
      ),
      body: Consumer<AssetProvider>(
        builder: (context, assetProvider, child) {
          if (assetProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (assetProvider.errorMessage.isNotEmpty) {
            return Center(
              child: Text(
                'Erro: ${assetProvider.errorMessage}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (assetProvider.assets.isEmpty) {
            return const Center(
              child: Text('Nenhum ativo encontrado.',
                  style: TextStyle(fontSize: 16)),
            );
          }

          return Column(
            children: [
              Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total de Ativos',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${assetProvider.assets.length}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: assetProvider.assets.length,
                  itemBuilder: (context, index) {
                    final asset = assetProvider.assets[index];
                    return Dismissible(
                      key: ValueKey(asset.id ?? index),
                      background: Container(color: Colors.red),
                      onDismissed: (_) {
                        Provider.of<AssetProvider>(context, listen: false)
                            .removeAsset(asset.id!);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Ativo ${asset.name} removido')),
                        );
                      },
                      child: ListTile(
                        leading: Icon(
                          _getCategoryIcon(asset.category),
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text(asset.name),
                        subtitle: Text(
                            '${_translateCategory(asset.category)} - ${_translateStatus(asset.status)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showAssetDialog(asset: asset),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                Provider.of<AssetProvider>(context,
                                    listen: false)
                                    .removeAsset(asset.id!);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAssetDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
