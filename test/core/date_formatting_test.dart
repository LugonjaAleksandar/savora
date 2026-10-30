import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:savora/core/extensions/date_formatting.dart';

void main() {
  setUpAll(initializeDateFormatting);

  test('Serbian dates use Latin script, like the copy', () {
    final String formatted = DateFormat.yMMMd(formattingLocale(const Locale('sr'))).format(DateTime(2026, 10, 30));

    expect(formatted, '30. okt 2026.');
  });

  test('other locales are left unchanged', () {
    expect(formattingLocale(const Locale('en')), 'en');
  });
}
