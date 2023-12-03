import 'dart:async';
import 'dart:ffi';

import 'package:rxdart/rxdart.dart';

import '../../../../../domain/model/models.dart';
import '../../../../../domain/usecase/home_usecase.dart';
import '../../../../base/baseviewmodel.dart';
import '../../../../common/state_renderer/state_renderer.dart';
import '../../../../common/state_renderer/state_renderer_impl.dart';

class HomeViewModel extends BaseViewModel
    with HomeViewModelInputs, HomeViewModelOutputs {
  final StreamController _homeDataStreamController =
      BehaviorSubject<HomeViewObject>();

  final HomeUseCase _homeUseCase;
  HomeViewModel(this._homeUseCase);

//----- Inputs
  @override
  void start() {
    _getHomeData();
  }

  _getHomeData() async {
    inputState.add(LoadingState(
      stateRendererType: StateRendererType.fullScreenLoadingState,
    ));

    // ignore: void_checks
    (await _homeUseCase.execute(Void)).fold(
      (failure) => {
        inputState.add(
            ErrorState(StateRendererType.fullScreenErrorState, failure.message))
      },
      (data) {
        // now show content
        inputState.add(ContentState());
        inputHomeData.add(HomeViewObject(data.data.stores, data.data.service, data.data.banners));
      },
    );
  }

  @override
  void dispose() {
    _homeDataStreamController.close();

    super.dispose();
  }

  @override
  Sink get inputHomeData => _homeDataStreamController.sink;

  //---- outpus

  @override
  Stream<HomeViewObject> get outputHomeData =>
      _homeDataStreamController.stream.map((data) => data);
}

abstract class HomeViewModelInputs {
  Sink get inputHomeData;
}

abstract class HomeViewModelOutputs {
  Stream<HomeViewObject> get outputHomeData;
}

 class HomeViewObject {
  List<Stores> stores;
  List<Service> service;
  List<BannerAd> banners;

  HomeViewObject(this.stores, this.service, this.banners);
}
