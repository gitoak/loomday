# Result & AppError usage

- Prefer `Result<T, AppError>` for fallible operations; return `Result<Unit, AppError>` when no payload is needed (use the `unit` singleton).
- Throwing is reserved for truly unrecoverable programmer errors; otherwise map exceptions into `AppError` variants using `guard`.
- Barrel imports: `import 'package:loomday/core/types/types.dart';` and `import 'package:loomday/core/errors/errors.dart';`.

## Mapping errors

```dart
import 'package:loomday/core/errors/errors.dart';
import 'package:loomday/core/types/types.dart';

Future<Result<String, AppError>> loadUser() {
  return guard<String, AppError>(
    () async {
      // ... do work
      return 'ok';
    },
    (error, stackTrace) => NetworkError.serverError(
      cause: error,
      stackTrace: stackTrace,
    ),
    // pass logger if you want automatic logging; stays silent otherwise
    logger: null,
  );
}
```

## AsyncValue interop

```dart
AsyncValue<User> state = result.toAsyncValue(mapError: (e) => e);

Result<User, AppError> result = state.toResult(
  (error, stack) => ValidationError(
    fieldErrors: <String, String>{'message': error.toString()},
    stackTrace: stack,
  ),
);
```

## Validation errors

- Use `ValidationError` for field-level issues (e.g., bad routes, bad input) instead of `ArgumentError`.
- Populate `fieldErrors` with the offending field/value for diagnostics.