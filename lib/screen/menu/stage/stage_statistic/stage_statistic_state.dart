import 'package:equatable/equatable.dart';

abstract class StageStatisticState extends Equatable {
  @override
  List<Object> get props => [];
}

class StageStatisticInitial extends StageStatisticState {
  @override
  String toString() => 'StageStatisticInitial';
}
class StageStatisticLoading extends StageStatisticState {
  @override
  String toString() => 'StageStatisticLoading';
}

class StageStatisticFailure extends StageStatisticState {
  final String error;

  StageStatisticFailure(this.error);

  @override
  String toString() => 'StageStatisticFailure { error: $error }';
}

class GetListStageSuccess extends StageStatisticState{

  @override
  String toString() {
    return 'GetListStageSuccess';
  }
}

class GetListStageEmpty extends StageStatisticState {

  @override
  String toString() {
    return 'GetListStageEmpty{}';
  }
}

class GetPrefsSuccess extends StageStatisticState{

  @override
  String toString() {
    return 'GetPrefsSuccess{}';
  }
}