import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:otter_study/common/widgets/constructing.dart';
import 'package:otter_study/pages/login/controller/index.dart';

class UserEditingView extends StatefulWidget {
  const UserEditingView({super.key});
  @override
  State<StatefulWidget> createState() => _UserEditingState();
}

class _UserEditingState extends State<UserEditingView> {
  final _credentialController = Get.put(CredentialController());

  _memberRoleDesc(int i) {
    switch (i) {
      case 1:
        return "运营者";
      case 2:
        return "教师";
      case 3:
        return "学生";
      default:
        return "未知";
    }
  }

  @override
  Widget build(BuildContext context) {
    final _userController = Get.put(UserController());
    return Scaffold(
      appBar: AppBar(
        title: Text("编辑资料"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: [
            _moduleCard(
                body: Column(
              children: ListTile.divideTiles(
                  context: context,
                  color: Color(0x11333333),
                  tiles: [
                    ListTile(
                      minTileHeight: 72,
                      title: Text("头像"),
                      trailing: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: Image.network(
                          _userController.userFullInfoJWT['av'] ?? "",
                          height: 64,
                        ),
                      ),
                    ),
                    _ListTile48(
                      title: Text("姓名"),
                      trailing: Text(
                          "${_userController.userFullInfoJWT['nm'] ?? ""}"),
                    ),
                    _ListTile48(
                      title: Text("学校/机构"),
                      trailing: Text(
                          "${_userController.userFullInfoJWT['tenants'][0]['tenantName'] ?? ""}"),
                    ),
                    _ListTile48(
                      title: Text("角色"),
                      trailing: Text(
                          "${_memberRoleDesc(_userController.userFullInfoJWT['tenants'][0]['memberType'] ?? 0)}"),
                    ),
                    _ListTile48(
                      title: Text("租户下姓名"),
                      trailing: Text(
                          "${_userController.userFullInfoJWT['tenants'][0]['memberName'] ?? ""}"),
                    ),
                    _ListTile48(
                      title: Text("用户ID"),
                      trailing: Text(
                          "${_userController.userFullInfoJWT['uid'] ?? ""}"),
                    ),
                  ]).toList(),
            )),
            const SizedBox(height: 15),
            _moduleCard(
                body: Column(
              children: ListTile.divideTiles(
                tiles: [
                  _ListTile48(
                    title: Text("姓名"),
                    trailing:
                        Text("${_userController.userFullInfo['nickName']}"),
                  ),
                  _ListTile48(
                    title: Text("性别"),
                    trailing:
                        Text("${_userController.userFullInfo['genderTxt']}"),
                  ),
                  _ListTile48(
                    title: Text("学校"),
                    trailing:
                        Text("${_userController.userFullInfo['college']}"),
                  ),
                  _ListTile48(
                    title: Text("专业"),
                    trailing: Text("${_userController.userFullInfo['major']}"),
                  ),
                  _ListTile48(
                    title: Text("学历"),
                    trailing:
                        Text("${_userController.userFullInfo['degreeTxt']}"),
                  ),
                  _ListTile48(
                    title: Text("入学时间"),
                    trailing: Text(
                        "${_userController.userFullInfo['enrollmentYear']}"),
                  ),
                  _ListTile48(
                    title: Text("学校所在地"),
                    trailing: Text("${_userController.userFullInfo['city']}"),
                  ),
                  _ListTile48(
                    title: Text("QQ"),
                    trailing: Text(
                        "${_userController.userFullInfo['qq'].isEmpty ? "未设置" : _userController.userFullInfo['qq']}"),
                  ),
                ],
                context: context,
                color: Color(0x11333333),
              ).toList(),
            )),
            const SizedBox(height: 15),
            _moduleCard(
                body: Column(
              children: ListTile.divideTiles(
                tiles: [
                  _ListTile48(
                    onTap: () {
                      SmartDialog.showToast("暂未实现");
                    },
                    title: Text("手机"),
                    trailing: Text(_userController.userFullInfoJWT['phone']),
                  ),
                  _ListTile48(
                    onTap: () {
                      SmartDialog.showToast("暂未实现");
                    },
                    title: Text("密码"),
                    trailing: Text(
                        _userController.userFullInfoJWT['userBaseInfo'] != null
                            ? "未设置"
                            : "已设置"),
                  ),
                  _ListTile48(
                    onTap: () {
                      SmartDialog.showToast("暂未实现");
                    },
                    title: Text("微信"),
                    trailing: Text(_userController
                            .userFullInfoJWT['wxId'].isEmpty
                        ? "未绑定"
                        : "已绑定( ${_userController.userFullInfoJWT['wn']} )"),
                  ),
                ],
                context: context,
                color: Color(0x11333333),
              ).toList(),
            ))
          ],
        ),
      ),
    );
  }
}

class _moduleCard extends StatelessWidget {
  Widget body;
  _moduleCard({required this.body});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: body,
      ),
    );
  }
}

class _ListTile48 extends StatelessWidget {
  Widget title;
  Widget? trailing;
  GestureTapCallback? onTap;

  _ListTile48({required this.title, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: title,
      trailing: trailing,
      minTileHeight: 48,
      leadingAndTrailingTextStyle: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w300,
          fontFamily: "MiSans"),
    );
  }
}
