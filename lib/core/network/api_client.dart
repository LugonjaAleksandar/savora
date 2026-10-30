import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:savora/core/network/app_failure.dart';
import 'package:savora/core/network/result.dart';

typedef JsonParser<T> = T Function(Map<String, dynamic> json);

/// Thin HTTP wrapper: builds URLs, decodes JSON and maps every failure mode
/// to an [AppFailure]. The [http.Client] is injected so tests can swap it
/// for a `MockClient`.
class ApiClient {
  static const Duration defaultTimeout = Duration(seconds: 15);

  final http.Client _httpClient;
  final Uri _baseUri;
  final Duration _timeout;

  ApiClient({required this._httpClient, required String baseUrl, this._timeout = defaultTimeout}) : _baseUri = Uri.parse(baseUrl);

  Future<Result<T>> get<T>(String path, {Map<String, String>? query, required JsonParser<T> parser}) async {
    final Uri uri = _baseUri.replace(path: '${_baseUri.path}$path', queryParameters: query);
    try {
      final http.Response response = await _httpClient.get(uri).timeout(_timeout);
      if (response.statusCode == HttpStatus.notFound) {
        return const Failure<Never>(NotFoundFailure());
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return Failure<T>(ServerFailure(response.statusCode));
      }
      final Object? decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is! Map<String, dynamic>) {
        return Failure<T>(ParsingFailure(FormatException('Expected a JSON object', response.body)));
      }
      return Success<T>(parser(decoded));
    } on SocketException {
      return const Failure<Never>(NetworkFailure());
    } on TimeoutException {
      return const Failure<Never>(NetworkFailure());
    } on http.ClientException {
      return const Failure<Never>(NetworkFailure());
    } on FormatException catch (error) {
      return Failure<T>(ParsingFailure(error));
    } on TypeError catch (error, stackTrace) {
      developer.log('Unexpected payload shape for $uri', error: error, stackTrace: stackTrace, name: 'ApiClient');
      return Failure<T>(ParsingFailure(error));
    } catch (error, stackTrace) {
      developer.log('Request to $uri failed', error: error, stackTrace: stackTrace, name: 'ApiClient');
      return Failure<T>(UnknownFailure(error));
    }
  }
}
