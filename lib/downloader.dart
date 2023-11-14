import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class DownloaderUtil {
  Future<File?> downloadAndGetFilePath() async {
    try {
      File? file;
      const String url =
          "https://law-lms-admin.publicdemo.xyz/storage/BlackLetterLaw/bGkX8ji3xVBrKwz7DFu7EU8BkzFNo4ob57nabsF6.pdf";
      final response = await Dio().get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      final filename = url.substring(url.lastIndexOf("/") + 1);
      final bytes = Uint8List.fromList(response.data!);
      final dir = await getExternalStorageDirectory();
      if (dir != null) {
        file = File("${dir.path}/$filename");

        await file.writeAsBytes(bytes, flush: true);
      }

      return file;
    } catch (e) {
      return null;
    }
  }
}
