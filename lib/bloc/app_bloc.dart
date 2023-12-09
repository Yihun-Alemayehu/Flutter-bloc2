import 'package:bloc_notes/api/login_api.dart';
import 'package:bloc_notes/api/notes_api.dart';
import 'package:bloc_notes/bloc/actions.dart';
import 'package:bloc_notes/bloc/app_state.dart';
import 'package:bloc_notes/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginApiProtocol loginApi;
  final NotesApiProtocol notesApi;
  AppBloc({
    required this.loginApi,
    required this.notesApi,
  }) : super(const AppState.empty()) {
    on<LoginAction>(
      (event, emit) => () async {
        // Start loading
        emit(
          const AppState(
            isLoading: true,
            loginError: null,
            loginHandle: null,
            fetchedNotes: null,
          ),
        );

        // Log the user in
        final loginHandle = await loginApi.login(
          email: event.email,
          password: event.password,
        );

        emit(
          AppState(
            isLoading: false,
            loginError: loginHandle == null ? LogInErrors.invalidHandle : null,
            loginHandle: loginHandle,
            fetchedNotes: null,
          ),
        );
      },
    );
    on<LoadNotesAction>(
      (event, emit) => () async {
        emit(
          AppState(
            isLoading: true,
            loginError: null,
            loginHandle: state.loginHandle,
            fetchedNotes: null,
          ),
        );

        // get the loginHandle
        final loginHandle = state.loginHandle;
        if (loginHandle != const LogInHandle.yize()) {
          //Invalid login, can't fetch notes
          emit(
            AppState(
              isLoading: false,
              loginError: LogInErrors.invalidHandle,
              loginHandle: loginHandle,
              fetchedNotes: null,
            ),
          );
          return;
        }
        // valid login handle
        final notes = await notesApi.getNotes(
          loginHandle: loginHandle!,
        );
        emit(
            AppState(
              isLoading: false,
              loginError: null,
              loginHandle: loginHandle,
              fetchedNotes: notes,
            ),
          );
      },
    );
  }
}
