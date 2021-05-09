import 'dart:convert';

import 'package:http/http.dart';
import 'package:redrotapp/data/models/clones_result_model.dart';

import 'api_constants.dart';

enum ApiType { JSON, FORMDATA }

class ApiClient {
  final Client client;
  ApiClient(this.client);

  dynamic post(String path, {required Object body}) async {
    final response = await client.post(
      Uri.parse(
        "${ApiConstants.BASE_URL}$path",
      ),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return responseBody;
    }
    throw Exception(response.reasonPhrase);
  }
}
