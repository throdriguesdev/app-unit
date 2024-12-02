import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../models/asset.dart';
import '../providers/asset_provider.dart';

class FileManagementScreen extends StatefulWidget {
  const FileManagementScreen({super.key});

  @override
  FileManagementScreenState createState() => FileManagementScreenState();
}

class FileManagementScreenState extends State<FileManagementScreen> {
  List<FileSystemEntity> _files = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    setState(() => _isLoading = true);
    final directory = await getApplicationDocumentsDirectory();
    setState(() {
      _files = directory
          .listSync()
          .where((file) =>
      file.path.endsWith('.csv') ||
          file.path.endsWith('.xlsx') ||
          file.path.endsWith('.pdf'))
          .toList();
      _isLoading = false;
    });
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'xlsx', 'pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      final directory = await getApplicationDocumentsDirectory();
      final newFile =
      await file.copy('${directory.path}/${file.uri.pathSegments.last}');

      // Perform file upload and asset creation
      await _uploadFileAndCreateAssets(newFile);

      _loadFiles();
    }
  }

  Future<void> _uploadFileAndCreateAssets(File file) async {
    try {
      // Read file contents
      String contents = await file.readAsString();

      // Parse CSV manually
      List<List<String>> csvTable = _parseCSV(contents);

      // Validate CSV structure
      if (csvTable.isEmpty || csvTable[0].length < 4) {
        _showErrorSnackBar('Formato de arquivo inválido');
        return;
      }

      // Assuming first row is headers
      List<String> headers = csvTable[0].map((e) => e.toLowerCase()).toList();

      // Validate required columns
      final requiredColumns = ['name', 'description', 'category', 'status'];
      for (var column in requiredColumns) {
        if (!headers.contains(column)) {
          _showErrorSnackBar('Coluna $column não encontrada no arquivo');
          return;
        }
      }

      // Create assets
      List<Asset> assetsToCreate = [];
      for (var row in csvTable.skip(1)) {
        try {
          Asset asset = Asset(
            name: _getValueByHeader(headers, row, 'name'),
            description: _getValueByHeader(headers, row, 'description'),
            category:
            _normalizeCategory(_getValueByHeader(headers, row, 'category')),
            status: _normalizeStatus(_getValueByHeader(headers, row, 'status')),
          );
          assetsToCreate.add(asset);
        } catch (e) {
          print('Erro ao processar linha: $row - $e');
        }
      }

      // Upload to provider
      final assetProvider = Provider.of<AssetProvider>(context, listen: false);
      for (var asset in assetsToCreate) {
        await assetProvider.addAsset(asset);
      }

      // Upload to backend
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://0.0.0.0:8000/upload/'));
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        _showSuccessSnackBar(
            '${assetsToCreate.length} ativos importados com sucesso');
      } else {
        _showErrorSnackBar('Erro ao enviar arquivo para o servidor');
      }
    } catch (e) {
      _showErrorSnackBar('Erro ao processar arquivo: $e');
    }
  }

  // Manual CSV parsing method
  List<List<String>> _parseCSV(String csvString) {
    return csvString
        .split('\n')
        .map((row) => _splitCSVRow(row))
        .where((row) => row.isNotEmpty)
        .toList();
  }

  // Handle CSV row splitting, including quoted fields
  List<String> _splitCSVRow(String row) {
    final result = <String>[];
    final current = StringBuffer();
    bool isInQuotes = false;

    for (int i = 0; i < row.length; i++) {
      if (row[i] == '"') {
        isInQuotes = !isInQuotes;
      } else if (row[i] == ',' && !isInQuotes) {
        result.add(current.toString().trim());
        current.clear();
        continue;
      }

      current.write(row[i]);
    }

    // Add last field
    if (current.isNotEmpty) {
      result.add(current.toString().trim());
    }

    return result;
  }

  String _getValueByHeader(
      List<String> headers, List<String> row, String columnName) {
    int index = headers.indexOf(columnName);
    return index != -1 && index < row.length
        ? row[index].toString().trim()
        : '';
  }

  String _normalizeCategory(String category) {
    category = category.toLowerCase().trim();
    switch (category) {
      case 'hardware':
      case 'h/w':
        return 'hardware';
      case 'software':
      case 's/w':
        return 'software';
      case 'network':
      case 'net':
        return 'network';
      default:
        return 'other';
    }
  }

  String _normalizeStatus(String status) {
    status = status.toLowerCase().trim();
    switch (status) {
      case 'em uso':
      case 'in_use':
        return 'in_use';
      case 'aposentado':
      case 'inactive':
        return 'inactive';
      case 'em manutenção':
      case 'maintenance':
        return 'maintenance';
      default:
        return 'in_use';
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _deleteFile(FileSystemEntity file) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Arquivo'),
        content: const Text('Tem certeza que deseja excluir este arquivo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              file.deleteSync();
              Navigator.of(context).pop();
              _loadFiles();
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciamento de Arquivos'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _files.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.folder_open,
              size: 100,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            Text(
              'Nenhum arquivo encontrado',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: _files.length,
        itemBuilder: (context, index) {
          final file = _files[index];
          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            child: ListTile(
              leading: Icon(
                _getIconForFileType(file.path),
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                file.uri.pathSegments.last,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteFile(file),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickFile,
        child: const Icon(Icons.add),
      ),
    );
  }

  IconData _getIconForFileType(String path) {
    if (path.endsWith('.csv')) return Icons.table_chart;
    if (path.endsWith('.xlsx')) return Icons.table_rows;
    if (path.endsWith('.pdf')) return Icons.picture_as_pdf;
    return Icons.insert_drive_file;
  }
}
