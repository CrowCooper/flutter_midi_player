# Flutter MIDI Player

一个使用Flutter开发的MIDI文件播放器应用。

## 功能特性

- 加载并播放MIDI文件
- 支持选择自定义MIDI文件
- 使用SoundFont进行MIDI音色渲染
- 简洁的用户界面

## 开发环境要求

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0

## 安装和运行

1. 克隆项目
```bash
git clone https://github.com/CrowCooper/flutter_midi_player.git
```

2. 安装依赖
```bash
flutter pub get
```

3. 运行应用
```bash
flutter run
```

## 项目结构

```
lib/
  ├── main.dart              # 应用入口
  ├── screens/               # 界面
  │   └── midi_player_screen.dart
  └── services/              # 服务
      ├── file_service.dart      # 文件处理
      ├── midi_parser.dart       # MIDI解析
      └── midi_player_service.dart # MIDI播放
```

## 使用的主要依赖

- file_picker: 文件选择
- path_provider: 文件路径管理
- flutter_midi: MIDI播放

## 贡献

欢迎提交Issue和Pull Request。

## 许可证

MIT License