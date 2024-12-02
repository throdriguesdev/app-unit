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

  void _showAssetDialog({Asset? asset}) {
    final nameController = TextEditingController(text: asset?.name);
    final descriptionController =
        TextEditingController(text: asset?.description);
    final categoryController = TextEditingController(text: asset?.category);
    final statusController = TextEditingController(text: asset?.status);

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
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Categoria'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: statusController,
                decoration: const InputDecoration(labelText: 'Status'),
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
                category: categoryController.text.trim(),
                status: statusController.text.trim(),
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

          return ListView.builder(
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
                    SnackBar(content: Text('Ativo ${asset.name} removido')),
                  );
                },
                child: ListTile(
                  title: Text(asset.name),
                  subtitle: Text('${asset.category} - ${asset.status}'),
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
                          Provider.of<AssetProvider>(context, listen: false)
                              .removeAsset(asset.id!);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
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
