import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class test extends StatefulWidget {
  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  List<String> name = [];

  List<bool> checked = [false, false];
  List value = ['1','2'];
  var counter=0;

  var x;
  savePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('items', name);
  }

  getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    x = prefs.getStringList('items');
    print(name);
    print(x);
  }

  deletePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("test 1"),
      ),
      body: Column(
        children: [
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pushNamed('test 2');
            },
            child: Text("go to page 2"),
          ),
          MaterialButton(
            onPressed: () async {
              await getPrefs();
            },
            child: Text("get"),
          ),
          MaterialButton(
            onPressed: () async {
              await deletePrefs();
              name.clear();
            },
            child: Text("clear"),
          ),MaterialButton(
            onPressed: () async {
              showGeneralDialog(context: context, pageBuilder: ((context, animation, secondaryAnimation) {
                return Scaffold(
                  floatingActionButton: FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: ()async {
                    
             
              for(counter = 0;counter<checked.length;counter++){
                if(checked[counter] == true){
                  name.add("${value[counter]}");
                }
              }
              await savePrefs();
              Navigator.of(context).pop();
          
                  },),
                  body: StatefulBuilder(builder: (context, setState) {
                    return ListView.builder(
            shrinkWrap: true,
            itemCount: checked.length,
            itemBuilder: ((context, index) {
            return Checkbox(
            value: checked[index],
            onChanged: (val) {
              setState(() {

                  checked[index] = val!;
                  print(checked);
                
                //print(checked);
              });
            },
          );
          }));
                  },)
                );
              }));
            },
            child: Text("Get check box"),
          ),
          
        ],
      ),
    );
  }
}
