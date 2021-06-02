import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:redrotapp/data/models/clones_result_model.dart';
import 'package:path/path.dart' as fileUtil;
import 'api_constants.dart';

typedef void OnUploadProgressCallback(int sentBytes, int totalBytes);

enum ApiType { JSON, FORMDATA }

class ApiClient {
  final Client client;
  ApiClient(this.client);

  dynamic post(String path, {required Object body}) async {
    final response = await client
        .post(
          Uri.parse(
            "${ApiConstants.BASE_URL}$path",
          ),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(body),
        )
        .timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return responseBody;
    }
    throw Exception(response.reasonPhrase);
  }

  dynamic fileUploadMultipart(String path, String image, String cloneId) async {
    var uri = Uri.parse("${ApiConstants.BASE_URL}$path");
    var request = MultipartRequest('POST', uri)
      ..fields['cloneId'] = cloneId
      ..files.add(
        await MultipartFile.fromPath('image', image,
            contentType: MediaType('image', 'jpeg')),
      );
    var response = await request.send().timeout(Duration(seconds: 30));
    if (response.statusCode == 200) {
      final responseString = await response.stream.bytesToString();
      final responseBody = json.decode(responseString);
      return responseBody;
    }
    throw Exception(response.reasonPhrase);
  }
}
