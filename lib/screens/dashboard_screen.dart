import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/asset_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard de Ativos'),
      ),
      body: Consumer<AssetProvider>(
        builder: (context, assetProvider, child) {
          if (assetProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final statusCounts = assetProvider.getAssetStatusCounts();
          final categoryCounts = assetProvider.getAssetCategoryCounts();
          final totalAssets = assetProvider.getTotalAssets();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTotalAssetsCard(totalAssets),
                const SizedBox(height: 16),
                _buildStatusBreakdown(statusCounts),
                const SizedBox(height: 16),
                _buildCategoryBreakdown(categoryCounts),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTotalAssetsCard(int totalAssets) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.blue.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.devices, size: 40, color: Colors.white),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total de Ativos',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$totalAssets',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBreakdown(Map<String, int> statusCounts) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ativos por Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...statusCounts.entries.map(
              (entry) => _buildStatusRow(
                _translateStatus(entry.key),
                entry.value,
                _getColorForStatus(entry.key),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String status, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              '$status: $count',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdown(Map<String, int> categoryCounts) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ativos por Categoria',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...categoryCounts.entries.map(
              (entry) => _buildCategoryRow(
                _translateCategory(entry.key),
                entry.value,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryRow(String category, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.circle, color: Colors.blue, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              '$category: $count',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
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

  Color _getColorForStatus(String status) {
    switch (status.toLowerCase()) {
      case 'in_use':
        return Colors.green;
      case 'inactive':
        return Colors.red;
      case 'maintenance':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
