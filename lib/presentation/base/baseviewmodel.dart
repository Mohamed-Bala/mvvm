import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../common/state_renderer/state_renderer_impl.dart';

abstract class BaseViewModel extends BaseViewModelInputs
    with BaseViewModelOutputs {
  // shared variables and function that will be used through any view model.

  final StreamController inputStateStreamController =
      BehaviorSubject<FlowState>();

  @override
  Sink get inputState => inputStateStreamController.sink;
  @override
  Stream<FlowState> get outputState =>
      inputStateStreamController.stream.map((flowState) => flowState);

  @override
  void dispose() {
    inputStateStreamController.close();
  }
}

abstract class BaseViewModelInputs {
  void start(); // start view model job

  void dispose(); // will be called when view model dies
  
  Sink get inputState;
}

abstract class BaseViewModelOutputs {
  // will be implemented later

  Stream<FlowState> get outputState;
}
