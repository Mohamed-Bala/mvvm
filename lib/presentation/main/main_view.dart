import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../resources/color_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';
import 'pages/cart/cart_page.dart';
import 'pages/home/view/home_page.dart';
import 'pages/notification/notification_page.dart';
import 'pages/settings/settings_page.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _curnIndex = 0;
  var _title = AppStrings.home.tr();

  List<String> titles = [
    AppStrings.home.tr(),
    AppStrings.notification.tr(),
    AppStrings.cart.tr(),
    AppStrings.settings.tr(),
  ];

  List<Widget> pages = const [
    CartPage(),
    HomePage(),
    NotificationPage(),
    
    SettingesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorManager.white,
        appBar: AppBar(
          title: Text(
            _title.tr(),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: ColorManager.primary,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
          ),
          elevation: AppSize.s0,
        ),
        body: pages[_curnIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _curnIndex,
          selectedItemColor: ColorManager.primary,
          unselectedItemColor: ColorManager.grey,
          onTap: changeInde,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(
                CupertinoIcons.home,
              ),
              label: AppStrings.home.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(
                Icons.notifications_on_outlined,
              ),
              label: AppStrings.notification.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(
                CupertinoIcons.cart,
              ),
              label: AppStrings.cart.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(
                CupertinoIcons.settings,
              ),
              label: AppStrings.settings.tr(),
            ),
          ],
        ),
      ),
    );
  }

  changeInde(int index) {
    setState(() {
      _curnIndex = index;
      _title = titles[index];
    });
  }
}
