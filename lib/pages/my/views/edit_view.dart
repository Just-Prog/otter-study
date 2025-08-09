import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:toggle_switch/toggle_switch.dart';

import 'package:otter_study/pages/login/controller/index.dart';

class UserEditingView extends StatefulWidget {
  const UserEditingView({super.key});
  @override
  State<StatefulWidget> createState() => _UserEditingState();
}

class _UserEditingState extends State<UserEditingView>
    with TickerProviderStateMixin {
  String? _selectedGender;
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
  void initState() {
    super.initState();
    final _userController = Get.put(UserController());
    _selectedGender = _userController.userFullInfo['gender'] ?? "male";
  }

  @override
  Widget build(BuildContext context) {
    final _userController = Get.put(UserController());
    return Scaffold(
      appBar: AppBar(
        title: Text("资料"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Obx(() => ListView(
              children: [
                _ModuleCard(
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
                          onTap: () async {
                            _userController.uploadAvatar();
                          },
                        ),
                        _ListTile48(
                          title: Text("姓名"),
                          trailing: Text(
                              "${_userController.userFullInfoJWT['nm'] ?? ""}"),
                        ),
                        _ListTile48(
                          title: Text("学校/机构"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  "${_userController.userFullInfoJWT['tenants'][0]['tenantName'] ?? ""}"),
                              Icon(
                                Icons.arrow_drop_down,
                                size: 16,
                              )
                            ],
                          ),
                          onTap: () async {
                            _userController.selectTenant(context).then((_) {
                              if (_ != null) {
                                Get.offAllNamed("/");
                              }
                            });
                          },
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
                _ModuleCard(
                    onTap: () async {
                      await showDialog(
                          context: context,
                          builder: (ctx) {
                            String _dialogGender =
                                _userController.userFullInfo['gender'] ??
                                    "male";
                            GlobalKey _form = GlobalKey();
                            return AlertDialog(
                              title: Text("编辑资料"),
                              content:
                                  StatefulBuilder(builder: (context, setState) {
                                return Container(
                                  width: double.maxFinite,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Form(
                                          key: _form,
                                          child: Column(
                                            children: [
                                              TextFormField(
                                                decoration:
                                                    const InputDecoration(
                                                        labelText: "姓名",
                                                        icon:
                                                            Icon(Icons.person)),
                                                maxLines: 1,
                                              ),
                                              TextFormField(
                                                decoration:
                                                    const InputDecoration(
                                                        labelText: "学校",
                                                        icon:
                                                            Icon(Icons.school)),
                                                maxLines: 1,
                                              ),
                                              TextFormField(
                                                decoration:
                                                    const InputDecoration(
                                                        labelText: "专业",
                                                        icon: Icon(Icons
                                                            .build_circle)),
                                                maxLines: 1,
                                              ),
                                              TextFormField(
                                                decoration:
                                                    const InputDecoration(
                                                        labelText: "学历",
                                                        icon: Icon(
                                                            Icons.menu_book)),
                                                maxLines: 1,
                                              ),
                                              TextFormField(
                                                decoration:
                                                    const InputDecoration(
                                                        labelText: "入学年份",
                                                        icon: Icon(
                                                            Icons.schedule)),
                                                maxLines: 1,
                                              ),
                                              TextFormField(
                                                decoration:
                                                    const InputDecoration(
                                                        labelText: "学校所在地",
                                                        icon: Icon(Icons
                                                            .location_pin)),
                                                maxLines: 1,
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(Icons.wc),
                                                  Expanded(
                                                      child: Row(
                                                    children: [
                                                      Radio(
                                                        value: "male",
                                                        onChanged: // 此处在后续测试版有行为和组件变更
                                                            (String? value) {
                                                          setState(() {
                                                            _dialogGender =
                                                                "male";
                                                          });
                                                        },
                                                        groupValue:
                                                            _dialogGender,
                                                      ),
                                                      const Text("男"),
                                                      const SizedBox(width: 15),
                                                      Radio(
                                                        value: "female",
                                                        onChanged:
                                                            (String? value) {
                                                          setState(() {
                                                            _dialogGender =
                                                                "female";
                                                          });
                                                        },
                                                        groupValue:
                                                            _dialogGender,
                                                      ),
                                                      const Text("女"),
                                                    ],
                                                  )),
                                                ],
                                              ),
                                              TextFormField(
                                                decoration:
                                                    const InputDecoration(
                                                        labelText: "QQ",
                                                        icon: Icon(Icons
                                                            .contact_mail)),
                                                maxLines: 1,
                                              ),
                                            ],
                                          ))
                                    ],
                                  ),
                                );
                              }),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Text("取消"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedGender = _dialogGender;
                                    });
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Text("确定"),
                                ),
                              ],
                            );
                          });
                    },
                    body: Column(
                      children: ListTile.divideTiles(
                        tiles: [
                          _ListTile48(
                            title: Text("姓名"),
                            trailing: Text(
                                "${_userController.userFullInfo['nickName']}"),
                          ),
                          _ListTile48(
                            title: Text("性别"),
                            trailing: Text(
                                "${_userController.userFullInfo['genderTxt']}"),
                          ),
                          _ListTile48(
                            title: Text("学校"),
                            trailing: Text(
                                "${_userController.userFullInfo['college']}"),
                          ),
                          _ListTile48(
                            title: Text("专业"),
                            trailing: Text(
                                "${_userController.userFullInfo['major']}"),
                          ),
                          _ListTile48(
                            title: Text("学历"),
                            trailing: Text(
                                "${_userController.userFullInfo['degreeTxt']}"),
                          ),
                          _ListTile48(
                            title: Text("入学时间"),
                            trailing: Text(
                                "${_userController.userFullInfo['enrollmentYear']}"),
                          ),
                          _ListTile48(
                            title: Text("学校所在地"),
                            trailing:
                                Text("${_userController.userFullInfo['city']}"),
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
                _ModuleCard(
                    body: Column(
                  children: ListTile.divideTiles(
                    tiles: [
                      _ListTile48(
                        onTap: () {
                          SmartDialog.showToast("暂未实现");
                        },
                        title: Text("手机"),
                        trailing:
                            Text(_userController.userFullInfoJWT['phone']),
                      ),
                      _ListTile48(
                        onTap: () {
                          SmartDialog.showToast("暂未实现");
                        },
                        title: Text("密码"),
                        trailing: Text(
                            _userController.userFullInfoJWT['userBaseInfo'] !=
                                    null
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
            )),
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  Widget body;
  GestureTapCallback? onTap;
  _ModuleCard({required this.body, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: body,
        ),
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
