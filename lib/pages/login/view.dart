import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'controller/login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final _phoneFormKey = GlobalKey<FormState>();
    final _loginController = Get.put(LoginController());

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '登录',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    letterSpacing: 1,
                    height: 2.1,
                    fontSize: 34,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '请使用注册 河狸学途 的手机号码操作。',
                style: Theme.of(context).textTheme.titleSmall!,
              ),
              SizedBox(height: 45),
              Form(
                key: _phoneFormKey,
                child: TextFormField(
                  controller: _loginController.phoneController,
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "手机号码",
                      prefixIcon: Icon(Icons.phone_android_outlined),
                      suffixIcon: IconButton(
                          onPressed: _loginController.phoneController.clear,
                          icon: Icon(Icons.clear))),
                  inputFormatters: [LengthLimitingTextInputFormatter(11)],
                  validator: (v) {
                    var pattern = RegExp(
                        r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
                    return v!.trim().isNotEmpty
                        ? (pattern.hasMatch(v.trim()) ? null : "手机号码不符合规范")
                        : "手机号码不能为空";
                  },
                  autovalidateMode: AutovalidateMode.always,
                ),
              ),
              SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 45,
                children: [
                  OutlinedButton.icon(
                    onPressed: () async {
                      if (_phoneFormKey.currentState!.validate()) {
                        // print(_loginController.phoneController.text);
                        _loginController.fetchSMSRid().then((_) {
                          Get.defaultDialog(
                            title: "短信登录",
                            contentPadding: EdgeInsets.all(15),
                            content: Form(
                                child: TextField(
                              controller: _loginController.smsCodeController,
                              autofocus: true,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(8)
                              ],
                            )),
                            onConfirm: () {
                              _loginController.loginBySms().then((_) {
                                Get.offAllNamed("/");
                              });
                            },
                            textConfirm: "确定",
                          );
                        });
                      }
                    },
                    icon: Icon(Icons.chat),
                    label: Text("短信登录"),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      if (_phoneFormKey.currentState!.validate()) {
                        // print(_loginController.phoneController.text);
                        // _loginController.fetchPwdRid().then((_){
                        //
                        // });
                        _loginController.fetchPwdRid().then((_) async {
                          Get.defaultDialog(
                              title: "密码登录",
                              contentPadding: EdgeInsets.all(15),
                              content: Form(
                                  child: TextField(
                                controller: _loginController.pwdController,
                                autofocus: true,
                                keyboardType: TextInputType.text,
                                obscureText: true,
                              )),
                              onConfirm: () async {
                                _loginController.loginByPwd().then((_) {
                                  Get.offAllNamed("/");
                                });
                              },
                              textConfirm: "确定");
                        });
                      }
                    },
                    icon: Icon(Icons.key),
                    label: Text("密码登录"),
                  )
                ],
              ),
              SizedBox(height: 35),
              SizedBox(
                width: double.infinity,
                child: Text(
                    '免责声明: 本软件与 福建国科信息科技有限公司/河狸学途平台 无直接关联，为第三方开发，使用请遵守平台规定\n'
                    '河狸学途 https://edu.goktech.cn 闽ICP备15016628号-1 ',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.4))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
