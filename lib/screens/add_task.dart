import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'home_screen.dart';

class AddTaskScreen extends StatefulWidget {
  AddTaskScreen({Key? key, this.id, this.title, this.description})
      : super(key: key);
  String? title;
  String? description;
  String? id;

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController disController = TextEditingController();


  addtasktofirebase() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = await auth.currentUser!;
    String uid = user.uid;
    var time = DateTime.now();
    await FirebaseFirestore.instance.collection("tasks").doc(uid).collection(
        "mytask").doc(time.millisecondsSinceEpoch.toString()).set(
        {
          'title': titleController.text,
          'time': time.toIso8601String(),
          'description': disController.text,
          'id': time.millisecondsSinceEpoch.toString()
        });
    Fluttertoast.showToast(msg: "Task Added");
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController.text = widget.title ?? "";
    disController.text = widget.description ?? "";
  }
  editdata() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = await auth.currentUser!;
    String uid = user.uid;
    await FirebaseFirestore.instance.collection("tasks").doc(uid).collection(
        "mytask").doc(widget.id).update(
        {
          "description" : disController.text,
          "title" : titleController.text
        }
    );
    Fluttertoast.showToast(msg: "Edit Task Successfully");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.id == null ? Text("ADD TASK") : Text("EDIT TASK"),
      ),
      body: Container(
        padding: EdgeInsets.all(25),
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter Task",
                    hintStyle: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500)
                ),
              ),
              SizedBox(
                height: 13,
              ),
              widget.id == null ?
              TextField(
                controller: disController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter Description",
                    hintStyle: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500)
                ),
              ) :
              TextField(
                controller: disController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Edit Description",
                    hintStyle: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500)
                ),
              ),
              SizedBox(
                height: 15,
              ),
              widget.id == null ?
              Container(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(onPressed: () {
                  addtasktofirebase();
                  Navigator.pop(context);
                },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.purple)
                    ),
                    child: Text("ADD", style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 20),)
                ),
              ) :
              Container(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(onPressed: () {
                  editdata();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
                },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.purple)
                    ),
                    child: Text("EDIT", style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 20),)
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
