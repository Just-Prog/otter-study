import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:otter_study/http/index.dart';

class LearningController extends GetxController {
  final RxList courseMediumList = RxList([]);
  final RxMap recentContentData = RxMap({});
  final RxList dynamicRecentListResList = RxList([]);
  final RxList activityList = RxList([]);
  final RxBool isActivityListForActive = true.obs;

  final TextEditingController classSearchController = TextEditingController();
  final RxList classList = RxList([]);
  final RxBool isClassListArchived = false.obs;

  fetchRecentContentInfo() async {
    var resp = await Request().get(Api.fetchRecentContent);
    recentContentData.value = resp.data;
    dynamicRecentListResList.value = resp.data['dynamicRecentListResList'];
    return;
  }

  fetchCourseMediumList() async {
    var resp = await Request().get(Api.fetchCourseMediumActivities,
        params: {"pageNo": 1, "pageSize": 15});
    courseMediumList.value = resp.data['list'];
    return;
  }

  fetchActivityList() async {
    late String target;
    if (isActivityListForActive.value) {
      target = Api.fetchActivityActive;
    } else {
      target = Api.fetchActivityInactive;
    }
    var resp = await Request().get(target);
    activityList.value = resp.data['list'];
    return;
  }

  fetchDynamicPage() async {
    await fetchActivityList();
    await fetchCourseMediumList();
    await fetchRecentContentInfo();
    return;
  }

  fetchClassList() async {
    var resp = await Request().get(Api.fetchClassListApp,
        params: {
          'archives': isClassListArchived.value ? 1 : 0,
          'name': classSearchController.text,
          'pageNo': 1, // 临时写死
          'pageSize': 100 // 临时写死
        },
        options: Options(extra: {'version': 'android'}));
    classList.value = resp.data['list'];
    return;
  }

  putTopClass(String id) async {
    await Request().put(Api.putClassListTop + id);
    await fetchClassList();
    return;
  }

  changeClassArchiveStatus(String id) async {
    await Request().post(Api.setClassArchived, {"classId": id});
    await fetchClassList();
    return;
  }

  requestQuitClass(String id, String courseId) async {
    await Request().post(Api.quitClass, {"classId": id, "courseId": id});
    // 基于对一部分公开课的退课请求的观察结果来看，退课时使用的classId和courseId是一样的，逆天
    // 普通状态课程不清楚
    await fetchClassList();
    return;
  }

  requestJoinClass(String code) async {
    try {
      var resp = await Request().post(Api.joinClass, {"classCode": code});
      await fetchClassList();
      return {
        "id": resp.data['id'],
        "courseId": resp.data['courseId'],
      };
    } catch (e) {
      return {"id": -1, "courseId": -1};
    }
  }

  contentResHandler(item) async {
    print(item);
    switch (item['type']) {
      case 0:
        Get.toNamed("/homework", parameters: {
          'classId': item['classId'],
          'homeworkId': item['sourceId']
        });
      case 4: //签到类
        switch (item['signType']) {
          case 0:
          case 1:
            Get.toNamed("/signin/click",
                parameters: {'signId': item['contentId'] ?? item['dataId']});
            break;
          case 2:
            Get.toNamed("/signin/gesture",
                parameters: {'signId': item['contentId'] ?? item['dataId']});
            break;
          default:
            Get.snackbar("暂未实现", "暂未实现", backgroundColor: Colors.orange);
            break;
        }
        break;
      case 5:
      case 12:
        Get.toNamed("/courseware", parameters: {
          'chapterId': item['chapterId'],
          'dataId': item['dataId']
        });
      default:
        Get.snackbar("暂未实现", "暂未实现", backgroundColor: Colors.orange);
        break;
    }
    return;
  }

  @override
  void onInit() async {
    // await fetchDynamicPage();
    // await fetchClassList();
    super.onInit();
  }
}
