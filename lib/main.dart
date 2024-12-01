import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/asset_provider.dart';
import 'screens/asset_list_screen.dart';

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
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const AssetListScreen(),
      ),
    );
  }
}
