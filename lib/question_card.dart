import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class QuestionCard extends StatefulWidget {
  String question, ans0, ans1, ans2, ans3, id , real_ans, src ;
  Function fun;
  int real;

  QuestionCard({super.key, required this.question, required this.ans0 , required this.ans1 , required this.ans2, required this.ans3, required this.id , required this.real, required this.real_ans, required this.src, required this.fun});


  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  int val = -1;
  @override
  Widget build(BuildContext context) {
    return Container(
     height:480,
      child: Card(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration:const BoxDecoration(color:Color(0xffFF9F45), borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft:  Radius.circular(10))),
                        child: Center(
                            child: Text(
                              widget.question,
                              style: TextStyle(fontSize: 25,color: Colors.white),
                            )),
                        height: 200,
                        width: double.maxFinite,
                      ),


                        ListTile(
                          title: Text(widget.ans0),
                          leading: Radio(
                            value: 0,
                            groupValue: val,
                            onChanged: (value) {
                              setState(() {
                                val =  value!;
                              });
                            },
                            activeColor: Color(0xffFF9F45),
                          ),
                        ),
                      ListTile(
                        title: Text(widget.ans1),
                        leading: Radio(
                          value: 1,
                          groupValue: val,
                          onChanged: (value) {
                            setState(() {
                              val =  value!;
                            });
                          },
                          activeColor: Color(0xffFF9F45),
                        ),
                      ),
                      ListTile(
                        title: Text(widget.ans2),
                        leading: Radio(
                          value: 2,
                          groupValue: val,
                          onChanged: (value) {
                            setState(() {
                              val =  value!;
                            });
                          },
                          activeColor: Color(0xffFF9F45),
                        ),
                      ),
                      ListTile(
                        title: Text(widget.ans3),
                        leading: Radio(
                          value: 4,
                          groupValue: val,
                          onChanged: (value) {
                            setState(() {
                              val =  value!;
                            });
                          },
                          activeColor: Color(0xffFF9F45),
                        ),
                      ),

                      TextButton(
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(0)),
                        onPressed: () async {
                          if (val >= 0) {

                            try {
                              if(val == widget.real){
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .update(
                                    {"userPoints": FieldValue.increment(4)} );
                              }else{
                                widget.fun(widget.src,widget.real_ans);
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .update(
                                    {"userPoints": FieldValue.increment(1)} );

                              }
                              await FirebaseFirestore.instance
                                  .collection('questions')
                                  .doc(widget.id)
                                  .update(
                                  {"solved": FieldValue.arrayUnion([FirebaseAuth
                                      .instance.currentUser!.uid
                                  ])});





                            } catch (error) {
                              print('oh error $error');
                            }
                          }
                        },

                        child: Container(
                          height: 48,
                          width: double.maxFinite,
                          child: Center(
                            child: Text(
                                  'submit'.tr(),
                                  style: TextStyle(color: Colors.black),
                                ),
                          ),

                          ),
                        ),
                    ],
                  ),
                 ),
    );
   }
}