import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/asset_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ITAssetManagerApp());
}

class ITAssetManagerApp extends StatelessWidget {
  const ITAssetManagerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AssetProvider()),
      ],
      child: MaterialApp(
        title: 'Gerenciador de Ativos de TI',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}
