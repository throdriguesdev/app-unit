import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class FileManagementScreen extends StatefulWidget {
  const FileManagementScreen({Key? key}) : super(key: key);

  @override
  _FileManagementScreenState createState() => _FileManagementScreenState();
}

class _FileManagementScreenState extends State<FileManagementScreen> {
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

      // Aqui você pode adicionar a lógica de upload para o backend
      await _uploadFileToServer(newFile);

      _loadFiles();
    }
  }

  Future<void> _uploadFileToServer(File file) async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://0.0.0.0:8000/upload/'));
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Arquivo enviado com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao enviar arquivo')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    }
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
