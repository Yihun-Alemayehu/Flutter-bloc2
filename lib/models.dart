import 'package:flutter/foundation.dart' show immutable;

@immutable
class LogInHandle {
  final String token;

  const LogInHandle({
    required this.token,
  });
}
