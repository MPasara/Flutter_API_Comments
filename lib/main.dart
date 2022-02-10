import 'dart:async';
import 'package:api_flutter/models/comments_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:api_flutter/providers/comments_provider.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Comments';

    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.blueAccent, Colors.purple])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<List<CommentsData>>(
          future: fetchComments(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'An error has occurred!',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              );
            } else if (snapshot.hasData) {
              return CommentsList(comments: snapshot.data!);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        appBar: AppBar(
          title: Text(title),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[Colors.blueAccent, Colors.purple],
              ),
            ),
          ),
          centerTitle: true,
          foregroundColor: Colors.white,
          backgroundColor: Colors.white12,
        ),
      ),
    );
  }
}

class CommentsList extends StatelessWidget {
  const CommentsList({Key? key, required this.comments}) : super(key: key);

  final List<CommentsData> comments;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.blueAccent, Colors.purple],
        ),
      ),
      child: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          fetchComments(http.Client());
        },
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: comments.length,
          itemBuilder: (context, index) {
            //return Image.network(comments[index].name);
            return Padding(
              padding: const EdgeInsets.all(5),
              child: ElevatedButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  side: const BorderSide(color: Colors.black, width: 1.4),
                  primary: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                //test for LongPress method
                onLongPress: () {
                  Fluttertoast.showToast(msg: 'No to drugs, yes to tacos ;)');
                },
                onPressed: () {
                  Fluttertoast.showToast(
                      msg: 'ID: ' +
                          comments[index].id.toString() +
                          '\n POSTID: ' +
                          comments[index].postId.toString() +
                          '\n NAME: ' +
                          comments[index].name.toString() +
                          '\n EMAIL: ' +
                          comments[index].email.toString() +
                          '\n BODY: ' +
                          comments[index].body.toString(),
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 2,
                      backgroundColor: Colors.black54,
                      fontSize: 16.0);
                },
                child: GridTile(
                  child: Text(
                    comments[index].email.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15.7,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
