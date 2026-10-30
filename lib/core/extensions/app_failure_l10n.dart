import 'package:flutter/widgets.dart';
import 'package:savora/core/network/app_failure.dart';
import 'package:savora/localization.dart';

extension AppFailureL10n on AppFailure {
  String localizedMessage(BuildContext context) {
    return switch (this) {
      NetworkFailure() => AppLocalizations.of(context)!.error_network,
      ServerFailure() => AppLocalizations.of(context)!.error_server,
      NotFoundFailure() => AppLocalizations.of(context)!.error_not_found,
      ParsingFailure() || UnknownFailure() => AppLocalizations.of(context)!.error_unknown,
    };
  }
}
