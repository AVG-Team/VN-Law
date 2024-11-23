import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class FetchUserEvent extends UserEvent {
  final String userId;

  const FetchUserEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}