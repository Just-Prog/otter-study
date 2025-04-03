
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otter_study/utils/goktech_assets.dart';
import 'package:otter_study/pages/learning/controller.dart';

class DynamicView extends StatefulWidget {
  @override
  State<DynamicView> createState() => _dynamicState();
}

class _dynamicState extends State<DynamicView>
    with AutomaticKeepAliveClientMixin {
  final _learningController = Get.put(LearningController());

  // @override
  // void initState() {
  //   _learningController.onInit();
  //   super.initState();
  // }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _learningController.fetchDynamicPage(),
          builder: (ctx, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("ERROR"), Text(snapshot.error.toString())],
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        spacing: 10,
                        children: [
                          if (_learningController
                              .courseMediumList.isNotEmpty) ...[
                            Card(
                              // https://api.goktech.cn/tac/home-page/course-medium?pageNo=1&pageSize=15
                              child: SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: EdgeInsets.all(17.5),
                                  child: Column(
                                    spacing: 10,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "课件",
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "* 访问班课查看更多",
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          )
                                        ],
                                      ),
                                      Obx(() => SizedBox(
                                            height: 240,
                                            child: ListView.builder(
                                              itemBuilder: (context, index) {
                                                return ListTile(
                                                  leading: Image.asset(
                                                    _learningController.courseMediumList[
                                                                    index]
                                                                ['type'] ==
                                                            5
                                                        ? extToIcons(_learningController
                                                                .courseMediumList[
                                                            index]['typeStr'])
                                                        : type2Icons(
                                                            _learningController
                                                                .courseMediumList[
                                                                    index]
                                                                    ['type']
                                                                .toString()),
                                                    height: 28,
                                                  ),
                                                  title: Text(
                                                    "${_learningController.courseMediumList[index]['sourceName']}",
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                        fontSize: 15),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  subtitle: Text(
                                                    "${_learningController.courseMediumList[index]['courseName']}",
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                        fontSize: 12),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  trailing: Text(DateFormat(
                                                          'yyyy-MM-dd')
                                                      .format(DateTime.fromMillisecondsSinceEpoch(
                                                          int.parse(_learningController
                                                                      .courseMediumList[
                                                                  index][
                                                              'publishTime'])))),
                                                  onTap: () {
                                                    Get.toNamed("/courseware",
                                                        parameters: {
                                                          'chapterId':
                                                              _learningController
                                                                          .courseMediumList[
                                                                      index]
                                                                  ['chapterId'],
                                                          'dataId': _learningController
                                                                  .courseMediumList[
                                                              index]['sourceId']
                                                        });
                                                  },
                                                );
                                              },
                                              itemCount: _learningController
                                                  .courseMediumList.length,
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                          if (_learningController
                              .recentContentData.isNotEmpty) ...[
                            Card(
                              // https://api.goktech.cn/tac/home-page/recent-content
                              child: SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: EdgeInsets.all(17.5),
                                  child: Column(
                                    spacing: 10,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "最近访问",
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      if (_learningController
                                              .recentContentData['docId'] !=
                                          0) ...[
                                        Obx(() => Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                    child: Row(
                                                  spacing: 10,
                                                  children: [
                                                    Image.asset(
                                                      _learningController
                                                                      .recentContentData[
                                                                  'type'] ==
                                                              5
                                                          ? extToIcons(
                                                              _learningController
                                                                      .recentContentData[
                                                                  'typeStr'])
                                                          : type2Icons(
                                                              _learningController
                                                                  .recentContentData[
                                                                      'type']
                                                                  .toString()),
                                                      height: 32,
                                                    ),
                                                    Expanded(
                                                        child: Text(
                                                      _learningController
                                                                  .recentContentData[
                                                              'dataName'] ??
                                                          "Unknown",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ))
                                                  ],
                                                )),
                                                const SizedBox(width: 10),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Get.toNamed("/courseware",
                                                          parameters: {
                                                            'chapterId':
                                                                _learningController
                                                                        .recentContentData[
                                                                    'chapterId'],
                                                            'dataId':
                                                                _learningController
                                                                        .recentContentData[
                                                                    'dataId']
                                                          });
                                                    },
                                                    child: Text("继续学习"))
                                              ],
                                            )),
                                      ],
                                      Obx(() => GridView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 10,
                                              mainAxisSpacing: 10,
                                              mainAxisExtent: 40,
                                            ),
                                            itemBuilder: (ctx, idx) {
                                              return InkWell(
                                                onTap: () {
                                                  if (_learningController
                                                                  .recentContentData[
                                                              'dynamicRecentListResList']
                                                          [idx]['enterFlag'] ==
                                                      1) {
                                                    Get.toNamed("/class",
                                                        parameters: {
                                                          'courseId': _learningController
                                                                      .recentContentData[
                                                                  'dynamicRecentListResList']
                                                              [idx]['courseId'],
                                                          'classId': _learningController
                                                                      .recentContentData[
                                                                  'dynamicRecentListResList']
                                                              [idx]['recordId']
                                                        });
                                                  } else {
                                                    SmartDialog.showToast(
                                                        "已结课或教师设置锁定班课");
                                                  }
                                                },
                                                child: Row(
                                                  spacing: 10,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.orange,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        child: Text(
                                                          recordTypeDesc[_learningController
                                                                      .recentContentData[
                                                                  'dynamicRecentListResList']
                                                              [
                                                              idx]['recordType']],
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                        child: Text(
                                                      "${_learningController.recentContentData['dynamicRecentListResList'][idx]['recordName']}",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ))
                                                  ],
                                                ),
                                              );
                                            },
                                            itemCount: _learningController
                                                .dynamicRecentListResList
                                                .length,
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                          Card(
                            // https://api.goktech.cn/tac/home-page/course-medium?pageNo=1&pageSize=15
                            child: SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsets.all(17.5),
                                child: Column(
                                  spacing: 10,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "课内活动",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "* 访问班课查看更多",
                                          style: const TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        )
                                      ],
                                    ),
                                    Obx(() => SizedBox(
                                          height: 240,
                                          child: ListView(
                                            children: _learningController
                                                .activityList
                                                .map((e) {
                                              return ListTile(
                                                leading: Image.asset(
                                                  'assets/icons/activity/icon-homework.png',
                                                  height: 20,
                                                ),
                                                title: Text(
                                                  "${e['sourceName']}",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                ),
                                                subtitle: Text(
                                                  "${e['courseName']}",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                ),
                                                trailing: Text(DateFormat(
                                                        'yyyy-MM-dd hh:mm:ss')
                                                    .format(DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            int.parse(e[
                                                                'publishTime'])))),
                                                onTap: () {
                                                  _learningController
                                                      .contentResHandler(e);
                                                },
                                              );
                                            }).toList(),
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
