# 📂 srt to fcxml Convertor

这是一个将srt文件转换为支持导入到Final cut pro的Fcpxml文件的工具🎬。<br>
This is a tool that converts SRT files into Fcpxml files that can be imported into Final Cut Pro.

<img src="https://github.com/EXCharlie/fcp_srt2xml/blob/main/pics/Screenshot01.png?raw=true" height="400">

## 🌟 特点
- 使用Flutter框架，具有图化界面🖥️。
- 支持导入自定义的Fcpxml文件📄。

## 📝 说明
虽然是使用dart编写，但参考了其他的repo是如何将srt写入xml的。

其中有趣的是，花了我一个小时调试，“duration="25100/5000s””不等于（尽管只差了一个空格）“duration="25100/5000 s””🤔。

## 🛠️ 使用方法
-  [app for MacOS](https://github.com/EXCharlie/fcp_srt2xml/tree/main/release)
- （required）**SRT file** 📁
- （required）**视频帧率** 🎥
- （required）**输出文件夹** 📂
- （optional）**Fcpxml module** 🧩

## 📥 导入自定义的Fcpxml文件的使用方法
**注意**：只支持简单的titles文字（只包含单个Text和text-style-def的简单的titles），因为原理就是读取Fcpxml文件的effect和text-style的element。

<img src="https://github.com/EXCharlie/fcp_srt2xml/blob/main/pics/Screenshot02.jpg?raw=true" height="300">

1. 将只包含单个 简单的titles 的时间线Export XML…（即.fcpxml格式）。
2. 然后读取即可。

## 🚀 Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
