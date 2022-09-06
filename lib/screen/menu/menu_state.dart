import 'package:equatable/equatable.dart';

abstract class MenuState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialMenuState extends MenuState {

  @override
  String toString() {
    return 'InitialMenuState{}';
  }
}

class GetPrefsSuccess extends MenuState{

  @override
  String toString() {
    return 'GetPrefsSuccess{}';
  }
}

class MenuLoading extends MenuState {

  @override
  String toString() => 'MenuLoading';
}
