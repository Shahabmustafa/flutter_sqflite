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
                if(snapshot.hasData){
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context,index){
                        return InkWell(
                          onTap: (){
                            dbHelper!.update(
                              NotesModel(
                                id: snapshot.data![index].id,
                                  title: 'First Flitter note',
                                  age: 11,
                                  description: 'let me take to you tommorw',
                                  email: 'shahabmustafa57@gmail.com',
                              ),
                            );
                            setState(() {
                              notesList = dbHelper!.getNotesList();
                            });
                          },
                          child: Dismissible(
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              child: Icon(Icons.delete),
                            ),
                            onDismissed: (DismissDirection direction){
                              setState(() {
                                dbHelper!.Delete(snapshot.data![index].id!);
                                notesList = dbHelper!.getNotesList();
                                snapshot.data!.remove(snapshot.data![index]);
                              });
                            },
                            key: ValueKey<int>(snapshot.data![index].id!),
                            child: Card(
                              child: ListTile(
                                title: Text(snapshot.data![index].title.toString()),
                                subtitle: Text(snapshot.data![index].age.toString()),
                                trailing: Text(snapshot.data![index].email.toString()),
                              ),
                            ),
                          ),
                        );
                      });
                }else{
                  return CircularProgressIndicator();
                }
            }),
          )

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          dbHelper!.insert(
            NotesModel(
                title: 'Shahab Khan',
                age: 21,
                description: 'I am Flutter Developer',
                email: 'shahab57@gmail.com',
            ),
          ).then((value){
            print('Data Add');
            setState(() {
              notesList = dbHelper!.getNotesList();
            });
          }).onError((error, stackTrace){
            print('Error :${error.toString()}');
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
