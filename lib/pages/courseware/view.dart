import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:otter_study/utils/goktech_assets.dart';
import 'package:otter_study/pages/courseware/index.dart';

class CoursewarePage extends StatefulWidget {
  const CoursewarePage({super.key});

  @override
  State<CoursewarePage> createState() => _coursewareState();
}

class _coursewareState extends State<CoursewarePage> {
  late final player = Player();
  late final controller = VideoController(player);
  late final WebViewController webviewController = WebViewController();
  final _coursewareController = Get.put(CoursewareController());

  @override
  void initState() {
    _coursewareController.fetchCoursewareInfo().then((_) async {
      final addr = Media(_coursewareController.vidAddr.value, httpHeaders: {
        "accept": "application/json, text/plain, */*",
        "accept-language": "zh-CN,zh;q=0.9,en;q=0.8",
        "origin": "https://edu.goktech.cn",
        "referer": "https://edu.goktech.cn",
        'user-agent':
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36",
        'x-appver': "pc:teaching:pc:3.0-1",
        'x-authorization': "",
        'x-tenant': ""
      });
      if (_coursewareController.vidAddr.value != "") {
        player.open(addr);
      }

      if ((Platform.isAndroid || Platform.isIOS) &&
          _coursewareController.size.value < 104857600) {
        webviewController.setJavaScriptMode(JavaScriptMode.unrestricted);
        webviewController.enableZoom(false);
        webviewController.loadRequest(
            Uri.parse(await _coursewareController.fetchTcPreview()));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => _coursewareController.download(),
              icon: Icon(Icons.download_rounded))
        ],
      ),
      body: Obx(() {
        return Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      spacing: 10,
                      children: [
                        Image.asset(
                          extToIcons(_coursewareController.ext.value),
                          height: 32,
                        ),
                        Expanded(
                            child: Text(
                          _coursewareController.name.value,
                          overflow: TextOverflow.ellipsis,
                        ))
                      ],
                    ),
                  )),
              if (MediaQuery.of(context).size.width /
                      MediaQuery.of(context).size.height <=
                  1.2) ...[
                if (_coursewareController.vidKey != "") ...[
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: Video(controller: controller),
                  )
                ],
                if ((Platform.isAndroid || Platform.isIOS) &&
                    _coursewareController.size.value < 104857600) ...[
                  Expanded(
                    child: WebViewWidget(controller: webviewController),
                  ),
                ] else ...[
                  Expanded(
                    child: IntrinsicHeight(
                      child: SizedBox(
                        child: SingleChildScrollView(
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(_coursewareController.name.value),
                                Text(_coursewareController.vidKey != ""
                                    ? _coursewareController.vidAddr.value
                                    : _coursewareController.link.value),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ]
              ] else ...[
                if ((Platform.isAndroid || Platform.isIOS) &&
                    _coursewareController.size.value < 104857600) ...[
                  Expanded(
                    child: WebViewWidget(controller: webviewController),
                  ),
                ] else ...[
                  Expanded(
                      child: IntrinsicHeight(
                    child: IntrinsicWidth(
                        child: Row(
                      children: [
                        if (_coursewareController.vidKey != "") ...[
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Video(controller: controller),
                          ),
                        ],
                        SizedBox(
                          width: MediaQuery.of(context).size.width *
                              (_coursewareController.vidKey != "" ? 0.3 : 1),
                          child: SingleChildScrollView(
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(_coursewareController.name.value),
                                  Text(_coursewareController.vidKey != ""
                                      ? _coursewareController.vidAddr.value
                                      : _coursewareController.link.value),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    )),
                  ))
                ]
              ]
            ]);
      }),
    );
  }
}
