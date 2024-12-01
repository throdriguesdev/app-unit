import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'asset_list_screen.dart';
import 'file_management_screen.dart';
import 'dashboard_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Text(
              'Gerenciador de Ativos de TI',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Gerencie seus ativos de tecnologia de forma simples e eficiente',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 50),
            _buildMenuCard(
              context,
              icon: Icons.devices,
              title: 'Gerenciar Ativos',
              description: 'Visualize e gerencie seus ativos de TI',
              screen: const AssetListScreen(),
            ),
            const SizedBox(height: 50),
            _buildMenuCard(
              context,
              icon: Icons.dashboard,
              title: 'Dashboard',
              description: 'Visualize estatísticas dos seus ativos',
              screen: const DashboardScreen(), // Add Dashboard screen
            ),
            const SizedBox(height: 20),
            _buildMenuCard(
              context,
              icon: Icons.file_copy,
              title: 'Gerenciar Arquivos',
              description: 'Faça upload e gerencie arquivos relacionados',
              screen: const FileManagementScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Widget screen,
  }) {
    return OpenContainer(
      closedBuilder: (context, openContainer) => Card(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: ListTile(
          leading: Icon(icon,
              size: 40, color: Theme.of(context).colorScheme.primary),
          title: Text(title, style: Theme.of(context).textTheme.titleLarge),
          subtitle: Text(description),
          trailing: const Icon(Icons.chevron_right),
          onTap: openContainer,
        ),
      ),
      openBuilder: (context, _) => screen,
      transitionType: ContainerTransitionType.fadeThrough,
    );
  }
}
