import 'package:flutter/foundation.dart' show immutable;

@immutable
class LogInHandle {
  final String token;

  const LogInHandle({
    required this.token,
  });

  const LogInHandle.yize() : token = 'yize';

  @override
  bool operator ==(covariant LogInHandle other) => token == other.token;

  @override
  int get hashCode => token.hashCode;

  @override
  String toString() => 'LogInHandle (token = $token)';
}

enum LogInErrors { invalidHandle }

@immutable
class Note {
  final String title;

  const Note({
    required this.title,
  });

  @override
  String toString() => 'Note (title = $title)';
}

final mockNotes = Iterable.generate(
  3,
  (i) => Note(title: 'Note ${i + 1}'),
);
