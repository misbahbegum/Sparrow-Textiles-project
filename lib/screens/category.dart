import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:godownmanager/api/firebaseapi.dart';
import 'package:godownmanager/utils/myroutes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:godownmanager/widgets/drawer.dart';

class category extends StatefulWidget {
  const category({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _category();
}

// ignore: camel_case_types
class _category extends State<category> {
  bool changebutton = false;
  final _categoryformkey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  File? file;
  String fileName = "";
  UploadTask? task;
  movetohome(BuildContext context) async {
    if (_categoryformkey.currentState!.validate()) {
      if (fileName != null && fileName != "No Image selected") {
        if (uploadimage() == true) {
          print("Done");
        }

        /*    setState(() {
          changebutton = true;
          bool x = uploadimage();
          FirebaseFirestore.instance.collection('category_master').add({
            'CategoryName': nameController.text,
            //    'CategoryImage': imageController.text,
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Category Inserted"),
          ));
        });
        await Future.delayed(const Duration(seconds: 1));
        await Navigator.pushNamed(context, MyRoutes.homeRoustes);
        setState(() {
          changebutton = false;
        });
      */
      } else {
        print(fileName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    fileName = file != null ? basedata(file!.path) : 'No Image selected';
    return Scaffold(
        appBar: AppBar(
          title: const Text("Category"),
        ),
        drawer: const mydrawer(),
        body: Center(
            child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
            child: Form(
                key: _categoryformkey,
                child: Column(children: [
                  ElevatedButton.icon(
                      onPressed: () => selectFile(),
                      icon: const Icon(Icons.add_a_photo_rounded),
                      label: const Text("")),
                  Text(fileName),
                  const SizedBox(height: 20.0),
                  TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Name",
                        hintText: "Enter Name",
                      ),
                      controller: nameController,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return " Name cannot be empty";
                        }
                        return null;
                      }),
                  const SizedBox(height: 20.0),
                  InkWell(
                    onTap: () => movetohome(context),
                    child: AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      width: changebutton ? 40 : 150,
                      height: 40,
                      alignment: Alignment.center,
                      child: changebutton
                          ? const Icon(
                              Icons.done,
                              color: Colors.white,
                            )
                          : const Text("Submit",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                  ),
                  task != null ? buildUploadStatus(task!) : Container(),
                ])),
          ),
        )));
  }

  selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) {
      return;
    } else {
      setState(() {
        String path = result.files.single.path!;
        file = File(path);
      });
    }
  }

  String basedata(String path) {
    var abc = path.split("/");
    return abc.last;
  }

  Future<bool> uploadimage() async {
    if (file == null) {
      print("upload file empty");
      return false;
    } else {
      task = FirebaseApi.uploadFile("files/" + basedata(file!.path), file!);
      setState(() {});
      if (task == null) {
        return false;
      } else {
        final snapshot = await task!.whenComplete(() {});
        final url = await snapshot.ref.getDownloadURL();
      }
      print("upload success");
      return true;
    }
  }

  buildUploadStatus(UploadTask uploadTask) => StreamBuilder<TaskSnapshot>(
      stream: task!.snapshotEvents,
      builder: (context, snapshots) {
        if (snapshots.hasData) {
          final snap = snapshots.data;
          final d = snap!.bytesTransferred / snap.totalBytes;
          int x = (d * 100).round();
          return Text("$x %",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
        } else {
          return Container();
        }
      });
}
