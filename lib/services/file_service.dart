import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class FileService {
  Future<String?> getMidiFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mid', 'midi'],
      );

      if (result != null) {
        return result.files.single.path;
      }
      return null;
    } catch (e) {
      print('选择MIDI文件时出错: $e');
      return null;
    }
  }

  Future<String?> getSampleMidiFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = path.join(directory.path, 'sample.mid');
      final file = File(filePath);

      if (!await file.exists()) {
        // 创建一个空的MIDI文件作为示例
        await file.writeAsBytes([]);
      }

      return filePath;
    } catch (e) {
      print('获取示例MIDI文件时出错: $e');
      return null;
    }
  }
}