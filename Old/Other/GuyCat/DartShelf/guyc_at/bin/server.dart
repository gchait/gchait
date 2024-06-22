import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

Response _rootHandler(Request request) {
  return Response.ok('Hello, world!');
}

Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message');
}

Response _firstName(Request request) {
  return Response.ok('Guy');
}

Response _lastName(Request request) {
  return Response.ok('Chait');
}

final _router = Router()
  ..get('/', _rootHandler)
  ..get('/echo/<message>', _echoHandler)
  ..get('/name/first', _firstName)
  ..get('/name/last', _lastName);

void main(List<String> args) async {
  final ip = InternetAddress.anyIPv4;

  final handler =
      Pipeline().addMiddleware(logRequests()).addHandler(_router.call);

  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
