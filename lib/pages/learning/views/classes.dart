
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:otter_study/pages/learning/index.dart';

class ClassesListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ClassesListState();
}

// TODO 加课码
class _ClassesListState extends State<ClassesListView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final _learningController = Get.put(LearningController());
    return Scaffold(
        body: FutureBuilder(
            future: _learningController.fetchClassList(),
            builder: (ctx, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("错误"),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Obx(() => Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Row(
                                  children: [
                                    const Text(
                                      "归档课程?",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Switch(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        value: _learningController
                                            .isClassListArchived.value,
                                        onChanged: (b) async {
                                          _learningController
                                              .isClassListArchived.value = b;
                                          await _learningController
                                              .fetchClassList();
                                        })
                                  ],
                                )),
                                IconButton(
                                    onPressed: () async {
                                      await showDialog(
                                          context: context,
                                          builder: (ctx) {
                                            TextEditingController
                                                _codeController =
                                                TextEditingController();
                                            return AlertDialog(
                                              title: Text("添加课程"),
                                              content: TextField(
                                                  controller: _codeController,
                                                  decoration: InputDecoration(
                                                      labelText: "加课码")),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text("取消")),
                                                TextButton(
                                                    onPressed: () async {
                                                      var tmp =
                                                          await _learningController
                                                              .requestJoinClass(
                                                                  _codeController
                                                                      .text);
                                                      Navigator.of(context)
                                                          .pop();
                                                      if (tmp['id'] != -1) {
                                                        Get.toNamed("/class",
                                                            parameters: {
                                                              'classId':
                                                                  tmp['id'],
                                                              'courseId': tmp[
                                                                  'courseId']
                                                            });
                                                      }
                                                      return;
                                                    },
                                                    child: Text("确定")),
                                              ],
                                            );
                                          });
                                    },
                                    icon: Icon(Icons.add))
                              ],
                            ),
                          )),
                    ),
                    SliverToBoxAdapter(
                        child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: _learningController.classSearchController,
                        onChanged: (v) => _learningController.fetchClassList(),
                        decoration: InputDecoration(
                          icon: Icon(Icons.search),
                          hintText: "搜索课程...",
                        ),
                      ),
                    )),
                    SliverPadding(padding: EdgeInsets.symmetric(vertical: 5)),
                    SliverToBoxAdapter(
                        child: Obx(() => SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: _learningController.classList.isNotEmpty
                                ? Column(
                                    spacing: 5,
                                    children:
                                        _learningController.classList.map((e) {
                                      return Card(
                                        clipBehavior: Clip.antiAlias,
                                        child: InkWell(
                                          onTap: () {
                                            if (e['enterFlag'] == 1) {
                                              Get.toNamed("/class",
                                                  parameters: {
                                                    'classId': e['id'],
                                                    'courseId': e['courseId']
                                                  });
                                            } else {
                                              SmartDialog.showToast(
                                                  "已结课或教师设置锁定班课");
                                            }
                                          },
                                          onLongPress: () async {
                                            await showDialog(
                                                context: context,
                                                builder: (ctx) {
                                                  return AlertDialog(
                                                    content: Container(
                                                      width: double.maxFinite,
                                                      child: ListView(
                                                        shrinkWrap: true,
                                                        children: [
                                                          ListTile(
                                                              onTap: () {
                                                                _learningController
                                                                    .putTopClass(
                                                                        e['id']);
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              title: Text(
                                                                  e['topFlag'] ==
                                                                          0
                                                                      ? "置顶"
                                                                      : "取消置顶")),
                                                          ListTile(
                                                              onTap: () {
                                                                _learningController
                                                                    .changeClassArchiveStatus(
                                                                        e['id']);
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              title: Text(
                                                                  _learningController
                                                                          .isClassListArchived
                                                                          .value
                                                                      ? "取消归档"
                                                                      : "归档")),
                                                          ListTile(
                                                              onTap: () async {
                                                                await showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (ctx) {
                                                                      return AlertDialog(
                                                                          title: Text(
                                                                              "退出班课？"),
                                                                          content:
                                                                              Text("退出后可通过课码重新进入，继续？"),
                                                                          actions: [
                                                                            TextButton(
                                                                                onPressed: () {
                                                                                  Navigator.of(context).pop();
                                                                                },
                                                                                child: Text("取消")),
                                                                            TextButton(
                                                                                onPressed: () async {
                                                                                  await _learningController.requestQuitClass(e['id'], e['courseId']);
                                                                                  Navigator.of(context).pop();
                                                                                },
                                                                                child: Text("确认")),
                                                                          ]);
                                                                    });
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              title:
                                                                  Text("退出班课")),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });
                                          },
                                          child: ConstrainedBox(
                                              constraints: BoxConstraints(
                                                  maxWidth:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width),
                                              child: Stack(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      if (e['imageUrl']
                                                          .toString()
                                                          .startsWith(
                                                              "/static")) ...[
                                                        Image.asset(
                                                          "assets/images/default-cropper.png",
                                                          width: 144,
                                                          height: 90,
                                                          fit: BoxFit.cover,
                                                        )
                                                      ] else ...[
                                                        // Image.network("${e['imageUrl']}",
                                                        //     width: 144,
                                                        //     height: 90,
                                                        //     fit: BoxFit.cover),
                                                        CachedNetworkImage(
                                                            imageUrl:
                                                                "${e['imageUrl']}",
                                                            width: 144,
                                                            height: 90,
                                                            fit: BoxFit.cover),
                                                      ],
                                                      Expanded(
                                                          child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    17.5),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "${e['className']} ${e['exClassName']}",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                              style: const TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                  Icons.person,
                                                                  size: 16,
                                                                ),
                                                                Expanded(
                                                                    child: Text(
                                                                  "授课教师: ${e['teacherName']}",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          13),
                                                                ))
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ))
                                                    ],
                                                  ),
                                                  if (e['topFlag'] == 1) ...[
                                                    Positioned(
                                                        right: 0,
                                                        top: 3,
                                                        child: Opacity(
                                                            opacity: 0.6,
                                                            child: Transform(
                                                              transform: Matrix4
                                                                  .rotationZ(
                                                                      0.6),
                                                              child: Icon(
                                                                Icons
                                                                    .push_pin_rounded,
                                                                size: 16,
                                                              ),
                                                            )))
                                                  ],
                                                  if (e['classType'] != "") ...[
                                                    Positioned(
                                                      left: 4,
                                                      top: 4,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color:
                                                                Colors.orange,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          child: Text(
                                                            e['classType']
                                                                .toString(),
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ]
                                                ],
                                              )),
                                        ),
                                      );
                                    }).toList())
                                : Center(
                                    child: Text("无课程"),
                                  ))))
                  ],
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
