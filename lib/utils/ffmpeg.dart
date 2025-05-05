import 'dart:developer';
import 'dart:io';

import 'package:downloadsfolder/downloadsfolder.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/session_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:otter_study/utils/permission/storage.dart';

var ffmpeg_logs = "";

const List<String> gokVidHeaders = [
  "Host: vod.goktech.cn",
  "Accept: */*",
  "Origin: https://edu.goktech.cn",
  "Referer: https://edu.goktech.cn/",
  "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36"
];

Future m3u8VideoExport(String target,
    {required String filename, location = ""}) async {
  if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
    String pathDivider = Platform.isWindows ? r"\" : r"/";
    if (Platform.isAndroid) {
      await storagePermissionCheck();
    }
    var saveLocation =
        "${(await getDownloadDirectory()).path}$pathDivider$filename";
    if (location.isNotEmpty) {
      saveLocation = location;
    }
    final command =
        "-y -user_agent 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36' -referer 'https://edu.goktech.cn/' -i $target -c copy -f mp4 $saveLocation -v trace";

    final GlobalKey _loadingKey = GlobalKey();
    SmartDialog.showLoading(
        builder: (_) => _FFmpegProcessLoading(key: _loadingKey));
    var session = await FFmpegKit.executeAsync(command, (e) async {
      var state = await e.getState();
      if (state == SessionState.completed) {
        SmartDialog.showToast("文件已保存至 $saveLocation");
        ffmpeg_logs = "";
        SmartDialog.dismiss(status: SmartStatus.loading);
      } else if (state == SessionState.failed) {
        SmartDialog.showToast("处理失败，请查询日志");
      }
    }, (e) {
      ffmpeg_logs = "${e.getMessage()}";
      _loadingKey.currentState!.setState(() {});
    }, null);
  } else {
    SmartDialog.showToast("下载组件不支持该平台:${Platform.operatingSystem}");
    return;
  }
  return;
}

class _FFmpegProcessLoading extends StatefulWidget {
  const _FFmpegProcessLoading({super.key});

  @override
  State<_FFmpegProcessLoading> createState() => _FFmpegProcessLoadingState();
}

class _FFmpegProcessLoadingState extends State<_FFmpegProcessLoading> {
  static final GlobalKey<_FFmpegProcessLoadingState> key = GlobalKey();

  reloadData() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text("处理中……"),
        contentPadding: EdgeInsets.symmetric(vertical: 30),
        content: Container(
            width: double.maxFinite,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: SingleChildScrollView(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 15,
                  children: [
                    LinearProgressIndicator(),
                    Text(
                      ffmpeg_logs,
                      style: const TextStyle(
                          fontSize: 14,
                          fontFamily: "Ubuntu Mono",
                          fontFamilyFallback: ["MiSans", "Twemoji"]),
                    )
                  ],
                )))));
  }
}
