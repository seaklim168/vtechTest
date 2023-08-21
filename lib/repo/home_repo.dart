import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:vtech_test/model/item_model.dart';

class HomeRepo {
  /// get collection
  CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('todolist');

  Future<List<ItemModel>> getData() async {
    /// fetch data
    QuerySnapshot querySnapshot = await collectionRef.get();

    /// item as Model
    var result = querySnapshot.docs.map((doc) {
      ItemModel d = ItemModel();
      d.title = doc["title"];
      d.isCompleted = doc["is_complete"];
      d.strId = doc.id;
      return d;
    }).toList();
    return result;
  }

  /// return id back
  /// has id is ok, "" error
  Future<String> add(ItemModel params) {
    var data = {
      'title': params.title,
      'is_complete': false, // new item always false
    };
    return collectionRef.add(data).then((value) {
      return value.id;
    }).catchError((err) {
      debugPrint("error : $err");
      return '';
    });
  }

  /// 200 ok, 400 error
  Future<int> updateTitle(ItemModel params) {
    var data = {
      'title': params.title,
    };
    return collectionRef
        .doc(params.strId)
        .update(data)
        .then((value) => 200)
        .catchError((err) {
      debugPrint("error : $err");
      return 400;
    });
  }

  /// 200 ok, 400 error
  /// complete or inComplete
  Future<int> updateStatus(ItemModel params) {
    var data = {
      'is_complete': params.isCompleted,
    };
    return collectionRef
        .doc(params.strId)
        .update(data)
        .then((value) => 200)
        .catchError((err) {
      debugPrint("error : $err");
      return 400;
    });
  }

  Future<int> remove(String strId) {
    return collectionRef
        .doc(strId)
        .delete()
        .then((value) => 200)
        .catchError((err) {
      debugPrint("error : $err");
      return 400;
    });
  }
}
