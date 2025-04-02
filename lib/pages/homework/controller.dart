import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:otter_study/http/index.dart';

class HomeworkController extends GetxController {
  final RxString classId = "".obs;
  final RxString hwId = "".obs;

  final RxMap data = RxMap({});
  final RxList homeworkDocResList = RxList([]);
  final RxList stuHomeworkDocResList = RxList([]);
  TextEditingController submitContentController = TextEditingController();
  // RxList groupDetailResList = RxList([]); //没有数据样例

  List<String> status = ["未批改", "进行中", "已批改"];
  List<Color> statusColor = [
    Colors.grey,
    Colors.lightBlue,
    Colors.lightGreenAccent
  ];

  fetchHomeworkData() async {
    var resp = await Request().post(Api.fetchHomeworkDetailApp,
        {'classId': classId.value, 'homeworkId': hwId.value},
        options: Options(extra: {'version': "android"}));
    data.value = resp.data;
    homeworkDocResList.value = data['homeworkDocListResList'];
    stuHomeworkDocResList.value = data['stuHomeworkDocListResList'];
    submitContentController.text = data['submitContent'].toString();
    return;
  }

  @override
  void onInit() async {
    classId.value = Get.parameters['classId'] ?? "0";
    hwId.value = Get.parameters['homeworkId'] ?? "0";
    // await fetchHomeworkData();
    super.onInit();
  }
}
