import 'package:flutter/material.dart';
import 'package:flutter_sqflite/db_handler.dart';
import 'package:flutter_sqflite/notes.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DBHelper? dbHelper;
  late Future<List<NotesModel>> notesList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }
  loadData()async{
    notesList =  dbHelper!.getNotesList();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: notesList,
                builder: (context,AsyncSnapshot<List<NotesModel>> snapshot){
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                    itemBuilder: (context,index){
                  return Card(
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                      title: Text(snapshot.data![index].title.toString()),
                      subtitle: Text(snapshot.data![index].age.toString()),
                      trailing: Text(snapshot.data![index].email.toString()),
                    ),
                  );
                });
            }),
          )

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          dbHelper!.insert(
            NotesModel(
                title: 'Shahab Mustafa',
                age: 21,
                description: 'I am Flutter Developer',
                email: 'shahabmustafa57@gmail.com',
            ),
          ).then((value){
            print('Data Add');
          }).onError((error, stackTrace){
            print('Error :${error.toString()}');
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
