import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otter_study/http/index.dart';
import 'package:otter_study/utils/goktech_assets.dart';
import 'package:otter_study/utils/uri_handler.dart';

import './index.dart';

class HomeWorkView extends StatefulWidget {
  const HomeWorkView({super.key});

  @override
  State<HomeWorkView> createState() => _homeworkState();
}

class _homeworkState extends State<HomeWorkView> {
  @override
  Widget build(BuildContext context) {
    final _homeworkController = Get.put(HomeworkController());
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text("作业"), const SizedBox(width: 10), HomeworkStatus()],
        ),
      ),
      body: FutureBuilder(
          future: _homeworkController.fetchHomeworkData(),
          builder: (ctx, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("出错"),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return Obx(() => CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          spacing: 20,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/icons/activity/icon-homework.png",
                                          height: 25,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                            child: Text(
                                          _homeworkController.data['name']
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ))
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    // homeworkDocListResList
                                    // stuHomeworkDocListResList
                                    // allowRepeat //未知意义
                                    // rank
                                    Text(
                                      "发布时间: ${DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(int.parse(_homeworkController.data['publishTime'] ?? "0")))} | "
                                      "${_homeworkController.data['partNum']}/${_homeworkController.data['studentNum']}人参与 | "
                                      "${_homeworkController.data['score']}/${_homeworkController.data['homeworkScore']}分",
                                      style: const TextStyle(
                                          fontSize: 13, color: Colors.grey),
                                    ),
                                    Text(
                                      "截止时间: ${DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(int.parse(_homeworkController.data['deadline'].toString() != "null" ? _homeworkController.data['deadline'].toString() : "0")))}",
                                      style: const TextStyle(
                                          fontSize: 13, color: Colors.grey),
                                    ),
                                    const SizedBox(height: 10),
                                    Card(
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 109, 185, 255),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        padding: EdgeInsets.all(10),
                                        child: Text(_homeworkController
                                            .data['introduction']
                                            .toString()),
                                      ),
                                    ),
                                    Card(
                                      child: Column(
                                        children: _homeworkController
                                            .homeworkDocResList
                                            .map((e) => ListTile(
                                                  leading: Image.asset(
                                                    extToIcons(e['type']),
                                                    height: 26,
                                                  ),
                                                  title: Text(
                                                    e['docName'],
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  onTap: () async {
                                                    var url = (await Request().get(
                                                            Api.fetchDocPreview +
                                                                e['docId']))
                                                        .data['pathKey'];
                                                    UriHandler(url);
                                                  },
                                                  trailing: IconButton(
                                                      onPressed: () async {
                                                        await Request()
                                                            .download(
                                                                e['imgUrl'],
                                                                e['docName']);
                                                      },
                                                      icon: Icon(Icons
                                                          .download_rounded)),
                                                ))
                                            .toList(),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Container(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "我的作业",
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(width: 10),
                                          HomeworkStatus()
                                        ],
                                      ),
                                      if (_homeworkController
                                              .data['submitStatus'] ==
                                          0) ...[
                                        TextField(
                                          controller: _homeworkController
                                              .submitContentController,
                                        )
                                      ] else ...[
                                        TextField(
                                          readOnly: true,
                                          controller: _homeworkController
                                              .submitContentController,
                                        )
                                      ],
                                      Card(
                                          child: Column(
                                        children: _homeworkController
                                            .stuHomeworkDocResList
                                            .map((i) => ListTile(
                                                  leading: Image.asset(
                                                    extToIcons(i['type']),
                                                    height: 26,
                                                  ),
                                                  title: Text(
                                                    i['docName'],
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  onTap: () async {
                                                    var url = (await Request().get(
                                                            Api.fetchDocPreview +
                                                                i['docId']))
                                                        .data['pathKey'];
                                                    UriHandler(url);
                                                  },
                                                  trailing: IconButton(
                                                      onPressed: () async {
                                                        await Request()
                                                            .download(
                                                                i['imgUrl'],
                                                                i['docName']);
                                                      },
                                                      icon: Icon(Icons
                                                          .download_rounded)),
                                                ))
                                            .cast<Widget>()
                                            .toList(),
                                      ))
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ));
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}

class HomeworkStatus extends StatelessWidget {
  HomeworkStatus({super.key});
  @override
  Widget build(BuildContext context) {
    final _homeworkController = Get.put(HomeworkController());

    return Obx(() => Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(3.5)),
              border: Border.all(
                  color: _homeworkController.statusColor[
                      _homeworkController.data['correctStatu'] ?? 0])),
          child: Padding(
            padding: EdgeInsets.all(2),
            child: Text(
              _homeworkController
                  .status[_homeworkController.data['correctStatu'] ?? 0],
              style: TextStyle(
                  fontSize: 12.5,
                  color: _homeworkController.statusColor[
                      _homeworkController.data['correctStatu'] ?? 0]),
            ),
          ),
        ));
  }
}
