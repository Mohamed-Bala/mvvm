import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import '../../../../app/app_prefs.dart';
import '../../../../app/di.dart';
import '../../../../data/data_source/local_data_source.dart';
import '../../../resources/color_manager.dart';
import '../../../resources/routes_manager.dart';
import '../../../resources/strings_manager.dart';
import '../../../resources/values_manager.dart';

class SettingesPage extends StatefulWidget {
  const SettingesPage({Key? key}) : super(key: key);

  @override
  State<SettingesPage> createState() => _SettingesPageState();
}

class _SettingesPageState extends State<SettingesPage> {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final LocalDataSource _localDataSource = instance<LocalDataSource>();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        padding: const EdgeInsets.all(AppPadding.p8),
        children: [
          _getSettingWadget(AppStrings.profile.tr(), Icons.person_pin, () {}),
          const Divider(),
          ListTile(
            leading: Icon(Icons.language, color: ColorManager.primary),
            title: Text(AppStrings.changeLanguage.tr(),
                style: Theme.of(context).textTheme.bodyLarge),
            trailing:
                Icon(Icons.arrow_right_rounded, color: ColorManager.primary),
            onTap: () => changeLanguage(),
          ),
          // _getSettingWadget(
          //     AppStrings.changeLanguage.tr(), Icons.language, changeLanguage()),
          const Divider(),
          _getSettingWadget(
              AppStrings.contactUs.tr(), Icons.contact_support, () {}),
          const Divider(),
          _getSettingWadget(
              AppStrings.inviteYourFriends.tr(), Icons.share_sharp, () {}),
          const Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: ColorManager.primary),
            title: Text(AppStrings.logout.tr(),
                style: Theme.of(context).textTheme.bodyLarge),
            trailing:
                Icon(Icons.arrow_right_rounded, color: ColorManager.primary),
            onTap: () {
             _logout();
            },
          ),
        ],
      ),
    );
  }

  changeLanguage() {
    _appPreferences.changeAppLanguage();
    // restart app
    Phoenix.rebirth(context);
  }

  _logout() {
    // app pref make that user logged out
    _appPreferences.logout();
    // clear cache of logged out user
    _localDataSource.clearCache();
    // navigate to login screen
    Navigator.pushReplacementNamed(context, Routes.loginRoute);
  }

  Widget _getSettingWadget(String title, IconData leading, Function onTap) {
    return ListTile(
      leading: Icon(leading, color: ColorManager.primary),
      // SvgPicture.asset(ImageAssets.changeLangIc),
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      trailing: Icon(Icons.arrow_right_rounded, color: ColorManager.primary),
      //SvgPicture.asset(ImageAssets.rightArrowSettingsIc),
      onTap: onTap(),
    );
  }
}
