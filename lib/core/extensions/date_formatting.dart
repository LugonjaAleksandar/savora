import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Formats a date as a short, localized day (e.g. "Oct 30, 2026").
String formatShortDate(BuildContext context, DateTime date) {
  return DateFormat.yMMMd(formattingLocale(Localizations.localeOf(context))).format(date);
}

/// The Serbian copy is Latin script, but `sr` alone formats dates in Cyrillic.
String formattingLocale(Locale locale) {
  final bool isSerbianWithoutScript = locale.languageCode == 'sr' && locale.scriptCode == null;
  return isSerbianWithoutScript ? 'sr_Latn' : locale.toString();
}
