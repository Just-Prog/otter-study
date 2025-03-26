import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otter_study/pages/learning/index.dart';

// TODO 加课码
class ClassesListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _learningController = Get.put(LearningController());
    return Scaffold(
      body: CustomScrollView(
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
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                      children: _learningController.classList.map((e) {
                        return Card(
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () => Get.toNamed("/class", parameters: {
                              'classId': e['id'],
                              'courseId': e['courseId']
                            }),
                            child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width),
                                child: Stack(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        if (e['imageUrl']
                                            .toString()
                                            .startsWith("/static")) ...[
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
                                              imageUrl: "${e['imageUrl']}",
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
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${e['className']} ${e['exClassName']}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
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
                                                      fontSize: 13),
                                                ))
                                              ],
                                            )
                                          ],
                                        ))
                                      ],
                                    ),
                                    if (e['topFlag'] == 1) ...[
                                      Align(
                                        alignment: Alignment(-5, -5),
                                        heightFactor: .9,
                                        widthFactor: .9,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.orange,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Text(
                                              "置顶",
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
      ),
    );
  }
}
