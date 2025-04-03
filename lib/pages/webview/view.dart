
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'controller.dart';

class Webview extends StatefulWidget {
  const Webview({super.key});

  @override
  State<StatefulWidget> createState() => WebViewState();
}

class WebViewState extends State<Webview> {
  final _webviewController = Get.put(WebviewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: '刷新',
            onPressed: () {
              _webviewController.viewCtl.reload();
            },
            icon: Icon(Icons.refresh_outlined,
                color: Theme.of(context).colorScheme.primary),
          ),
          IconButton(
              tooltip: '在浏览器中打开',
              onPressed: () => launchUrl(Uri.parse(_webviewController.url)),
              icon: Icon(Icons.open_in_browser_rounded))
        ],
      ),
      body: SafeArea(
          child: WebViewWidget(
        controller: _webviewController.viewCtl,
      )),
    );
  }
}
