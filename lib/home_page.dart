import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:el_moos/news_page.dart';
import 'package:el_moos/questions_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'app_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchQueryController = TextEditingController();
  String searchKey = '';
  bool first = false;
  String searchQuery = "Search query";
  List<Map<String, dynamic>> _pageData = [];
  int _pageIndex = 0;
  dynamic page = NewsPage();




  void _selectPage(index) {
    setState(() {
      _pageIndex = index;

      if (_pageIndex == 0) {
        page = NewsPage();
      }
      if (_pageIndex == 1) {
        page = QuestionsPage();
      }
    });
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
    drawer: const AppDrawer(),
      body: page,
      appBar: AppBar(
        title: const Text("El-Moos"),
        actions: [
         Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child:Container(
            width: 30,
            height: 30,
            child: StreamBuilder(

              stream: FirebaseFirestore.instance
                  .collection('users')
                  .snapshots(),
              builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child:Text("0",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),));
                }
                final docs = snapshot.data!.docs;
                if(snapshot.hasError){
                  print("aaaaaaaaaaaaaa ${snapshot.error}");
                }
                dynamic doc;
                for(int i = 0 ; i < docs.length ; i++){
                  if(docs[i]['userEmail'] == FirebaseAuth.instance.currentUser!.email ){
                    doc = docs[i];
                    break;
                  }
                }


                return Center(child:Text("${doc['userPoints']}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),));
              },
            ),
          ),
        )],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => _selectPage(index),
        unselectedItemColor: Theme.of(context).accentColor,
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Colors.white,
        currentIndex: _pageIndex,
        items: [
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.people),
          //   label: 'Community',
          //   backgroundColor: Theme.of(context).primaryColor,
          // ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.newspaper),
            label: 'news'.tr(),
            backgroundColor: Theme.of(context).primaryColor,
          ),

          BottomNavigationBarItem(
            icon: const Icon(Icons.question_mark),
            label: 'questions'.tr(),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
