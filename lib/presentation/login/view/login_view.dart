import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/scheduler.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../common/state_renderer/state_renderer_impl.dart';
import 'package:flutter/material.dart';

import '../../resources/assets_manager.dart';
import '../../resources/color_manager.dart';
import '../../resources/routes_manager.dart';
import '../../resources/strings_manager.dart';
import '../../resources/values_manager.dart';
import '../viewmodel/login_viewmodel.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginViewModel _viewModel = instance<LoginViewModel>();
  final AppPreferences _appPreferences = instance<AppPreferences>();

  final TextEditingController _userNmaeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _userFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  _bind() {
    _viewModel.start();

    _userNmaeController
        .addListener(() => _viewModel.setUserName(_userNmaeController.text));
    _passwordController
        .addListener(() => _viewModel.setPassword(_passwordController.text));

    // _viewModel.isUserLoggedInSuccessfullyStreamController.stream
    //     .listen((isLoggedIn) {
    //   if (isLoggedIn) {
    //     // Navigator to main Screen
    //     SchedulerBinding.instance.addPostFrameCallback((_) {
    //       _appPreferences.setUserLoggedIn();
    //       Navigator.of(context).pushReplacementNamed(Routes.mainRoute);
    //     });
    //   }
    // });
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: StreamBuilder<FlowState>(
        stream: _viewModel.outputState,
        builder: ((context, snapshot) =>
            snapshot.data?.getScreenWidget(
              context,
              _getContentWidget(),
              () {},
            ) ??
            _getContentWidget()),
      ),
    );
  }

  Widget _getContentWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: AppSize.s100),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Center(
                child: Image(
                  image: AssetImage(ImageAssets.splashLogo),
                ),
              ),
              const SizedBox(height: AppSize.s28),
              Padding(
                padding: const EdgeInsets.only(
                  left: AppPadding.p28,
                  right: AppPadding.p28,
                ),
                child: StreamBuilder<bool>(
                    stream: _viewModel.outIsUserNameValid,
                    builder: (context, snapshot) {
                      return TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _userNmaeController,
                        focusNode: _userFocusNode,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_passwordFocusNode),
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: AppStrings.email.tr(),
                          labelText: AppStrings.email.tr(),
                          errorText: (snapshot.data ?? true)
                              ? null
                              : AppStrings.emailError.tr(),
                        ),
                      );
                    }),
              ),
              const SizedBox(height: AppSize.s28),
              Padding(
                padding: const EdgeInsets.only(
                  left: AppPadding.p28,
                  right: AppPadding.p28,
                ),
                child: StreamBuilder<bool>(
                    stream: _viewModel.outIsPasswordValid,
                    builder: (context, snapshot) {
                      return TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        decoration: InputDecoration(
                          hintText: AppStrings.password.tr(),
                          labelText: AppStrings.password.tr(),
                          errorText: (snapshot.data ?? true)
                              ? null
                              : AppStrings.passwordError.tr(),
                        ),
                      );
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: AppPadding.p8,
                  left: AppPadding.p28,
                  right: AppPadding.p28,
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        Routes.forgotPasswordRoute,
                      );
                    },
                    child: Text(
                      AppStrings.forgetPassword.tr(),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSize.s20),
              Padding(
                padding: const EdgeInsets.only(
                  left: AppPadding.p28,
                  right: AppPadding.p28,
                ),
                child: StreamBuilder<bool>(
                    stream: _viewModel.outAreAllInputsValid,
                    builder: (context, snapshot) {
                      return SizedBox(
                        width: double.infinity,
                        height: AppSize.s50,
                        child: ElevatedButton(
                          onPressed: (snapshot.data ?? false)
                              ? () {
                                  _viewModel.login();
                                }
                              : null,
                          child: const Text(AppStrings.login).tr(),
                        ),
                      );
                    }),
              ),
              const SizedBox(height: AppSize.s50),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    Routes.registerRoute,
                  );
                },
                child: Text(
                  AppStrings.registerText.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
