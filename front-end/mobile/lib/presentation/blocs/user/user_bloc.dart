import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_user.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUser _getUser;

  UserBloc(this._getUser) : super(UserInitial()) {
    on<FetchUserEvent>(_onFetchUser);
  }

  void _onFetchUser(FetchUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final user = await _getUser(event.userId);
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}