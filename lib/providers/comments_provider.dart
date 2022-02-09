import 'dart:async';
import 'dart:convert';
import 'package:api_flutter/models/comments_data.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<List<CommentsData>> fetchComments(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://jsonplaceholder.typicode.com/comments'));

  //Compute function runs parseComments in a separate isolate.
  return compute(parseComments, response.body);
}

// A function that converts a response body into a List<Comment>.
List<CommentsData> parseComments(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed
      .map<CommentsData>((json) => CommentsData.fromJson(json))
      .toList();
}
