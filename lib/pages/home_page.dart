import 'dart:convert';

import 'package:example_http/model/todo.dart';
import 'package:example_http/services_handler.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _myData = ServicesHandler.get("/public/v2/todos");
  }

  late Future<dynamic> _myData;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("TODOS"),
              toolbarHeight: 45,
              actions: [
                IconButton(
                    onPressed: () => {Navigator.pushNamed(context, "/form")},
                    icon: const Icon(Icons.add))
              ],
            ),
            body: FutureBuilder(
              future: _myData,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  List<ToDo> todos = [
                    ...snapshot.data.body.map((json) => ToDo.fromJson(json))
                  ];
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        ...todos.map((d) => Card(
                              margin: const EdgeInsets.only(
                                  top: 10, left: 10, right: 10),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        "Due at " +
                                            DateTime.parse(d.due_on).toString(),
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 20),
                                      child: Text(
                                        d.title,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      margin: EdgeInsets.only(top: 20),
                                      child: Wrap(
                                        spacing: 10,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () => {},
                                            child: const Text(
                                              "Edit",
                                              style: TextStyle(
                                                  color: Colors.black45),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.yellow,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10))),
                                          ),
                                          Container(
                                            child: isLoading
                                                ? CircularProgressIndicator()
                                                : ElevatedButton(
                                                    onPressed: () async {
                                                      setState(() {
                                                        isLoading = true;
                                                      });
                                                      ServicesHandler.delete(
                                                              "/public/v2/todos/" +
                                                                  d.id.toString())
                                                          .then((value) {
                                                        setState(() {
                                                          if (value.isSuccess) {
                                                            _myData =
                                                                ServicesHandler.get(
                                                                    "/public/v2/todos");
                                                            _myData.then((value){
                                                              setState(() {
                                                                isLoading = false;
                                                              });
                                                            });
                                                          }else{
                                                            isLoading = false;
                                                          }
                                                        });
                                                      });
                                                    },
                                                    child: const Text(
                                                      "Delete",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    style: ElevatedButton.styleFrom(
                                                        primary: Colors.red,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10))),
                                                  ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )));
  }
}
