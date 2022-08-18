import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ClassTeacher extends ChangeNotifier {
  List<String> _classes = [];
  String user_id;
  String token;

  ClassTeacher(this.user_id, this.token, _classes);

  Future<void> fetchData() async {
    final url = Uri.parse(
        "https://attendance-manager-b9d3f-default-rtdb.europe-west1.firebasedatabase.app/classTeacher.json");

    try {
      final response = await http.get(url);

      final data = json.decode(response.body) as Map<String, dynamic>;

      if(data[user_id] != null)
        _classes = data[user_id];
      
    } catch (e) {
      throw e;
    }
  }

  List<String> get classes {
    return [..._classes];
  }
}
