import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialHomeState extends HomeState {

  @override
  String toString() {
    return 'InitialHomeState{}';
  }
}

class GetPrefsSuccess extends HomeState{

  @override
  String toString() {
    return 'GetPrefsSuccess{}';
  }
}

class DoNotPermissionViewState extends HomeState{

  @override
  String toString() {
    return 'DoNotPermissionViewState{}';
  }
}

class HomeLoading extends HomeState {

  @override
  String toString() => 'HomeLoading';
}
class HomeFailure extends HomeState {
  final String error;

  HomeFailure(this.error);

  @override
  String toString() => 'HomeFailure { error: $error }';
}
class GetDefaultDataSuccess extends HomeState {

  @override
  String toString() => 'GetDefaultDataSuccess {}';
}
class ChangeTimeValueSuccess extends HomeState {

  @override
  String toString() => 'ChangeTimeValueSuccess {}';
}

class GetDataSuccess extends HomeState {

  @override
  String toString() => 'GetDataSuccess {}';
}
