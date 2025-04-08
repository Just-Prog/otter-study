import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otter_study/http/index.dart';

class UserController extends GetxController {
  final _apiCredentialController = Get.put(CredentialController());
  RxString userName = "游客".obs;
  RxString userCollegeDesc = "".obs;
  RxString userAvatar = "".obs;
  String userId = "";
  RxString tenantId = "-1".obs;
  RxString tenantName = "暂无租户".obs;
  RxMap userFullInfoJWT = RxMap({});
  RxMap userFullInfo = RxMap({});

  fetchUserInfo() async {
    var resp = await Request().get(Api.fetchUserInfo);
    userFullInfoJWT.value = await _apiCredentialController
        .userInfoDecode((await _apiCredentialController.loadJWT()));
    userName.value = resp.data['nickName'];
    userFullInfo.value = resp.data;
    userCollegeDesc.value = "${resp.data['college']} - ${resp.data['major']}";
    userAvatar.value = userFullInfoJWT['av'];
    return;
  }

  loadTenant() async {
    var tenant;
    try {
      tenant = (await _apiCredentialController.userInfoDecode(
          (await _apiCredentialController.loadJWT())))['tenants'][0];
      tenantId.value = tenant['tenantId'].toString();
      tenantName.value = tenant['tenantName'].toString();
      log("tenant from credential: ${tenantName.value} (${tenantId.value})");
      return tenantId.value;
    } catch (e) {
      return "-1";
    }
  }

  switchTenant(tenant) async {
    if (tenant == "-1") {
      tenantId.value = tenant;
      return;
    }
    var resp = await Request().get("${Api.switchTenant}/$tenant");
    tenantId.value = tenant;
    tenantName.value = resp.data['tenantName'];
    await _apiCredentialController.setCredential(
        resp.headers['X-Token'][0], resp.headers['X-Mackey'][0]);
    return;
  }

  getTenentList() async {
    var resp = await Request().get(Api.getTenantList);
    List list = resp.data;
    return list;
  }

  selectTenant() async {
    var resp = await Request().get(Api.getTenantList);
    List list = resp.data;
    var target = await Get.defaultDialog(
        title: '请选择学校/机构',
        contentPadding: EdgeInsets.all(15),
        content: Column(
          children: list
              .map((e) => ListTile(
                  title: Text("${e['tenantName']}"),
                  onTap: () => Get.back(result: e['tenantId'])))
              .toList(),
        ));
    if (target != null) {
      await switchTenant(target);
    }
    return target;
  }
}
