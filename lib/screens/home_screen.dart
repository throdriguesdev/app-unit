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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 32),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildMenuTile(
                      context,
                      icon: Icons.devices,
                      title: 'Gerenciar Ativos',
                      description: 'Visualize e gerencie seus ativos de TI',
                      screen: const AssetListScreen(),
                    ),
                    const SizedBox(height: 16),
                    _buildMenuTile(
                      context,
                      icon: Icons.dashboard,
                      title: 'Dashboard',
                      description: 'Visualize estatísticas dos seus ativos',
                      screen: const DashboardScreen(),
                    ),
                    const SizedBox(height: 16),
                    _buildMenuTile(
                      context,
                      icon: Icons.file_copy,
                      title: 'Gerenciar Arquivos',
                      description:
                          'Faça upload e gerencie arquivos relacionados',
                      screen: const FileManagementScreen(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gerenciador de Ativos',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Gerencie seus recursos de TI com facilidade',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildMenuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Widget screen,
  }) {
    return OpenContainer(
      closedBuilder: (context, openContainer) => GestureDetector(
        onTap: openContainer,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Icon(
              icon,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
      openBuilder: (context, _) => screen, // Aqui está o parâmetro obrigatório.
      transitionType: ContainerTransitionType.fadeThrough,
    );
  }
}
