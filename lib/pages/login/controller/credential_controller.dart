import 'dart:convert';
import 'dart:math';
import 'dart:core';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:otter_study/pages/login/controller/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../http/index.dart';

class CredentialController extends GetxController {
  late final SharedPreferences prefs;
  RxBool isLoggedIn = true.obs;

  late String jwt;
  late String macKey;

  String nonceGenerate() {
    String a = "ABCDEFGHJKMNPQRSTWXYZabcdefhijkmnprstwxyz2345678";
    int b = 32, c = a.length;
    String d = List.generate(b, (idx) {
      return a[Random().nextInt(c)];
    }).join();
    return d;
  }

  loadCredential() async {
    // if (prefs.getString("token") == null || prefs.getString("macKey") == null) {
    //   prefs.setString("token", "");
    //   prefs.setString("macKey", "");
    // }
    jwt = prefs.getString("token") ?? "";
    var nonce = nonceGenerate();
    var timestamp = DateTime.now().millisecondsSinceEpoch;
    macKey = prefs.getString("macKey") ?? "";
    return {
      'token': jwt,
      'nonce': nonce,
      'timestamp': timestamp,
      'mackey': macKey
    };
  }

  loadJWT() async {
    jwt = prefs.getString("token") ?? "";
    return jwt;
  }

  setCredential(String jwt, String macKey) async {
    await prefs.setString("token", jwt);
    await prefs.setString("macKey", macKey);
    jwt = jwt;
    macKey = macKey;
    return;
  }

  refreshToken() async {
    try {
      var resp = await Request().post(Api.refreshToken, null,
          options: Options(extra: {"target": "refresh"}));
      await setCredential(
          resp.headers['X-Token'][0], resp.headers['X-Mackey'][0]);
    } catch (e) {
      throw Exception("凭据过期或网络异常");
    }
    return;
  }

  userInfoDecode(jwt) async {
    var tmp =
        jwt.toString().split(".")[1].replaceAll("-", "+").replaceAll("_", "/");
    return jsonDecode(utf8.decode(base64Decode(base64.normalize(tmp))));
  }

  logout() async {
    final _userController = Get.put(UserController());
    await setCredential("", "");
    _userController.onInit();
    isLoggedIn.value = false;
    return;
  }

  checkLogin() async {
    if ((await loadCredential())['token'] != "" &&
        (await loadCredential())['macKey'] != "") {
      try {
        await refreshToken();
      } catch (e) {
        isLoggedIn.value = false;
      }
    } else {
      isLoggedIn.value = false;
    }
    return;
  }
}
