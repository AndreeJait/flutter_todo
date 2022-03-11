import 'dart:convert';

import 'package:http/http.dart' as http;

class ServicesHandler{
  static late String baseUrl;
  static String id = "9345";
  static String TOKEN = "714a0edc1b1d2153600ed4e0052d4572d79cd616070e05d8cf0823a4c3225afa";

  static void setBaseUrl(String url){
    ServicesHandler.baseUrl = url;
  }

  static Future<dynamic> get(String url) async{
    try {
      http.Response res = await http.get(Uri.parse(ServicesHandler.baseUrl + url), headers: {
        "Authorization":"Bearer ${ServicesHandler.TOKEN}"
      });
      return Response(res.statusCode, res.body == "" ? res.body : jsonDecode(res.body));
    }catch(e){
      return Response(500, e.toString());
    }
  }

  static Future<dynamic> delete(String url) async{
    try {
      http.Response res = await http.delete(Uri.parse(ServicesHandler.baseUrl + url), headers: {
        "Authorization":"Bearer ${ServicesHandler.TOKEN}"
      });
      return Response(res.statusCode, res.body == "" ? res.body : jsonDecode(res.body));
    }catch(e){
      return Response(500, e.toString());
    }
  }

  static Future<dynamic> post(String url, data) async{
    try {
      http.Response res = await http.post(Uri.parse(ServicesHandler.baseUrl + url), headers: {
        "Authorization":"Bearer ${ServicesHandler.TOKEN}",
        'Content-Type': 'application/json; charset=UTF-8',
      }, body: jsonEncode(data));

      return Response(res.statusCode, res.body == "" ? res.body : jsonDecode(res.body));
    }catch(e){
      return Response(500, e.toString());
    }
  }
}

class Response{
  int code;
  dynamic body;
  late bool isSuccess;
  @override
  String toString(){
    return "[$code] : $body";
  }
  Response(this.code, this.body){
    isSuccess = code ~/ 100 == 2;
  }
}