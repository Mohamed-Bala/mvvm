import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../app/constants.dart';
import '../../resources/strings_manager.dart';
import 'state_renderer.dart';

abstract class FlowState {
  StateRendererType getStateRendererType();
  String getMessage();
}

// loading state (POPUP,FULL SCREEN)

class LoadingState extends FlowState {
  StateRendererType stateRendererType;
  String? message;
  LoadingState({
    required this.stateRendererType,
    String message = AppStrings.loading,
  });
  @override
  StateRendererType getStateRendererType() => stateRendererType;
  @override
  String getMessage() => message ?? AppStrings.loading.tr();
}

// Success State  (POPUP)

class SuccessState extends FlowState {
  String message;
  SuccessState(this.message);
  @override
  StateRendererType getStateRendererType() =>
      StateRendererType.popupSuccessState;
  @override
  String getMessage() => message;
}

class ErrorState extends FlowState {
  StateRendererType stateRendererType;
  String message;
  ErrorState(this.stateRendererType, this.message);
  @override
  StateRendererType getStateRendererType() => stateRendererType;
  @override
  String getMessage() => message;
}

// content state

class ContentState extends FlowState {
  ContentState();
  @override
  StateRendererType getStateRendererType() => StateRendererType.contentState;
  @override
  String getMessage() => Constants.empty;
}

// empty state

class EmptyState extends FlowState {
  String message;

  EmptyState(this.message);
  @override
  StateRendererType getStateRendererType() =>
      StateRendererType.fullScreenEmptyState;
  @override
  String getMessage() => message;
}

extension FlowStateExtension on FlowState {
  Widget getScreenWidget(BuildContext context, Widget contentScreenWidget,
      Function retryActionFunction) {
    switch (runtimeType) {
      case LoadingState:
        if (getStateRendererType() == StateRendererType.popupLoadingState) {
          // show popup loading
          showPopup(context, getStateRendererType(), getMessage());
          // show content ui of the screen
          return contentScreenWidget;
        } else {
          // full screen loading state
          return StateRenderer(
            stateRendererType: getStateRendererType(),
            message: getMessage(),
            retryActionFunction: retryActionFunction,
          );
        }
      case ErrorState:
        dismissDialog(context);
        if (getStateRendererType() == StateRendererType.popupErrorState) {
          // show popup error
          showPopup(context, getStateRendererType(), getMessage());
          // show content ui of the screen
          return contentScreenWidget;
        } else {
          // full screen error state
          return StateRenderer(
            stateRendererType: getStateRendererType(),
            message: getMessage(),
            retryActionFunction: retryActionFunction,
          );
        }
      case SuccessState:
        dismissDialog(context);
        showPopup(
          context,
          StateRendererType.popupSuccessState,
          getMessage(),
          title: AppStrings.success,
        );
         return contentScreenWidget;
      case EmptyState:
        return StateRenderer(
          stateRendererType: getStateRendererType(),
          message: getMessage(),
          retryActionFunction: () {},
        );
      case ContentState:
        dismissDialog(context);
        return contentScreenWidget;

      default:
        dismissDialog(context);
        return contentScreenWidget;
    }
  }

  _isCurrentDialogShowing(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent != true;

// if some dialog is open, than close this dialog
  dismissDialog(BuildContext context) {
    if (_isCurrentDialogShowing(context)) {
      Navigator.of(context, rootNavigator: true).pop(true);
    }
  }

  showPopup(
      BuildContext context, StateRendererType stateRendererType, String message,
      {String title = Constants.empty}) {
    WidgetsBinding.instance.addPostFrameCallback((_) => showDialog(
          context: context,
          builder: (BuildContext context) => StateRenderer(
            stateRendererType: stateRendererType,
            message: message,
            title: title,
            retryActionFunction: () {},
          ),
        ));
  }
//==============================================================================
}
