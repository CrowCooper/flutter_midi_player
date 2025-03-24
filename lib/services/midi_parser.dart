import 'dart:typed_data';

class MidiParser {
  final Uint8List _data;
  int _position = 0;
  late int ticksPerBeat;

  MidiParser(this._data) {
    _parseMidiHeader();
  }

  void _parseMidiHeader() {
    // 检查MIDI文件头
    if (_readString(4) != 'MThd') {
      throw Exception('无效的MIDI文件');
    }

    // 读取头部长度
    final headerLength = _readInt32();
    if (headerLength != 6) {
      throw Exception('无效的MIDI头部长度');
    }

    // 读取格式类型
    final format = _readInt16();
    if (format > 2) {
      throw Exception('不支持的MIDI格式: $format');
    }

    // 读取轨道数
    final numTracks = _readInt16();

    // 读取时间分割
    final division = _readInt16();
    if (division & 0x8000 != 0) {
      throw Exception('不支持SMPTE时间码');
    }
    ticksPerBeat = division;
  }

  String _readString(int length) {
    final bytes = _data.sublist(_position, _position + length);
    _position += length;
    return String.fromCharCodes(bytes);
  }

  int _readInt32() {
    final value = (_data[_position] << 24) |
        (_data[_position + 1] << 16) |
        (_data[_position + 2] << 8) |
        _data[_position + 3];
    _position += 4;
    return value;
  }

  int _readInt16() {
    final value = (_data[_position] << 8) | _data[_position + 1];
    _position += 2;
    return value;
  }
}