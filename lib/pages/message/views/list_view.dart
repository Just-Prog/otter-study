import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:otter_study/pages/login/controller/user_controller.dart';
import 'package:otter_study/pages/login/controller/credential_controller.dart';
import 'package:otter_study/pages/message/index.dart';

class MsgPage extends StatefulWidget {
  const MsgPage({super.key});

  @override
  State<StatefulWidget> createState() => MsgPageState();
}

class MsgPageState extends State<MsgPage> {
  @override
  Widget build(BuildContext context) {
    final _msgController = Get.put(MsgController());
    final _credentialController = Get.put(CredentialController());
    final _userController = Get.put(UserController());
    return Scaffold(
        body: EasyRefresh(
            controller: _msgController.refreshController,
            refreshOnStart: true,
            onRefresh: () async {
              if (_credentialController.isLoggedIn.value) {
                await _msgController.fetchMsgs();
              }
              _msgController.refreshController.finishRefresh();
              _msgController.refreshController.resetHeader();
            },
            header: const MaterialHeader(),
            child: CustomScrollView(
              slivers: [
                if (_credentialController.isLoggedIn.value) ...[
                  SliverToBoxAdapter(
                    child: Obx(() => ListView.separated(
                        itemBuilder: (ctx, idx) {
                          String type = _msgController.msgs[idx]['msgCategory'];
                          String title = _msgController.msgType[type]['name'];
                          String icon = _msgController.msgType[type]['icon'];
                          String remark = _msgController.msgs[idx]['remark'];
                          String className =
                              _msgController.msgs[idx]['className'];
                          String tenantName =
                              _msgController.msgs[idx]['tenantName'];
                          String tenantId =
                              _msgController.msgs[idx]['tenantId'];
                          String classId = _msgController.msgs[idx]['classId'];
                          int time =
                              int.parse(_msgController.msgs[idx]['time']);
                          int unreadNum = _msgController.msgs[idx]['unreadNum'];

                          String timeTxt = _msgController.msgs[idx]['timeTxt'];
                          return ListTile(
                            onTap: () {
                              if (type == "CLASS_NOTICE") {
                                if (tenantId !=
                                    _userController.tenantId.value) {
                                  SmartDialog.showToast("请先切换到对应的租户");
                                  return;
                                }
                              }
                              Get.toNamed("/msg/detail", parameters: {
                                "type": type,
                                "classId": classId,
                                "className": className,
                                "tenantName": tenantName,
                              });
                              _msgController.refreshController.callRefresh();
                            },
                            leading: type == "CLASS_NOTICE"
                                ? CircleAvatar(
                                    backgroundColor:
                                        _msgController.iconColors[time % 4],
                                    child: Text(
                                      className.substring(0, 1),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  )
                                : CircleAvatar(
                                    backgroundColor:
                                        _msgController.iconColors[time % 4],
                                    foregroundImage: AssetImage(icon),
                                  ),
                            title: type == "CLASS_NOTICE"
                                ? Row(
                                    spacing: 5,
                                    children: [
                                      ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.35,
                                          ),
                                          child: Text(className,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                  fontSize: 15.5),
                                              overflow: TextOverflow.ellipsis)),
                                      Expanded(
                                          child: Text("@$tenantName",
                                              maxLines: 1,
                                              style: const TextStyle(
                                                  fontSize: 12.5,
                                                  color: Colors.orange),
                                              overflow: TextOverflow.ellipsis)),
                                    ],
                                  )
                                : Text(title),
                            subtitle: Text(
                              remark,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(timeTxt),
                                if (unreadNum != 0) ...[
                                  Container(
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
                                      child: Text(
                                        unreadNum.toString(),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  )
                                ],
                              ],
                            ),
                          );
                        },
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(
                            indent: 72,
                            endIndent: 20,
                            height: 6,
                            color: Colors.grey.withOpacity(0.1),
                          );
                        },
                        itemCount: _msgController.msgs.length)),
                  )
                ] else ...[
                  SliverToBoxAdapter(
                    child: Center(
                      child: Text("请登录"),
                    ),
                  )
                ]
              ],
            )));
  }
}
