import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

/// 文件操作类
class FileUtil {
  /// RenderRepaintBoundary 内容转换为 Uint8List 数据
  static Future<Uint8List> capturePng2List(
      RenderRepaintBoundary boundary) async {
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    return pngBytes;
  }

  /// 图片路径转 Uint8List 数据
  static Future<Uint8List> captureImagePath2List(String imgFilePath) async {
    File imgFile = File(imgFilePath);
    return Uint8List.fromList(await imgFile.readAsBytes());
  }

  static void deleteFile(String filePath) {
    File file = File(filePath);
    if (file.existsSync()) {
      file.delete();
    }
  }

  /// 图片路径转 Uint8List 数据
  static Future<Uint8List> captureImage2List(File imgFile) async {
    return Uint8List.fromList(await imgFile.readAsBytes());
  }

  /// 压缩图片，返回存储的临时路径
  static Future<File> compressWithList(
    Uint8List imageData, {
    int minWidth = 1920,
    int minHeight = 1080,
    int quality = 95,
    int rotate = 0,
  }) async {
    //通过图片压缩插件进行图片压缩
    var result = await FlutterImageCompress.compressWithList(
      imageData,
      quality: quality,
      minHeight: minHeight,
      minWidth: minWidth,
      rotate: rotate,
    );
    return await saveImg(result);
  }

  static Future<File> saveImg(List<int> bytes,
      [String fileDir = 'compress']) async {
    // 获得应用临时目录路径 getTemporaryDirectory()
    // 获取应用的文档目录 getApplicationDocumentsDirectory();
    final Directory _directory = await getApplicationDocumentsDirectory();
    final Directory _imageDirectory =
        await Directory('${_directory.path}/$fileDir/').create(recursive: true);
    //将图片暂时存入应用缓存目录
    return File(
        '${_imageDirectory.path}${DateTime.now().millisecondsSinceEpoch}.jpg')
      ..writeAsBytesSync(bytes);
  }

  /// 压缩图片，返回存储的临时路径
  static Future<File> compressWithFile(
    String imageFilePath, {
    int minWidth = 1920,
    int minHeight = 1080,
    int quality = 95,
    int rotate = 0,
  }) async {
    //通过图片压缩插件进行图片压缩
    var result = await FlutterImageCompress.compressWithFile(
      imageFilePath,
      quality: quality,
      minHeight: minHeight,
      minWidth: minWidth,
      rotate: rotate,
    );
    return await saveImg(result);
  }
}
