import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
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
                _buildStatusChart(statusCounts),
                const SizedBox(height: 16),
                _buildCategoryChart(categoryCounts),
                const SizedBox(height: 16),
                _buildAdditionalStats(assetProvider),
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

  Widget _buildStatusChart(Map<String, int> statusCounts) {
    final List<PieChartSectionData> sections = statusCounts.entries
        .map(
          (entry) => PieChartSectionData(
        title: '${entry.value}',
        value: entry.value.toDouble(),
        color: _getColorForStatus(entry.key),
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    )
        .toList();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Distribuição por Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(PieChartData(
                sections: sections,
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChart(Map<String, int> categoryCounts) {
    final List<BarChartGroupData> barGroups = categoryCounts.entries
        .toList()
        .asMap()
        .entries
        .map(
          (entry) => BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value.value.toDouble(),
            color: Colors.blueAccent,
            width: 15,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    )
        .toList();
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Distribuição por Categoria',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: barGroups,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toString(),
                            style: const TextStyle(
                                color: Colors.black, fontSize: 12),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          final categories = categoryCounts.keys.toList();
                          if (index < 0 || index >= categories.length) {
                            return const SizedBox.shrink();
                          }
                          return Text(categories[index]);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalStats(AssetProvider assetProvider) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estatísticas Adicionais',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
                'Ativos em Uso: ${assetProvider.getAssetsByStatus("in_use").length}'),
            Text(
                'Ativos Inativos: ${assetProvider.getAssetsByStatus("inactive").length}'),
            Text(
                'Ativos em Manutenção: ${assetProvider.getAssetsByStatus("maintenance").length}'),
          ],
        ),
      ),
    );
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

  String _translateCategory(String category) {
    final translations = {
      'hardware': 'Hardware',
      'software': 'Software',
      'network': 'Rede'
    };
    return translations[category.toLowerCase()] ?? 'Outros';
  }
}
