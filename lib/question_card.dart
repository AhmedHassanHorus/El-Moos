import 'package:flutter/material.dart';

class QuestionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 35),
                      child: Container(
                        color: Color(0xff5481c5),
                        child: Center(
                            child: Text(
                              "Qusetion",
                              style: TextStyle(fontSize: 25),
                            )),
                        height: 200,
                        width: 100,
                      ),
                    ),
                    Spacer(flex: 3),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Container(
                        color: Colors.red,
                        child: Center(
                            child: Text(
                              "frist",
                              style: TextStyle(fontSize: 25),
                            )),
                        height: 40,
                        width: 100,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Container(
                        color: Color(0xff36f455),
                        child: Center(
                            child: Text(
                              "second",
                              style: TextStyle(fontSize: 25),
                            )),
                        height: 40,
                        width: 100,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Container(
                        color: Color(0xff1262a4),
                        child: Center(
                            child: Text(
                              "third",
                              style: TextStyle(fontSize: 25),
                            )),
                        height: 40,
                        width: 100,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Container(
                        color: Colors.grey,
                        child: Center(
                            child: Text(
                              "fourth",
                              style: TextStyle(fontSize: 25),
                            )),
                        height: 40,
                        width: 100,
                      ),
                    ),
                    Spacer(flex: 2),
                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: Container(
                        color: Color(0xff3431c6),
                        child: Center(child: Text("Submit")),
                        height: 40,
                        width: 100,
                      ),
                    ),
                  ],
                ),
               );
   }
}