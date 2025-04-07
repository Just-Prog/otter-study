
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:flutter/material.dart';
import 'package:otter_study/http/index.dart';

import 'package:otter_study/pages/home/index.dart';
import 'package:otter_study/pages/learning/view.dart';
import 'package:otter_study/pages/message/index.dart';
import 'package:otter_study/pages/login/controller/user_controller.dart';
import 'package:otter_study/pages/my/index.dart';

class MainController extends GetxController {
  final _userController = Get.put(UserController());
  final _credentialController = Get.put(CredentialController());
  final List<Widget> pages = [
    const HomePage(),
    const LearningPage(),
    const MsgPage(),
    const MyPage()
  ];
  final RxList<Map<String, dynamic>> bottomNavItems = RxList([
    {"icon": const Icon(Icons.home), "label": "首页"},
    {"icon": const Icon(Icons.abc), "label": "学习"},
    {
      "icon": const Icon(Icons.messenger_outline_rounded),
      "label": "消息",
      "count": 0
    },
    {"icon": const Icon(Icons.person), "label": "我的"}
  ]);
  final PageController pageCtl = PageController(keepPage: false);
  RxInt pageIdx = 0.obs;

  fetchUnreadMsgCount() async {
    var item = bottomNavItems[
        bottomNavItems.indexWhere((item) => item['label'] == "消息")];
    Response resp = await Request().get(Api.fetchUnreadMsgsCount);
    print("unread: ${resp.data}");
    item['count'] = resp.data;
    return;
  }

  @override
  void onInit() async {
    print("login status: ${_credentialController.isLoggedIn.value}");
    if (_credentialController.isLoggedIn.value) {
      await fetchUnreadMsgCount();
      await _userController.fetchUserInfo();
      await _userController.loadTenant();
      ever(pageIdx, (_) async {
        await fetchUnreadMsgCount();
      });
    }
    super.onInit();
  }
}
