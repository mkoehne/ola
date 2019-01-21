import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ola/models/todo.dart';

final CollectionReference todoCollection = Firestore.instance.collection('todo');

class Repository {

  static final Repository _instance = new Repository.internal();

  factory Repository() => _instance;

  Repository.internal();

  Future<Todo> createTodo(String subject, bool isComplete) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(todoCollection.document());

      final Todo todo = new Todo(ds.documentID, subject, isComplete);
      final Map<String, dynamic> data = todo.toMap();

      await tx.set(ds.reference, data);

      return data;
    };

    return Firestore.instance.runTransaction(createTransaction).then((mapData) {
      return Todo.fromMap(mapData);
    }).catchError((error) {
      print('error: $error');
      return null;
    });
  }

  Stream<QuerySnapshot> getTodoList({int offset, int limit}) {
    Stream<QuerySnapshot> snapshots = todoCollection.snapshots();

    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }

    if (limit != null) {
      snapshots = snapshots.take(limit);
    }

    return snapshots;
  }

  Future<dynamic> updateTodo(Todo todo) async {
    final TransactionHandler updateTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(todoCollection.document(todo.id));

      await tx.update(ds.reference, todo.toMap());
      return {'updated': true};
    };

    return Firestore.instance
        .runTransaction(updateTransaction)
        .then((result) => result['updated'])
        .catchError((error) {
      print('error: $error');
      return false;
    });
  }

  Future<dynamic> deleteTodo(String id) async {
    final TransactionHandler deleteTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(todoCollection.document(id));

      await tx.delete(ds.reference);
      return {'deleted': true};
    };

    return Firestore.instance
        .runTransaction(deleteTransaction)
        .then((result) => result['deleted'])
        .catchError((error) {
      print('error: $error');
      return false;
    });
  }
}
