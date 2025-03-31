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
                  child: Text("ERROR"),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Obx(() => SwitchListTile(
                          title: Text("归档课程?"),
                          value: _learningController.isClassListArchived.value,
                          onChanged: (b) async {
                            _learningController.isClassListArchived.value = b;
                            await _learningController.fetchClassList();
                          })),
                    ),
                    SliverToBoxAdapter(
                        child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                            child: Column(
                                spacing: 5,
                                children:
                                    _learningController.classList.map((e) {
                                  return Card(
                                    clipBehavior: Clip.antiAlias,
                                    child: InkWell(
                                      onTap: () {
                                        if (e['enterFlag'] == 1) {
                                          Get.toNamed("/class", parameters: {
                                            'classId': e['id'],
                                            'courseId': e['courseId']
                                          });
                                        } else {
                                          SmartDialog.showToast("已结课或教师设置锁定班课");
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
                                                          title: Text("置顶")),
                                                      ListTile(
                                                          title: Text("归档")),
                                                      ListTile(
                                                          title: Text("退出班课")),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
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
                                                  const SizedBox(
                                                    width: 15,
                                                  ),
                                                  Expanded(
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
                                                        overflow: TextOverflow
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
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        13),
                                                          ))
                                                        ],
                                                      )
                                                    ],
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
                                                          transform:
                                                              Matrix4.rotationZ(
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
                                                        color: Colors.orange,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      child: Text(
                                                        e['classType']
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color: Colors.white,
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
                                }).toList()))))
                  ],
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
