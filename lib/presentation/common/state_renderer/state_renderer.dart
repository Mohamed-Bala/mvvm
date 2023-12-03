import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../resources/assets_manager.dart';
import '../../resources/color_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/strings_manager.dart';
import '../../resources/styles_manager.dart';
import '../../resources/values_manager.dart';

enum StateRendererType {
  // POPUP STATES (DIALOG)
  popupLoadingState,
  popupErrorState,
  popupSuccessState,

  // FULL SCREEN STATED (FULL SCREEN)
  fullScreenLoadingState,
  fullScreenErrorState,
  fullScreenEmptyState,

  // general
  contentState
}

class StateRenderer extends StatelessWidget {
  StateRendererType stateRendererType;
  String message;
  String title;
  Function retryActionFunction;

  StateRenderer({
    Key? key,
    required this.stateRendererType,
    this.message = AppStrings.loading,
    this.title = '',
    required this.retryActionFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _getStateWidget(context);
  }

  Widget _getStateWidget(BuildContext context) {
    switch (stateRendererType) {
      case StateRendererType.popupLoadingState:
        return _getPopUpDialog(context, [
          _getAnimatedImage(JsonAssets.loading),
          _getMessage(message),
        ]);

      case StateRendererType.popupErrorState:
        return _getPopUpDialog(context, [
          _getAnimatedImage(JsonAssets.error),
          _getMessage(message),
          _getRetryButton(AppStrings.ok.tr(), context),
        ]);

      case StateRendererType.popupSuccessState:
        return _getPopUpDialog(context, [
          _getAnimatedImage(JsonAssets.success),
          _getMessage(AppStrings.success.tr()),
          _getMessage(message),
          _getRetryButton(AppStrings.ok.tr(), context),
        ]);

      case StateRendererType.fullScreenLoadingState:
        return _getItemsColumn([
          _getAnimatedImage(JsonAssets.loading),
          _getMessage(message),
        ]);
      case StateRendererType.fullScreenErrorState:
        return _getItemsColumn([
          _getAnimatedImage(JsonAssets.error),
          _getMessage(message),
          _getRetryButton(AppStrings.retryAgain.tr(), context),
        ]);

      case StateRendererType.fullScreenEmptyState:
        return _getItemsColumn([
          _getAnimatedImage(JsonAssets.empty),
          _getMessage(message),
        ]);
      case StateRendererType.contentState:
        return Container();

      default:
        return Container();
    }
  }

//*****************************************************************************/
  Widget _getPopUpDialog(BuildContext context, List<Widget> children) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s14),
      ),
      elevation: AppSize.s1_5,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: ColorManager.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(AppSize.s14),
          boxShadow: const [BoxShadow(color: Colors.black26)],
        ),
        child: _getDialogContent(context, children),
      ),
    );
  }

  Widget _getDialogContent(BuildContext context, List<Widget> children) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

//*****************************************************************************/

  Widget _getItemsColumn(List<Widget> children) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

//*****************************************************************************/
  Widget _getAnimatedImage(String animatedNmae) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: AppPadding.p8),
        child: SizedBox(
          height: AppSize.s100,
          width: AppSize.s100,
          child: Lottie.asset(animatedNmae),
        ),
      ),
    );
  }

//*****************************************************************************/
  Widget _getMessage(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p28),
        child: Text(
          message,
          style: getRegularStyle(
              color: ColorManager.black, fontSize: FontSize.s14),
        ),
      ),
    );
  }

//*****************************************************************************/
  Widget _getRetryButton(String buttonTitel, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p8),
        child: SizedBox(
          width: double.infinity,
          height: AppSize.s50,
          child: ElevatedButton(
            onPressed: () {
              if (stateRendererType == StateRendererType.fullScreenErrorState) {
                retryActionFunction.call();
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Text(buttonTitel),
          ),
        ),
      ),
    );
  }
}
