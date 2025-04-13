import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:image_picker/image_picker.dart';
import 'package:file_selector/file_selector.dart';

import 'package:otter_study/http/index.dart';
import 'package:otter_study/pages/login/controller/credential_controller.dart';

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

  selectTenant(BuildContext context) async {
    var resp = await Request().get(Api.getTenantList);
    List list = resp.data;
    var target = await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
              title: Text('请选择学校/机构'),
              contentPadding: EdgeInsets.all(15),
              content: Container(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: list
                        .map((e) => ListTile(
                            title: Text("${e['tenantName']}"),
                            onTap: () {
                              Navigator.of(context).pop(e['tenantId']);
                            }))
                        .toList(),
                  )));
        });
    if (target != null) {
      await switchTenant(target);
    }
    return target;
  }

  uploadAvatar() async {
    final XFile? image;
    if (Platform.isAndroid || Platform.isIOS) {
      final ImagePicker picker = ImagePicker();
      image = await picker.pickImage(source: ImageSource.gallery);
    } else {
      image = await openFile(confirmButtonText: "选择", acceptedTypeGroups: [
        XTypeGroup(extensions: ['png', 'jpg', 'jpeg', 'gif'], label: "图片文件")
      ]);
    }
    if (image != null) {
      //TODO 图片裁剪/尺寸检测
      Map<String, dynamic> map = {};
      var data = await image.readAsBytes();
      map["file"] = MultipartFile.fromBytes(data, filename: image.name);
      FormData formData = FormData.fromMap(map);
      var u_resp = await Request().post(Api.uploadDocLink, formData);
      var resp = await Request()
          .put(Api.setUserAvatar, data: {"avatar": u_resp.data['url']});
      // 上传完头像之后会发回来新token
      await _apiCredentialController.setCredential(
          resp.headers['X-Token'][0], resp.headers['X-Mackey'][0]);
      await fetchUserInfo();
    }
    return;
  }
}
