import 'package:example_http/pages/form_page.dart';
import 'package:example_http/pages/home_page.dart';
import 'package:example_http/services_handler.dart';
import 'package:flutter/material.dart';

void main() async{
  ServicesHandler.setBaseUrl("https://gorest.co.in");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: "/",
      routes: {
        "/": (context)=> HomePage(),
        "/form": (context)=> FormPage()
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

