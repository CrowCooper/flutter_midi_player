import 'dart:io';
import 'package:flutter/material.dart';
import 'package:midi_player/services/file_service.dart';
import 'package:midi_player/services/midi_player_service.dart';

class MidiPlayerScreen extends StatefulWidget {
  const MidiPlayerScreen({super.key});

  @override
  State<MidiPlayerScreen> createState() => _MidiPlayerScreenState();
}

class _MidiPlayerScreenState extends State<MidiPlayerScreen> {
  final MidiPlayerService _midiPlayerService = MidiPlayerService();
  final FileService _fileService = FileService();
  bool _isLoading = false;
  String? _errorMessage;
  String? _currentFileName;

  @override
  void initState() {
    super.initState();
    _loadSampleMidiFile();
  }

  Future<void> _loadSampleMidiFile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final filePath = await _fileService.getSampleMidiFile();
      if (filePath != null) {
        await _loadMidiFile(filePath);
      } else {
        setState(() {
          _errorMessage = '无法加载示例MIDI文件';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '加载MIDI文件时出错: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectAndLoadMidiFile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final filePath = await _fileService.getMidiFile();
      if (filePath != null) {
        await _loadMidiFile(filePath);
      }
    } catch (e) {
      setState(() {
        _errorMessage = '选择MIDI文件时出错: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMidiFile(String filePath) async {
    try {
      final filePathCheck = File(filePath);
      if (!await filePathCheck.exists()) {
        setState(() {
          _errorMessage = '文件不存在: $filePath';
        });
        return;
      }

      await _midiPlayerService.loadMidiFile(filePathCheck);
      setState(() {
        _currentFileName = filePath.split('/').last;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = '加载MIDI文件时出错: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MIDI Player'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            if (_currentFileName != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('当前文件: $_currentFileName'),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectAndLoadMidiFile,
              child: const Text('选择MIDI文件'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _midiPlayerService.playMidi(),
              child: const Text('播放'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _midiPlayerService.stopMidi(),
              child: const Text('停止'),
            ),
          ],
        ),
      ),
    );
  }
}