import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../app/di.dart';
import '../../common/state_renderer/state_renderer_impl.dart';
import '../../resources/assets_manager.dart';
import '../../resources/color_manager.dart';
import '../../resources/strings_manager.dart';
import '../../resources/values_manager.dart';
import '../viewmodel/forgot_passord_viewmode.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final ForgotPasswordViewModel _viewModel =
      instance<ForgotPasswordViewModel>();

  _bind() {
    _viewModel.start();
    _emailController.addListener(() {
      _viewModel.setEmail(_emailController.text);
    });
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
    return Container(
      constraints: const BoxConstraints.expand(),
      child: Padding(
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
                      stream: _viewModel.outputEmail,
                      builder: (context, snapshot) {
                        return TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: AppStrings.email.tr(),
                            labelText: AppStrings.email.tr(),
                            errorText: (snapshot.data ?? true)
                                ? null
                                : AppStrings.invalidEmail.tr(),
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
                      stream: _viewModel.outAreAllInputsValid,
                      builder: (context, snapshot) {
                        return SizedBox(
                          width: double.infinity,
                          height: AppSize.s50,
                          child: ElevatedButton(
                            onPressed: (snapshot.data ?? false)
                                ? () => _viewModel.resetEmail()
                                : null,
                            child: const Text(AppStrings.resetPassword).tr(),
                          ),
                        );
                      }),
                ),
                const SizedBox(height: AppSize.s30),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    AppStrings.emailText.tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
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
