import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


import 'add_task.dart';
import 'description_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String uid = '';

  @override
  void initState() {
    // TODO: implement initState
    getuid();
    super.initState();
  }

  getuid() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user =  auth.currentUser!;
    setState(() {
      uid = user.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
        onTap: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTaskScreen(),
              )
          );
        },
            child: Text("TODO")
        ),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout,color: Colors.white70,))
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: uid.isEmpty?CircularProgressIndicator():StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('tasks')
              .doc(uid)
              .collection('mytask')
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                child: Center(child: CircularProgressIndicator()),
              );
            } else {
              final doc = snapshot.data?.docs;
              return ListView.builder(
                  itemCount: doc?.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Column(
                        children: [
                          Card(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DescriptionScreen(
                                          title: doc?[index]["title"],
                                          description: doc?[index]
                                              ["description"],
                                          id: doc?[index]["id"],
                                          time: DateFormat("dd-MM-yyyy hh-mm a").format(DateTime.parse(doc?[index]["time"]))),
                                    ));
                              },
                              child: ListTile(
                                title: Text(doc![index]["title"]),
                                subtitle: Text(DateFormat("dd-MM-yyyy hh:mm a")
                                    .format(
                                        DateTime.parse(doc[index]["time"]))),
                                trailing: GestureDetector(
                                    onTap: () async {
                                      await FirebaseFirestore.instance
                                          .collection("tasks")
                                          .doc(uid)
                                          .collection("mytask")
                                          .doc(doc[index]["id"])
                                          .delete();
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    )),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  });
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white70,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTaskScreen(),
              )
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.black54,
        ),
      ),
    );
  }
}
