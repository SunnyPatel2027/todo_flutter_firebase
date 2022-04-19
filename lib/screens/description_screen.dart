import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'add_task.dart';

class DescriptionScreen extends StatelessWidget {
  final String title, description,id,time;

  const DescriptionScreen(
      {Key? key, required this.title, required this.description,required this.id,required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("description"),
      ),
      body: Card(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 17),
          // height: MediaQuery.of(context).size.height/2,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "$title ,",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white70),
                  ),
                  Spacer(),
                  IconButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddTaskScreen(title: title , description: description,id:id),));
                  }, icon: Icon(Icons.edit,color: Colors.white70,size: 20,))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(description,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,wordSpacing: 3.5,)),
              SizedBox(height: 10,),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(time,style: TextStyle(fontSize: 11.5,fontWeight: FontWeight.w400,color: Colors.white70),),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

