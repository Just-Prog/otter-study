import 'dart:developer';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:otter_study/http/index.dart';

class MsgDetailController extends GetxController {
  RxString type = "".obs;
  RxString classId = "0".obs;
  RxString className = "".obs;
  RxString tenantName = "".obs;
  int pageNo = 0;
  RxBool hasMore = true.obs;
  EasyRefreshController refreshController = EasyRefreshController(
      controlFinishLoad: true, controlFinishRefresh: true);
  RxMap<String, dynamic> resMap = <String, dynamic>{}.obs;

  Map<String, dynamic> resTitleDesc = {
    "0": {"name": "作业", "icon": "assets/icons/activity/icon-homework.png"},
    "1": {"name": "头脑风暴", "icon": "assets/icons/activity/icon-brainstorm.png"},
    "2": {"name": "测试", "icon": "assets/icons/activity/icon-test.png"},
    "3": {"name": "通知", "icon": "assets/icons/activity/icon-notice.png"},
    "4": {"name": "签到", "icon": "assets/icons/activity/icon-sign-in.png"},
    "5": {"name": "课件", "icon": "assets/icons/activity/icon-courseware.png"},
    "6": {"name": "活动", "icon": "assets/icons/message/icon-system-notice.png"},
    "12": {"name": "视频", "icon": "assets/icons/activity/icon-video.png"},
    "13": {"name": "问卷", "icon": "assets/icons/activity/icon-vote.png"},
    "14": {"name": "考试", "icon": "assets/icons/activity/icon-exam-notice.png"},
    "15": {"name": "练习", "icon": "assets/icons/activity/icon-practive.png"},
    "16": {
      "name": "外部链接",
      "icon": "assets/icons/activity/icon-external_links.png"
    },
    "-1": {
      "name": "默认系统通知标题",
      "icon": "assets/icons/message/icon-system-notice.png"
    }
  };

  fetchMsgs() async {
    pageNo++;
    Map<String, dynamic> params = {};
    if (type.value != "SYSTEM_NOTICE") {
      params['classId'] = classId.value;
    }
    params.addAll({
      "pageSize": 15,
      "pageNo": pageNo,
    });
    var resp = await Request().get(Api.fetchMsgs + type.value, params: params);
    Map<String, dynamic> res = resp.data;
    hasMore.value = res['more'];
    Map<String, dynamic> resMapRes = res['resMap'];
    for (var i in resMapRes.entries) {
      if (resMap.containsKey(i.key)) {
        resMap[i.key].addAll(i.value);
      } else {
        resMap.addAll({i.key: i.value});
      }
    }
    // resMap.value = mergeMaps(resMap, resMapRes);
    return;
  }

  msgHandler(i) {
    switch (i['type']) {
      case 0:
        Get.toNamed("/homework", parameters: {
          'classId': i['classId'],
          'homeworkId': i['contentId']
        });
      case 4: //签到类
        switch (i['signType']) {
          case 0:
          case 1:
            Get.toNamed("/signin/click",
                parameters: {'signId': i['contentId']});
            break;
          case 2:
            Get.toNamed("/signin/gesture",
                parameters: {'signId': i['contentId']});
            break;
          default:
            Get.snackbar("暂未实现", "暂未实现", backgroundColor: Colors.orange);
            break;
        }
        break;
      case 5:
      case 12:
        Get.toNamed("/courseware", parameters: {
          'chapterId': i['chapterId'],
          'dataId': i['contentId']
        });
      default:
        Get.snackbar("暂未实现", "暂未实现", backgroundColor: Colors.orange);
        break;
    }
    return;
  }

  @override
  void onInit() async {
    type.value = Get.parameters['type'] ?? "UNSUPPORTED_MSG_TYPE";
    classId.value = Get.parameters['classId'] ?? "0";
    className.value = Get.parameters['className'] ?? "";
    tenantName.value = Get.parameters['tenantName'] ?? "";
    super.onInit();
  }
}
