import 'package:flutter/material.dart';
import 'package:flutter_sqflite_demo/models/note.dart';
import 'package:flutter_sqflite_demo/screens/note_detail.dart';
import 'package:flutter_sqflite_demo/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';



class NoteList extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {

    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {

    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }

    return Scaffold(

      appBar: AppBar(
        title: Text('Notes'),
      ),

      body: getNoteListView(),//get the list of notes

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');
          navigateToDetail(Note('', '', 2), 'Add Note');
          //navigate to detail calls note detail widget and takes argument as Note and app title
          //here for FAB new note title = Add note and default priority is 2(high)
        },

        tooltip: 'Add Note',

        child: Icon(Icons.add),

      ),
    );
  }




  //get the list of notes
  ListView getNoteListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(

            leading: CircleAvatar(
              backgroundColor: getPriorityColor(this.noteList[position].priority),
              child: getPriorityIcon(this.noteList[position].priority),
            ),

            title: Text(this.noteList[position].title, style: titleStyle,),

            subtitle: Text(this.noteList[position].date),

            trailing: GestureDetector(
              child: Icon(Icons.delete, color: Colors.grey,),
              onTap: () {
                _delete(context, noteList[position]);
                //_delete method deletes note of noteList at position index
              },
            ),


            onTap: () {
              debugPrint("ListTile Tapped");
              navigateToDetail(this.noteList[position],'Edit Note');
              //if user press at perticular note then this will open note detail with
              // app title Edit Note and , Node object current Node List index element
            },

          ),
        );
      },
    );
  }

  // Returns the priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;

      default:
        return Colors.yellow;
    }
  }

  // Returns the priority icon
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;

      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }


  //delete note if user press delete icon
  void _delete(BuildContext context, Note note) async {

    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }
  //shows snackbar after note is deleted
  void _showSnackBar(BuildContext context, String message) {

    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }


  //if user click on perticular note then this function will be called
  void navigateToDetail(Note note, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }



  //update the data of list view if new item is added / one item is deleted
  void updateListView() {

    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {

      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
