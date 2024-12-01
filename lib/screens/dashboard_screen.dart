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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.devices, size: 40, color: Colors.blue),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total de Ativos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$totalAssets',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBreakdown(Map<String, int> statusCounts) {
    return Card(
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
            ...statusCounts.entries
                .map((entry) => _buildStatusRow(
                    entry.key, entry.value, _getColorForStatus(entry.key)))
                .toList(),
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
          Text(
            '$status: $count',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdown(Map<String, int> categoryCounts) {
    return Card(
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
            ...categoryCounts.entries
                .map((entry) => _buildCategoryRow(entry.key, entry.value))
                .toList(),
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
          Text(
            '$category: $count',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Color _getColorForStatus(String status) {
    switch (status.toLowerCase()) {
      case 'em uso':
        return Colors.green;
      case 'retired':
        return Colors.red;
      case 'em manutenção':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
