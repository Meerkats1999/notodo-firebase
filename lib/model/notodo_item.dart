import 'package:firebase_database/firebase_database.dart';
import 'package:notodo_firebase/model/date_formatter.dart';

class NoDoItem {
  String itemName;
  String dateCreated;
  String key;

  NoDoItem(String item, String date){
    itemName = item;
    dateCreated = dateFormatted();
  }

  NoDoItem.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        itemName = snapshot.value["itemName"],
        dateCreated = snapshot.value["dateCreated"];

  toJson(){
    return {
      "itemName": itemName,
      "dateCreated" : dateCreated,
    };
  }
}
