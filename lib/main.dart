import 'package:bloc_notes/api/login_api.dart';
import 'package:bloc_notes/api/notes_api.dart';
import 'package:bloc_notes/bloc/actions.dart';
import 'package:bloc_notes/bloc/app_bloc.dart';
import 'package:bloc_notes/bloc/app_state.dart';
import 'package:bloc_notes/dialogs/generic_dialog.dart';
import 'package:bloc_notes/dialogs/loading_screen.dart';
import 'package:bloc_notes/models.dart';
import 'package:bloc_notes/strings.dart';
import 'package:bloc_notes/views/iterable_list_view.dart';
import 'package:bloc_notes/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    const MaterialApp(
      home: HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(
        loginApi: LoginApi(),
        notesApi: NotesApi(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(homePage),
          centerTitle: true,
        ),
        body: BlocConsumer<AppBloc, AppState>(
          builder: (context, appState) {
            final notes = appState.fetchedNotes;
            if (notes == null) {
              return LoginView((email, password) {
                context.read<AppBloc>().add(
                      LoginAction(
                        email: email,
                        password: password,
                      ),
                    );
              });
            } else {
              return notes.toListView();
            }
          },
          listener: (context, appState) {
            //loading Screen
            if (appState.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: pleaseWait,
              );
            } else {
              LoadingScreen.instance().hide();
            }

            // Display error
            final loginError = appState.loginError;
            if (loginError != null) {
              showGenericDialog(
                context: context,
                title: loginErrorDialogTitle,
                content: loginErrorDialogContent,
                optionsBuilder: () => {
                  ok: true,
                },
              );
            }

            // if we've no fetched note, but logged in
            if (appState.isLoading == false &&
                appState.loginError == null &&
                appState.loginHandle == const LogInHandle.yize() &&
                appState.fetchedNotes == null) {
              context.read<AppBloc>().add(
                    const LoadNotesAction(),
                  );
            }
          },
        ),
      ),
    );
  }
}
