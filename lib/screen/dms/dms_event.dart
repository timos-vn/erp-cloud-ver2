import 'package:equatable/equatable.dart';

abstract class DMSEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetPrefs extends DMSEvent {
  @override
  String toString() => 'GetPrefs';
}

