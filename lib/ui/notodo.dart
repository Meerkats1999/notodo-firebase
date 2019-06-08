import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:notodo_firebase/model/notodo_item.dart';

class NoToDoScreen extends StatefulWidget {
  @override
  _NoToDoScreenState createState() => _NoToDoScreenState();
}

class _NoToDoScreenState extends State<NoToDoScreen> {
  List<NoDoItem> messages = List();
  NoDoItem noDoItem;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DatabaseReference databaseReference;

  @override
  void initState() {
    super.initState();
    noDoItem = NoDoItem("", "");
    databaseReference = database.reference().child("notodo");
    databaseReference.onChildAdded.listen(_onEntryAdded);
    databaseReference.onChildChanged.listen(_onEntryChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        children: <Widget>[
          Flexible(
            child: FirebaseAnimatedList(
              query: databaseReference,
              itemBuilder: (_, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                return Card(
                  color: Colors.grey,
                  child: ListTile(
                    title: Text("${messages[index].itemName}"),
                    subtitle: Text("Date Created: ${messages[index].dateCreated}"),
                    onLongPress: () => debugPrint(""),
                    trailing: new Listener(
                      key: Key(messages[index].itemName),
                      child: Icon(Icons.remove_circle,
                        color: Colors.redAccent,
                      ),
                      onPointerDown: (pointerEvent) =>  handleDelete(),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFormDialog,
        child: ListTile(
          title: Icon(Icons.add),
        ),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  void _onEntryAdded(Event event) {
    setState(() {
      messages.add(NoDoItem.fromSnapshot(event.snapshot));
    });
  }

  void _showFormDialog() {
    var alert = AlertDialog(
        content: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.subject),
                  title: TextFormField(
                    initialValue: "",
                    onSaved: (val) => noDoItem.itemName = val,
                    validator: (val) => val == "" ? val : null,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      child: Text("Save"),
                      onPressed: () {
                        handleSubmit();
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                    ),
                    RaisedButton(
                      child: Text("Clear"),
                      onPressed: () {
                        handleClear();
                      },
                    )
                  ],
                )
              ],
            )));
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void handleSubmit() {
    final FormState form = formKey.currentState;
    if(form.validate()){
      form.save();
      form.reset();
      databaseReference.push().set(noDoItem.toJson());
    }
  }

  void handleClear() {
    final FormState form = formKey.currentState;
    form.reset();
  }

  handleDelete() {
    databaseReference.remove();
  }

  void _onEntryChanged(Event event) {
    var oldEntry = messages.singleWhere((entry){
      return entry.key == event.snapshot.key;
    });
    setState(() {
      messages[messages.indexOf(oldEntry)] = NoDoItem.fromSnapshot(event.snapshot);
    });
  }
}
