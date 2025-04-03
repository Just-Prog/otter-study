import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otter_study/http/index.dart';

class ClassController extends GetxController {
  RxString classId = "0".obs;
  RxString courseId = "0".obs;
  RxString name = "默认课程".obs;
  RxString teacher = "默认教师".obs;
  RxList chaptersList = RxList([]);
  RxList activitiesList = RxList([]);

  fetchClassInfo() async {
    var resp =
        await Request().post(Api.fetchClassInfo, {"classId": classId.value});
    //TODO 利用更多数据
    name.value = resp.data['className'];
    return;
  }

  fetchChapterDetails() async {
    var resp = await Request().get(Api.fetchClassChapterDetailsApp,
        params: {"classId": classId.value, "courseId": courseId.value},
        options: Options(extra: {'version': 'android'}));
    name.value = resp.data['className'];
    teacher.value = resp.data['classTeacher'];
    chaptersList.value = resp.data['appChapterListResList'];
    return;
  }

  fetchActivitiesList() async {
    var resp = await Request().get(Api.fetchClassActivitiesListApp,
        params: {"classId": classId.value, "status": 3},
        options: Options(extra: {'version': 'android'}));
    List activities = [];
    for (var i in resp.data['appActivityDataResList']) {
      for (var o in (i['data'] as Map<String, dynamic>).entries) {
        activities.add({'time': o.key, 'data': o.value});
      }
    }
    activitiesList.value = activities;
  }

  contentResHandler(item) async {
    switch (item['type']) {
      case 0:
        Get.toNamed("/homework", parameters: {
          'classId': classId.value,
          'homeworkId': item['contentId'] ?? item['dataId']
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
    classId.value = Get.parameters['classId'] ?? "0";
    courseId.value = Get.parameters['courseId'] ?? "0";
    // await fetchClassInfo();
    await fetchChapterDetails();
    await fetchActivitiesList();
    super.onInit();
  }
}
