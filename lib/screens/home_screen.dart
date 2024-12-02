import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:google_fonts/google_fonts.dart';

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
          style: GoogleFonts.roboto(
            textStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Gerencie seus recursos de TI com facilidade',
          style: GoogleFonts.roboto(
            textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
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
      closedBuilder: (context, openContainer) => Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Icon(
            icon,
            size: 32,
            color: Theme.of(context).primaryColor,
          ),
          title: Text(
            title,
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          subtitle: Text(
            description,
            style: GoogleFonts.roboto(
              color: Colors.grey[600],
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: Colors.grey.shade400,
          ),
          onTap: openContainer,
        ),
      ),
      openBuilder: (context, _) => screen,
      transitionType: ContainerTransitionType.fadeThrough,
    );
  }
}
