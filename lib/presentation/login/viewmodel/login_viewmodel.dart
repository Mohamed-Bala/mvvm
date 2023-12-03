import 'dart:async';

import '../../../domain/usecase/login_usecase.dart';
import '../../base/baseviewmodel.dart';
import '../../common/freezed_data_classes.dart';
import '../../common/state_renderer/state_renderer.dart';
import '../../common/state_renderer/state_renderer_impl.dart';

class LoginViewModel extends BaseViewModel
    with LoginViewModelInputs, LoginViewModelOutputs {
  final StreamController _userNameStremeController =
      StreamController<String>.broadcast();
  final StreamController _passwordStremeController =
      StreamController<String>.broadcast();

  final StreamController _areAllInputsValidStremeController =
      StreamController<void>.broadcast();

  final StreamController isUserLoggedInSuccessfullyStreamController =
      StreamController<bool>();

  var loginObject = LoginObject('', '');
  final LoginUseCase _loginUseCase;
  LoginViewModel(this._loginUseCase);
  //----- Inputs ----------------

  @override
  void start() {
    // show content
    inputState.add(ContentState());
  }

  @override
  void dispose() {
    super.dispose();
    _userNameStremeController.close();
    _passwordStremeController.close();
    _areAllInputsValidStremeController.close();
    isUserLoggedInSuccessfullyStreamController.close();
  }

  @override
  Sink get inputUserName => _userNameStremeController.sink;

  @override
  Sink get inputPassword => _passwordStremeController.sink;

  @override
  Sink get inputAreAllInputsValid => _areAllInputsValidStremeController.sink;

  @override
  setUserName(String userName) {
    inputUserName.add(userName);
    loginObject = loginObject.copyWith(userName: userName);
    inputAreAllInputsValid.add(null);
  }

  @override
  setPassword(String password) {
    // pass data to sink
    inputPassword.add(password);
    // update data all time
    loginObject = loginObject.copyWith(password: password);
    inputAreAllInputsValid.add(null);
  }

  @override
  login() async {
    inputState.add(LoadingState(
      stateRendererType: StateRendererType.popupLoadingState,
    ));

    (await _loginUseCase.execute(
            LoginUseCaseInput(loginObject.userName, loginObject.password)))
        .fold(
      (failure) => {
        inputState
            .add(ErrorState(StateRendererType.popupErrorState, failure.message))
      },
      (data) {
       
        // now show content
        inputState.add(ContentState());

        // navigate to main Screen
      //  isUserLoggedInSuccessfullyStreamController.add(true);
      },
    );
  }

  //------ Outputs -----------------
  @override
  Stream<bool> get outIsPasswordValid => _passwordStremeController.stream
      .map((password) => _isPasswordValid(password));

  @override
  Stream<bool> get outIsUserNameValid => _userNameStremeController.stream
      .map((userName) => _isUserNameValid(userName));

  @override
  Stream<bool> get outAreAllInputsValid =>
      _areAllInputsValidStremeController.stream.map((_) => _allInputsValid());

//--- Privet Fuction -------
  bool _isPasswordValid(String password) {
    return password.isNotEmpty;
  }

  bool _isUserNameValid(String userName) {
    return userName.isNotEmpty;
  }

  bool _allInputsValid() {
    return _isUserNameValid(loginObject.userName) &&
        _isPasswordValid(loginObject.password);
  }
}

abstract class LoginViewModelInputs {
  setUserName(String userName);

  setPassword(String password);

  login();

  Sink get inputUserName;

  Sink get inputPassword;

  Sink get inputAreAllInputsValid;
}

abstract class LoginViewModelOutputs {
  Stream<bool> get outIsUserNameValid;

  Stream<bool> get outIsPasswordValid;

  Stream<bool> get outAreAllInputsValid;
}
