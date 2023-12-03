import 'dart:async';

import '../../../app/fuctions.dart';
import '../../../domain/usecase/forgot_password_usecase.dart';
import '../../base/baseviewmodel.dart';
import '../../common/state_renderer/state_renderer.dart';
import '../../common/state_renderer/state_renderer_impl.dart';

class ForgotPasswordViewModel extends BaseViewModel
    with ForgotPasswordViewModelInputs, ForgotPasswordViewModelOutputs {
  final StreamController _emailStreamController =
      StreamController<String>.broadcast();

  final StreamController _areAllInputsValidStremeController =
      StreamController<void>.broadcast();

  final ForgotPasswordUseCase _forgotPasswordUseCase;

  ForgotPasswordViewModel(this._forgotPasswordUseCase);

  var email = '';
  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  void dispose() {
    _emailStreamController.close();
    _areAllInputsValidStremeController.close();
  }

  @override
  setEmail(String email) {
    inputEmail.add(email);
    this.email = email;
    _validate();
  }

  @override
  Sink get inputEmail => _emailStreamController.sink;

  @override
  Sink get inputAreAllInputsValid => _areAllInputsValidStremeController.sink;

  @override
  Stream<bool> get outputEmail =>
      _emailStreamController.stream.map((email) => isEmailValid(email));

  @override
  Stream<bool> get outAreAllInputsValid =>
      _areAllInputsValidStremeController.stream
          .map((isAllInputValid) => _isAllInputValid());

  _isAllInputValid() {
    return isEmailValid(email);
  }

  _validate() {
    inputAreAllInputsValid.add(null);
  }

  @override
  resetEmail() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    (await _forgotPasswordUseCase.execute(email)).fold(
      (failure) => {
        inputState
            .add(ErrorState(StateRendererType.popupErrorState, failure.message))
      },
      (supportMessage) {
        // now show content
        inputState.add(SuccessState(supportMessage));
      },
    );
  }
}

abstract class ForgotPasswordViewModelInputs {
  setEmail(String email);
  resetEmail();

  Sink get inputEmail;
  Sink get inputAreAllInputsValid;
}

abstract class ForgotPasswordViewModelOutputs {
  Stream<bool> get outputEmail;
  Stream<bool> get outAreAllInputsValid;
}
