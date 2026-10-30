/// Typed failures produced by the data layer.
///
/// The UI never sees raw exceptions or HTTP reason phrases — it pattern-matches
/// on these (see `AppFailureL10n`) to pick localized copy.
sealed class AppFailure {
  const AppFailure();
}

final class NetworkFailure extends AppFailure {
  const NetworkFailure();
}

final class ServerFailure extends AppFailure {
  final int statusCode;

  const ServerFailure(this.statusCode);
}

final class NotFoundFailure extends AppFailure {
  const NotFoundFailure();
}

final class ParsingFailure extends AppFailure {
  final Object error;

  const ParsingFailure(this.error);
}

final class UnknownFailure extends AppFailure {
  final Object error;

  const UnknownFailure(this.error);
}
