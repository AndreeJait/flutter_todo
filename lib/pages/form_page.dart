import 'dart:convert';

import 'package:example_http/model/todo.dart';
import 'package:example_http/services_handler.dart';
import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> form = {
    "title": "",
    "due_on": "",
    "status": "Pending",
    "user_id": 9345
  };

  void handleOnChange(String? text, String name) {
    form[name] = text!;
  }

  List<String> status = [ "Pending" , "Completed"];
  String dropdownValue = "Pending";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("FORM"),
            ),
            body: Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        enabled: !isLoading,
                        onChanged: (text) {
                          if (!isLoading) {
                            handleOnChange(text, "title");
                          }
                        },
                        decoration: const InputDecoration(hintText: 'TODO'),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Text(
                                form["due_on"] == ""
                                    ? "Please Select The Time"
                                    : form["due_on"].toString(),
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            SizedBox(
                              width: 150,
                              height: 30,
                              child: ElevatedButton(
                                onPressed: () => {
                                  if (!isLoading)
                                    {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(1950),
                                              lastDate: DateTime(
                                                  DateTime.now().year + 1000))
                                          .then((date) {
                                        if (date != null) {
                                          showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          ).then((time) {
                                            DateTime value = DateTime(
                                                date.year,
                                                date.month,
                                                date.day,
                                                time!.hour,
                                                time.minute);
                                            setState(() {
                                              form["due_on"] = value.toString();
                                            });
                                          });
                                        }
                                      })
                                    }
                                },
                                child: const Text("Select Time"),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.cyan),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 10),
                          child: SizedBox(
                            width: double.infinity,
                            child: DropdownButton(
                              value: dropdownValue,
                              isExpanded: true,
                              icon: Icon(Icons.arrow_drop_down),
                              items: status.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (!isLoading) {
                                  setState(() {
                                    form["status"] = value.toString();
                                    dropdownValue = value.toString();
                                  });
                                }
                              },
                            ),
                          )),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate() &&
                                      form["due_on"] != "") {
                                    ToDo todo = ToDo.fromJson(form);
                                    setState(() {
                                      isLoading = true;
                                    });
                                    ServicesHandler
                                        .post("/public/v2/todos", todo)
                                        .then((value) {
                                      setState(() {
                                        isLoading = false;
                                        if(value.isSuccess){
                                          Navigator.pushNamed(context, "/");
                                        }else{
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                              content: Text(value.body.toString()))
                                          );
                                        }
                                      });
                                    });
                                  }
                                },
                                child: Text("Simpan"),
                              ),
                      )
                    ],
                  )),
            )));
  }
}
