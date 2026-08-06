// Project imports:
import 'package:worth_loop/shared/utils/fetch_result.value-object.dart';

/// Builds a [FetchResult] with overridable values.
FetchResult buildFetchResult({int? statusCode = 200, String body = ''}) =>
    FetchResult(statusCode: statusCode, body: body);
