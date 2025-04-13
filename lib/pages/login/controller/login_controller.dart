import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crypto/crypto.dart';

import 'package:otter_study/http/index.dart';
import 'package:otter_study/pages/login/controller/index.dart';

class LoginController extends GetxController {
  String rid = "";

  TextEditingController phoneController = TextEditingController();

  TextEditingController pwdController = TextEditingController();
  TextEditingController smsCodeController = TextEditingController();

  final _apiCredentialController = Get.put(CredentialController());
  final _userController = Get.put(UserController());

  fetchSMSRid() async {
    rid = "";
    var resp = await Request().post(
        Api.loginBySMSCodeFetch, {'phone': phoneController.text},
        options: Options(extra: {'target': 'login'}));
    rid = resp.data['rid'];
    return rid;
  }

  fetchPwdRid() async {
    rid = "";
    var resp = await Request().post(
        Api.loginByPasswordInit, {'username': phoneController.text},
        options: Options(extra: {'target': 'login'}));
    rid = resp.data['rid'];
    return rid;
  }

  loginBySms(context) async {
    var resp = await Request().post(
        Api.loginBySMSCode,
        {
          'phone': phoneController.text,
          'rid': rid,
          'smsCode': smsCodeController.text
        },
        options: Options(extra: {'target': 'login'}));
    smsCodeController.clear();
    rid = "";
    await tokenFetch(resp.headers['X-Code'][0]);
    await _userController.selectTenant(context);
    return resp.headers['X-Code'][0];
  }

  loginByPwd(context) async {
    var tmp = utf8.encode(pwdController.text);
    var _pwd_md5 = md5.convert(tmp).toString();
    List<int> _rid = utf8.encode(rid);
    var _hmac = Hmac(sha256, _rid);
    var hmac = _hmac.convert(utf8.encode(_pwd_md5));
    var pwd = base64Encode(hmac.bytes)
        .replaceAll("+", "-")
        .replaceAll("=", "")
        .replaceAll("/", "_");
    var resp = await Request().post(Api.loginByPassword,
        {'rid': rid, 'username': phoneController.text, 'password': pwd},
        options: Options(extra: {'target': 'login'}));
    pwdController.clear();
    rid = "";
    await tokenFetch(resp.headers['X-Code'][0]);
    await _userController.selectTenant(context);
    return resp.headers['X-Code'][0];
  }

  tokenFetch(map) async {
    map = jsonDecode(map);
    var resp = await Request().get(Api.loginFetchTokenByCodeUid,
        params: map, options: Options(extra: {'target': 'login'}));
    var x_token = resp.headers["X-Token"][0];
    var x_mackey = resp.headers["X-MacKey"][0];
    await _apiCredentialController.setCredential(x_token, x_mackey);
    _apiCredentialController.isLoggedIn.value = true;
    return x_token;
  }
}
