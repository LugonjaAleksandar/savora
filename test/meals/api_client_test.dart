import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:savora/core/network/api_client.dart';
import 'package:savora/core/network/app_failure.dart';
import 'package:savora/core/network/result.dart';

void main() {
  ApiClient clientReturning(Future<http.Response> Function(http.Request request) handler) {
    return ApiClient(httpClient: MockClient(handler), baseUrl: 'https://example.com/api');
  }

  String? parseName(Map<String, dynamic> json) => json['name'] as String?;

  test('builds the URL and parses a JSON object', () async {
    late Uri requested;
    final ApiClient client = clientReturning((http.Request request) async {
      requested = request.url;
      return http.Response('{"name":"Savora"}', 200);
    });

    final Result<String?> result = await client.get('/search.php', query: <String, String>{'s': 'pie'}, parser: parseName);

    expect(requested.toString(), 'https://example.com/api/search.php?s=pie');
    expect(result, isA<Success<String?>>().having((Success<String?> s) => s.data, 'data', 'Savora'));
  });

  test('maps status codes and transport errors to typed failures', () async {
    Future<AppFailure> failureFor(Future<http.Response> Function(http.Request request) handler) async {
      final Result<String?> result = await clientReturning(handler).get('/x', parser: parseName);
      return (result as Failure<String?>).failure;
    }

    expect(await failureFor((_) async => http.Response('', 404)), isA<NotFoundFailure>());
    expect(await failureFor((_) async => http.Response('', 503)), isA<ServerFailure>());
    expect(await failureFor((_) async => http.Response('not json', 200)), isA<ParsingFailure>());
    expect(await failureFor((_) async => throw const SocketException('offline')), isA<NetworkFailure>());
  });
}
