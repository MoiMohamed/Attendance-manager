import 'package:attendance/models/APIKey.dart';
import 'package:attendance/models/HttpException.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expiryDate;

  Timer _authTimer;

  String get tokenGet {
    return _token;
  }

  String get userIdGet {
    return _userId;
  }

  bool get isAuth{
    if(_token != null && _expiryDate.isAfter(DateTime.now()))
      return true;
    else 
      return false;

  }

  Future<void> authenthicate(String type, String email, String password,
      {String name}) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:$type?key=$APIKey");
    try {
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true
          }));

      if (json.decode(response.body)["error"] != null) {
        throw HttpException(json.decode(response.body)["error"]["message"]);
      }

      if (type == "signUp") {
        
        try{
          final url2 = Uri.parse(
              "https://attendance-manager-b9d3f-default-rtdb.europe-west1.firebasedatabase.app/userData/$_userId.json");

          final response2 = await http.put(url2, body: json.encode({"name": name}));

          if(response2.statusCode >= 400)
          {
            throw HttpException(response2.statusCode.toString());
          }
        }
        catch(e)
        {
          throw e;
        }
      }

      _token = json.decode(response.body)["idToken"];
      _userId = json.decode(response.body)["userId"];
      _expiryDate = DateTime.now().add(Duration(
          seconds: int.parse(json.decode(response.body)["expiresIn"])));

      final pref = await SharedPreferences.getInstance();
      final userData = json.encode({
        "email": email,
        "password": password,
        "token": _token,
        "userId": _userId,
        "expiryDate": _expiryDate.toIso8601String()
      });

      pref.setString("UserData", userData);

      _autoLogout();

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> login(String email, String password) async {
    authenthicate("signInWithPassword", email, password);
  }

  Future<void> signup(String email, String password, String name) {
    authenthicate("signUp", email, password, name: name);
  }

  Future<bool> autoLogin() async{
    final pref = await SharedPreferences.getInstance();

    if(!pref.containsKey("UserData"))
    {
      return false;
    }

    final extractedData = json.decode(pref.getString("UserData"));

    final expiry = DateTime.parse(extractedData["expiryDate"]);
    final email = extractedData["email"];
    final password = extractedData["password"];

    if(expiry.isBefore(DateTime.now()))
    {
      login(email, password);
    }
    else
    {
      _expiryDate = expiry;
      _userId = extractedData["userId"];
      _token = extractedData["token"];
      _autoLogout();
    }

    notifyListeners();

    return true;

  }

  Future<void> logout() async{

    _token = null;
    _userId = null;
    _expiryDate = null;

    if(_authTimer != null)
    {
      _authTimer.cancel();
      _authTimer = null;
    }

    final pref = await SharedPreferences.getInstance();
    pref.clear();
    notifyListeners();
  }

  void _autoLogout()
  {
    if(_authTimer != null)
    {
      _authTimer.cancel();
    }
    final differenceInSec = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: differenceInSec), logout);
  }
}