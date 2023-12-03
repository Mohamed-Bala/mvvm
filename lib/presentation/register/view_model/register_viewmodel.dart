import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';

import '../../../app/fuctions.dart';
import '../../../domain/usecase/register_usecase.dart';
import '../../base/baseviewmodel.dart';
import '../../common/freezed_data_classes.dart';
import '../../common/state_renderer/state_renderer.dart';
import '../../common/state_renderer/state_renderer_impl.dart';
import '../../resources/strings_manager.dart';

class RegisterViewModel extends BaseViewModel
    with RegisterViewModelInputs, RegisterViewModelOutputs {
  final StreamController _userNameStremeController =
      StreamController<String>.broadcast();
  final StreamController _mobileNumberStremeController =
      StreamController<String>.broadcast();
  final StreamController _emailStremeController =
      StreamController<String>.broadcast();

  final StreamController _passwordStremeController =
      StreamController<String>.broadcast();
  final StreamController _profilePictureStremeController =
      StreamController<File>.broadcast();
  final StreamController _areAllInputsValidStremeController =
      StreamController<void>.broadcast();
  final StreamController isUserRegisterdSuccessfullyStreamController =
      StreamController<bool>();

  var registerObject = RegisterObject('', '', '', '', '', '');
  final RegisterUseCase _registerUseCase;
  RegisterViewModel(this._registerUseCase);
  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  void dispose() {
    _userNameStremeController.close();
    _mobileNumberStremeController.close();
    _emailStremeController.close();
    _passwordStremeController.close();
    _profilePictureStremeController.close();
    _areAllInputsValidStremeController.close();
    isUserRegisterdSuccessfullyStreamController.close();
    super.dispose();
  }

  // -- Inpots
  @override
  Sink get inputUserName => _userNameStremeController.sink;

  @override
  Sink get inputMobileNumber => _mobileNumberStremeController.sink;

  @override
  Sink get inputEmail => _emailStremeController.sink;

  @override
  Sink get inputPassword => _passwordStremeController.sink;

  @override
  Sink get inputProfilePicture => _profilePictureStremeController.sink;

  @override
  Sink get inputAllInputVaild => _areAllInputsValidStremeController.sink;

  @override
  register() async {
    inputState.add(LoadingState(
        stateRendererType: StateRendererType.popupLoadingState,
       ));

    (await _registerUseCase.execute(RegisterUseCaseInput(
            registerObject.userName,
            registerObject.countryMobileCode,
            registerObject.mobileNumber,
            registerObject.email,
            registerObject.password,
            registerObject.profilePicture)))
        .fold(
      (failure) => {
        inputState
            .add(ErrorState(StateRendererType.popupErrorState, failure.message))
      },
      (data) {
        // now show content
        inputState.add(ContentState());

        // navigate to main Screen
       isUserRegisterdSuccessfullyStreamController.add(true);
      },
    );
  }

  @override
  setUserName(String userName) {
    inputUserName.add(userName);
    if (_isUserNameValid(userName)) {
      //  update register view object
      registerObject = registerObject.copyWith(userName: userName);
    } else {
      // reset username value in register view object
      registerObject = registerObject.copyWith(userName: '');
    }
    validate();
  }

  @override
  setCountryCode(String countryCode) {
    if (countryCode.isNotEmpty) {
      //  update register view object
      registerObject = registerObject.copyWith(countryMobileCode: countryCode);
    } else {
      // reset countryCode value in register view object

      registerObject = registerObject.copyWith(countryMobileCode: '');
    }
    validate();
  }

  @override
  setMobileNumber(String mobileNumber) {
    inputMobileNumber.add(mobileNumber);
    if (_isMobileNumberValid(mobileNumber)) {
      //  update register view object
      registerObject = registerObject.copyWith(mobileNumber: mobileNumber);
    } else {
      // reset mobileNumber value in register view object

      registerObject = registerObject.copyWith(mobileNumber: '');
    }
    validate();
  }

  @override
  setEmail(String email) {
    inputEmail.add(email);
    if (isEmailValid(email)) {
      //  update register view object

      registerObject = registerObject.copyWith(email: email);
    } else {
      // reset email value in register view object

      registerObject = registerObject.copyWith(email: '');
    }
  }

  @override
  setPassword(String password) {
    inputPassword.add(password);
    if (_isPasswordValid(password)) {
      //  update register view object

      registerObject = registerObject.copyWith(password: password);
    } else {
      // reset password value in register view object

      registerObject = registerObject.copyWith(password: '');
    }
    validate();
  }

  @override
  setProfilePicture(File profilePicture) {
    inputProfilePicture.add(profilePicture);
    if (profilePicture.path.isNotEmpty) {
      //  update register view object

      registerObject =
          registerObject.copyWith(profilePicture: profilePicture.path);
    } else {
      // reset profilePicture value in register view object

      registerObject = registerObject.copyWith(profilePicture: '');
    }
    validate();
  }

  // -- Outputs

  @override
  Stream<bool> get outputsIsUserNameValid => _userNameStremeController.stream
      .map((userNmae) => _isUserNameValid(userNmae));

  @override
  Stream<String?> get outputsErrorUserName => outputsIsUserNameValid.map(
      (isUserNameValid) => isUserNameValid ? null : AppStrings.userNameInvalid.tr());

  @override
  Stream<bool> get outputsIsMobileNumberValid =>
      _mobileNumberStremeController.stream
          .map((mobileNumber) => _isMobileNumberValid(mobileNumber));

  @override
  Stream<String?> get outputsErrorMobileNumber =>
      outputsIsMobileNumberValid.map((isMobileNumberValid) =>
          isMobileNumberValid ? null : AppStrings.mobileNumberInvalid.tr());

  @override
  Stream<bool> get outputsIsEmailValid =>
      _emailStremeController.stream.map((email) => isEmailValid(email));

  @override
  Stream<String?> get outputsErrorEmail => outputsIsEmailValid
      .map((isEmailValid) => isEmailValid ? null : AppStrings.invalidEmail.tr());

  @override
  Stream<bool> get outputsIsPasswordValid => _passwordStremeController.stream
      .map((password) => _isPasswordValid(password));

  @override
  Stream<String?> get outputsErrorPassword => outputsIsPasswordValid.map(
      (isPasswordValid) => isPasswordValid ? null : AppStrings.passwordInvalid.tr());

  @override
  Stream<File> get outputProfilePicture =>
      _profilePictureStremeController.stream.map((file) => file);
  @override
  @override
  Stream<bool> get outputsAreAllInputValid =>
      _areAllInputsValidStremeController.stream.map((_) => _areAllInputValid());

//--- Privet Fuction -------
  bool _isUserNameValid(String userName) {
    return userName.length >= 8;
  }

  bool _isMobileNumberValid(String mobileNumber) {
    return mobileNumber.length >= 10;
  }

  bool _isPasswordValid(String password) {
    return password.length >= 6;
  }

  bool _areAllInputValid() {
    return registerObject.mobileNumber.isNotEmpty &&
        registerObject.countryMobileCode.isNotEmpty &&
        registerObject.userName.isNotEmpty &&
        registerObject.email.isNotEmpty &&
        registerObject.password.isNotEmpty &&
        registerObject.profilePicture.isNotEmpty;
  }

  validate() {
    inputAllInputVaild.add(null);
  }
}

abstract class RegisterViewModelInputs {
  Sink get inputUserName;

  Sink get inputMobileNumber;

  Sink get inputEmail;

  Sink get inputPassword;

  Sink get inputProfilePicture;

  Sink get inputAllInputVaild;

  register();

  setUserName(String userName);

  setCountryCode(String countryCode);

  setMobileNumber(String mobileNumber);

  setEmail(String email);

  setPassword(String password);

  setProfilePicture(File profilePicture);
}

abstract class RegisterViewModelOutputs {
  Stream<bool> get outputsIsUserNameValid;
  Stream<String?> get outputsErrorUserName;

  Stream<bool> get outputsIsMobileNumberValid;
  Stream<String?> get outputsErrorMobileNumber;

  Stream<bool> get outputsIsEmailValid;
  Stream<String?> get outputsErrorEmail;

  Stream<bool> get outputsIsPasswordValid;
  Stream<String?> get outputsErrorPassword;

  Stream<File> get outputProfilePicture;

  Stream<bool> get outputsAreAllInputValid;
}
