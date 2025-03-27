import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:otter_study/pages/message/index.dart';
import 'package:otter_study/utils/goktech_assets.dart';

class MsgDetailPage extends StatelessWidget {
  const MsgDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _detailController = Get.put(MsgDetailController());
    return Obx(() => Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_detailController.type.value != "SYSTEM_NOTICE") ...[
                  Text(
                    _detailController.className.value,
                    style: const TextStyle(fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "@${_detailController.tenantName.value}",
                    style: const TextStyle(fontSize: 12, color: Colors.orange),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ] else ...[
                  Text("系统通知")
                ]
              ],
            ),
          ),
          body: EasyRefresh(
              refreshOnStart: true,
              controller: _detailController.refreshController,
              header: const MaterialHeader(),
              footer: const MaterialFooter(),
              onRefresh: () async {
                try {
                  await _detailController.clearMsgs();
                  await _detailController.fetchMsgs();
                  _detailController.refreshController.finishRefresh();
                  return IndicatorResult.success;
                } catch (e) {
                  _detailController.refreshController.finishRefresh();
                  return IndicatorResult.fail;
                }
              },
              onLoad: () async {
                try {
                  if (_detailController.hasMore.value == false) {
                    _detailController.refreshController.finishLoad();
                    return IndicatorResult.noMore;
                  }
                  await _detailController.fetchMsgs();
                  _detailController.refreshController.finishLoad();
                  return IndicatorResult.success;
                } catch (e) {
                  _detailController.refreshController.finishLoad();
                  return IndicatorResult.fail;
                }
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Column(
                        spacing: 30,
                        children:
                            _detailController.resMap.entries.toList().map((e) {
                          return Column(
                            spacing: 15,
                            children: [
                              Text("${e.key}"),
                              Column(
                                spacing: 10,
                                children: e.value
                                    .map((i) => Container(
                                          width: double.infinity,
                                          child: Card(
                                            clipBehavior: Clip.antiAlias,
                                            child: InkWell(
                                              onTap: () => _detailController
                                                  .msgHandler(i),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                child: Column(
                                                  spacing: 10,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          spacing: 10,
                                                          children: [
                                                            Image.asset(
                                                                height: 24,
                                                                "${i['type'] == 5 ? extToIcons(i['typeStr']) : _detailController.resTitleDesc[i['type'].toString()]['icon']}"),
                                                            Text(
                                                              "${i['type'] == -1 ? i['title'] : _detailController.resTitleDesc[i['type'].toString()]['name']}",
                                                              style: const TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                        Text("${i['timeTxt']}")
                                                      ],
                                                    ),
                                                    Divider(
                                                      height: 1,
                                                      color: const Color(
                                                          0x22000000),
                                                    ),
                                                    Text("${i['remark']}")
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ))
                                    .toList()
                                    .cast<Widget>(),
                              )
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  )
                ],
              )),
        ));
  }
}
