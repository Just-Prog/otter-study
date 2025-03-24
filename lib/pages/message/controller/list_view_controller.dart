import 'dart:ui';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:otter_study/http/index.dart';
import 'package:otter_study/pages/main/controller.dart';

class MsgController extends GetxController {
  RxList msgs = RxList([]);
  Map<String, dynamic> msgType = {
    "EXAM_NOTICE": {
      "name": "考试通知",
      "icon": "assets/icons/message/icon-exam-notice.png"
    },
    "SYSTEM_NOTICE": {
      "name": "系统通知",
      "icon": "assets/icons/message/icon-system-notice.png"
    },
    "GOK_JOB": {
      "name": "国科就业",
      "icon": "assets/icons/message/icon-gok-job.png"
    },
    "INNER_PUSH": {
      "name": "内推邀请",
      "icon": "assets/icons/message/icon-inner-push.png"
    },
    "CLASS_NOTICE": {
      "name": "班课通知",
      "icon": "assets/icons/message/icon-class-notice"
    },
    "PROJECT_HELPER": {
      "name": "项目助手",
      "icon": "assets/icons/message/icon-project-helper.png"
    },
    "PROJECT_PUSH": {
      "name": "项目推荐",
      "icon": "assets/icons/message/icon-project-push.png"
    },
    "RECRUIT_INVITE": {
      "name": "校招邀请",
      "icon": "assets/icons/message/icon-recruit-push.png"
    }
  };
  List<Color> iconColors = [
    Color(0xff3bdd97),
    Color(0xff9090ff),
    Color(0xffff75af),
    Color(0xffffb489)
  ];
  late EasyRefreshController refreshController;

  fetchMsgs() async {
    final _mainController = Get.put(MainController());
    var resp = await Request().get(Api.fetchMsgsList);
    msgs.value = resp.data;
    msgs.refresh();
    await _mainController.fetchUnreadMsgCount();
  }

  @override
  void onInit() async {
    refreshController = EasyRefreshController(
        controlFinishRefresh: true, controlFinishLoad: false);
    // await fetchMsgs();
    super.onInit();
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }
}
