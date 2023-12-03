import 'package:advanced_flutter_arabic/data/data_source/local_data_source.dart';
import 'package:advanced_flutter_arabic/domain/usecase/forgot_password_usecase.dart';
import 'package:advanced_flutter_arabic/domain/usecase/home_usecase.dart';
import 'package:advanced_flutter_arabic/domain/usecase/register_usecase.dart';
import 'package:advanced_flutter_arabic/presentation/forgot_password/viewmodel/forgot_passord_viewmode.dart';
import 'package:advanced_flutter_arabic/presentation/main/pages/home/viewmodel/home_viewmodel.dart';
import 'package:advanced_flutter_arabic/presentation/register/view_model/register_viewmodel.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/data_source/remote_data_source.dart';
import '../data/network/app_api.dart';
import '../data/network/dio_factory.dart';
import '../data/network/network_info.dart';
import '../data/repository/repository_impl.dart';
import '../domain/repository/repository.dart';
import '../domain/usecase/login_usecase.dart';
import '../presentation/login/viewmodel/login_viewmodel.dart';
import 'app_prefs.dart';

final instance = GetIt.instance;

Future<void> initAppModule() async {
  // app module, its a module where we put all generic dependencies

  final sharedPreferences = await SharedPreferences.getInstance();
  // shared prefs
  instance.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
// app prefs instance
  instance
      .registerLazySingleton<AppPreferences>(() => AppPreferences(instance()));

// Network info
  instance.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(InternetConnectionChecker()));
// dio factory
  instance.registerLazySingleton<DioFactory>(() => DioFactory(instance()));

  final Dio dio = await instance<DioFactory>().getDio();
  //app service client
  instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));
// remote data source
  instance.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(instance()));

// local data source
  instance.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl());
  
// repository
  instance.registerLazySingleton<Repository>(
      () => RepositoryImpl(instance(), instance(), instance()));
}

// login module di
initLoginModule() {
  // is not Registered in GetIt -> then do it => (!)
  if (!GetIt.I.isRegistered<LoginUseCase>()) {
    instance.registerFactory<LoginUseCase>(() => LoginUseCase(instance()));
    instance.registerFactory<LoginViewModel>(() => LoginViewModel(instance()));
  }
}

// register module di
initRegisterModule() {
  // is not Registered in GetIt -> then do it => (!)
  if (!GetIt.I.isRegistered<RegisterUseCase>()) {
    instance
        .registerFactory<RegisterUseCase>(() => RegisterUseCase(instance()));
    instance.registerFactory<RegisterViewModel>(
        () => RegisterViewModel(instance()));
    instance.registerFactory<ImagePicker>(() => ImagePicker());
  }
}

// forgotPassword module di
initForgotPasswordModule() {
  // is not Registered in GetIt -> then do it => (!)
  if (!GetIt.I.isRegistered<ForgotPasswordUseCase>()) {
    instance.registerFactory<ForgotPasswordUseCase>(
        () => ForgotPasswordUseCase(instance()));
    instance.registerFactory<ForgotPasswordViewModel>(
        () => ForgotPasswordViewModel(instance()));
  }
}

// home module di
initHomeModule() {
  // is not Registered in GetIt -> then do it => (!)
  if (!GetIt.I.isRegistered<HomeUseCase>()) {
    instance.registerFactory<HomeUseCase>(() => HomeUseCase(instance()));
    instance.registerFactory<HomeViewModel>(() => HomeViewModel(instance()));
  }
}
