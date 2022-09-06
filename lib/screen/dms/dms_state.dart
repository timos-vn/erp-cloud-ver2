import 'package:equatable/equatable.dart';

abstract class DMSState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialDMSState extends DMSState {

  @override
  String toString() {
    return 'InitialDMSState{}';
  }
}

class GetPrefsSuccess extends DMSState{

  @override
  String toString() {
    return 'GetPrefsSuccess{}';
  }
}

class DMSLoading extends DMSState {

  @override
  String toString() => 'DMSLoading';
}
