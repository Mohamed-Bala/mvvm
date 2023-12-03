import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/app_prefs.dart';
import '../../../app/constants.dart';
import '../../../app/di.dart';
import '../../common/state_renderer/state_renderer_impl.dart';
import '../../resources/assets_manager.dart';
import '../../resources/color_manager.dart';
import '../../resources/routes_manager.dart';
import '../../resources/strings_manager.dart';
import '../../resources/values_manager.dart';
import '../view_model/register_viewmodel.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _userNmaeController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final RegisterViewModel _viewModel = instance<RegisterViewModel>();
  final ImagePicker _imagePicker = instance<ImagePicker>();
  final AppPreferences _appPreferences = instance<AppPreferences>();

  _bind() {
    _viewModel.start();
    _userNmaeController
        .addListener(() => _viewModel.setUserName(_userNmaeController.text));
    _mobileNumberController.addListener(
        () => _viewModel.setMobileNumber(_mobileNumberController.text));
    _emailController
        .addListener(() => _viewModel.setEmail(_emailController.text));
    _passwordController
        .addListener(() => _viewModel.setPassword(_passwordController.text));

    _viewModel.isUserRegisterdSuccessfullyStreamController.stream
        .listen((isRegisterd) {
      if (isRegisterd) {
        // Navigator to main Screen
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _appPreferences.setUserLoggedIn();
          Navigator.of(context).pushReplacementNamed(Routes.mainRoute);
        });
      }
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
      appBar: AppBar(
        backgroundColor: ColorManager.white,
        elevation: AppSize.s0,
        iconTheme: IconThemeData(color: ColorManager.primary),
      ),
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
      padding: const EdgeInsets.only(top: AppPadding.p28),
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
              const SizedBox(height: AppSize.s18),
              Padding(
                padding: const EdgeInsets.only(
                  left: AppPadding.p28,
                  right: AppPadding.p28,
                ),
                child: StreamBuilder<String?>(
                    stream: _viewModel.outputsErrorUserName,
                    builder: (context, snapshot) {
                      return TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _userNmaeController,
                        // focusNode: _userFocusNode,
                        // onEditingComplete: () => FocusScope.of(context)
                        //     .requestFocus(_passwordFocusNode),
                        //  textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: AppStrings.username.tr(),
                          labelText: AppStrings.username.tr(),
                          errorText: snapshot.data,
                        ),
                      );
                    }),
              ),
              const SizedBox(height: AppSize.s18),

              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: AppPadding.p28,
                    right: AppPadding.p28,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: CountryCodePicker(
                          initialSelection: '+249',
                          favorite: const ['+39', 'FR', "+966"],

                          // optional. Shows only country name and flag
                          showCountryOnly: true,
                          hideMainText: true,
                          // optional. Shows only country name and flag when popup is closed.
                          showOnlyCountryWhenClosed: true,
                          onChanged: ((countryCode) {
                            _viewModel.setCountryCode(
                                countryCode.dialCode ?? Constants.token);
                          }),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: StreamBuilder<String?>(
                            stream: _viewModel.outputsErrorMobileNumber,
                            builder: (context, snapshot) {
                              return TextFormField(
                                keyboardType: TextInputType.phone,
                                controller: _mobileNumberController,
                                // focusNode: _userFocusNode,
                                // onEditingComplete: () => FocusScope.of(context)
                                //     .requestFocus(_passwordFocusNode),
                                //  textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  hintText: AppStrings.mobileNumber.tr(),
                                  labelText: AppStrings.mobileNumber.tr(),
                                  errorText: snapshot.data,
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(
              //     left: AppPadding.p28,
              //     right: AppPadding.p28,
              //   ),
              //   child:
              // ),
              const SizedBox(height: AppSize.s18),
              Padding(
                padding: const EdgeInsets.only(
                  left: AppPadding.p28,
                  right: AppPadding.p28,
                ),
                child: StreamBuilder<String?>(
                    stream: _viewModel.outputsErrorEmail,
                    builder: (context, snapshot) {
                      return TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        // focusNode: _userFocusNode,
                        // onEditingComplete: () => FocusScope.of(context)
                        //     .requestFocus(_passwordFocusNode),
                        //  textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: AppStrings.email.tr(),
                          labelText: AppStrings.email.tr(),
                          errorText: snapshot.data,
                        ),
                      );
                    }),
              ),
              const SizedBox(height: AppSize.s18),
              Padding(
                padding: const EdgeInsets.only(
                  left: AppPadding.p28,
                  right: AppPadding.p28,
                ),
                child: StreamBuilder<String?>(
                    stream: _viewModel.outputsErrorPassword,
                    builder: (context, snapshot) {
                      return TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        controller: _passwordController,
                        //  focusNode: _passwordFocusNode,
                        decoration: InputDecoration(
                          hintText: AppStrings.password.tr(),
                          labelText: AppStrings.password.tr(),
                          errorText: snapshot.data,
                        ),
                      );
                    }),
              ),
              const SizedBox(height: AppSize.s18),

              Padding(
                padding: const EdgeInsets.only(
                  left: AppPadding.p28,
                  right: AppPadding.p28,
                ),
                child: Container(
                  height: AppSize.s40,
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.all(Radius.circular(AppSize.s8)),
                    border: Border.all(color: ColorManager.grey),
                  ),
                  child: GestureDetector(
                    child: _getMediaWidget(),
                    onTap: () {
                      _showPicker(context);
                    },
                  ),
                ),
              ),

              const SizedBox(height: AppSize.s40),
              Padding(
                padding: const EdgeInsets.only(
                  left: AppPadding.p28,
                  right: AppPadding.p28,
                ),
                child: StreamBuilder<bool>(
                    stream: _viewModel.outputsAreAllInputValid,
                    builder: (context, snapshot) {
                      return SizedBox(
                        width: double.infinity,
                        height: AppSize.s50,
                        child: ElevatedButton(
                          onPressed: (snapshot.data ?? false)
                              ? () {
                                  _viewModel.register();
                                }
                              : null,
                          child: const Text(AppStrings.register).tr(),
                        ),
                      );
                    }),
              ),
              const SizedBox(height: AppSize.s50),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  AppStrings.alreadyHaveAccount.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//-------
  _showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
              child: Wrap(
            children: [
              ListTile(
                trailing: const Icon(Icons.arrow_forward),
                leading: const Icon(Icons.camera),
                title: const Text(AppStrings.photoGallery).tr(),
                onTap: () {
                  _imageFromGallery();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                trailing: const Icon(Icons.arrow_forward),
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text(AppStrings.photoCamera).tr(),
                onTap: () {
                  _imageFromCamera();
                  Navigator.of(context).pop();
                },
              )
            ],
          ));
        });
  }

  //--------

  _imageFromGallery() async {
    var image = await _imagePicker.pickImage(source: ImageSource.gallery);
    _viewModel.setProfilePicture(File(image?.path ?? ""));
  }

  _imageFromCamera() async {
    var image = await _imagePicker.pickImage(source: ImageSource.camera);
    _viewModel.setProfilePicture(File(image?.path ?? ""));
  }

  //------

  Widget _getMediaWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: AppPadding.p8, right: AppPadding.p8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           Flexible(child: Text(AppStrings.profilePicture.tr())),
          Flexible(
            child: StreamBuilder<File>(
              stream: _viewModel.outputProfilePicture,
              builder: (context, snapshot) {
                return _imagePicketByUser(snapshot.data);
              },
            ),
          ),
          Flexible(child: SvgPicture.asset(ImageAssets.photoCameraIc))
        ],
      ),
    );
  }

  //---------
  Widget _imagePicketByUser(File? image) {
    if (image != null && image.path.isNotEmpty) {
      // return image
      return Image.file(image);
    } else {
      return Container();
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
