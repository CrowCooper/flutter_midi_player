import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:midi_player/services/midi_parser.dart';

class MidiPlayerService extends ChangeNotifier {
  final FlutterMidi _flutterMidi = FlutterMidi();
  File? _midiFile;
  int? _ticksPerBeat;
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  Future<void> loadMidiFile(File file) async {
    try {
      _midiFile = file;
      final midiData = await file.readAsBytes();
      final midiParser = MidiParser(midiData);
      _ticksPerBeat = midiParser.ticksPerBeat;
      notifyListeners();
      debugPrint('MIDI文件加载成功');
    } catch (e) {
      debugPrint('加载MIDI文件时出错: $e');
      rethrow;
    }
  }

  Future<void> loadSoundFont(File file) async {
    try {
      await _flutterMidi.prepare(sf2Path: file.path);
      debugPrint('音色库加载成功');
    } catch (e) {
      debugPrint('加载音色库时出错: $e');
      rethrow;
    }
  }

  void playMidi() {
    if (_midiFile == null) {
      debugPrint('没有加载MIDI文件');
      return;
    }

    _isPlaying = true;
    notifyListeners();
    debugPrint('开始播放MIDI');
  }

  void stopMidi() {
    _isPlaying = false;
    notifyListeners();
    debugPrint('停止播放MIDI');
  }

  void _playNote(int note, int velocity, int channel) {
    try {
      _flutterMidi.playMidiNote(note: note);
      debugPrint('播放音符: note=$note, velocity=$velocity, channel=$channel');
    } catch (e) {
      debugPrint('播放音符时出错: $e');
    }
  }
}