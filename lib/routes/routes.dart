import 'package:get/get.dart';

import 'package:otter_study/pages/class/index.dart';
import 'package:otter_study/pages/courseware/index.dart';
import 'package:otter_study/pages/home/index.dart';
import 'package:otter_study/pages/homework/index.dart';
import 'package:otter_study/pages/login/index.dart';
import 'package:otter_study/pages/message/index.dart';
import 'package:otter_study/pages/main/index.dart';
import 'package:otter_study/pages/my/views/edit_view.dart';
import 'package:otter_study/pages/signIn/index.dart';
import 'package:otter_study/pages/webview/index.dart';

class Routes {
  static final List<GetPage<dynamic>> pages = [
    GetPage(name: "/", page: () => const MainPage()),
    GetPage(name: "/home", page: () => const HomePage()),
    GetPage(name: "/class", page: () => const ClassPage()),
    GetPage(name: "/homework", page: () => const HomeWorkView()),
    GetPage(name: "/msg/detail", page: () => const MsgDetailPage()),
    GetPage(name: "/signin/gesture", page: () => const SignInGesturePage()),
    GetPage(name: "/signin/click", page: () => const SignInClickPage()),
    GetPage(name: "/courseware", page: () => const CoursewarePage()),
    GetPage(name: "/webview", page: () => const Webview()),
    GetPage(name: "/user/login", page: () => const LoginPage()),
    GetPage(name: "/user/edit", page: () => const UserEditingView())
  ];
}
