import 'package:flutter/material.dart';
import 'package:godownmanager/utils/myroutes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class updateuser extends StatefulWidget {
  final String id;
  const updateuser({Key? key, required this.id}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _updateuserstate();
}

// ignore: camel_case_types
class _updateuserstate extends State<updateuser> {
  final Stream<QuerySnapshot> crudStrem =
      FirebaseFirestore.instance.collection("user_master").snapshots();

  bool changebutton = false;
  final _registerformkey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController wpnoController = TextEditingController();
  final TextEditingController addController = TextEditingController();
  final TextEditingController photoController = TextEditingController();
  final TextEditingController joindateController = TextEditingController();

  final password1Controller = TextEditingController();
  final password2Controller = TextEditingController();
  movetohome(BuildContext context) async {
    if (_registerformkey.currentState!.validate()) {
      setState(() {
        changebutton = true;
        FirebaseFirestore.instance
            .collection("user_master")
            .doc(widget.id)
            .set({
          'UserName': nameController.text,
          'Email': emailController.text,
          'Phone': phoneController.text,
          "WhatsAppNo": wpnoController.text,
          "JoiningDate": joindateController.text,
          "Photo": phoneController.text,
          "Address": addController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("updated"),
        ));
      });
      await Future.delayed(const Duration(seconds: 1));
      await Navigator.pushNamed(context, MyRoutes.homeRoustes);
      setState(() {
        changebutton = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //print("id:${widget.id}");
    return StreamBuilder<QuerySnapshot>(
      stream: crudStrem,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Container(
            child: const Text("something want wrong"),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final List storedocs = [];
        if (snapshot.data!.docs.isEmpty) {
          return Container(
            child: const Text("data not found"),
          );
        } else {
          snapshot.data!.docs.map((DocumentSnapshot ds) {
            if (ds.id == widget.id) {
              storedocs.add(ds.data());
            }
          }).toList();
          nameController.text = storedocs[0]['UserName'];
          emailController.text = storedocs[0]['Email'];
          phoneController.text = storedocs[0]['PhoneNo'];
          addController.text = storedocs[0]['Address'];
          joindateController.text = storedocs[0]['JoingingDate'];
          //.text = storedocs[0]['Image'];
          wpnoController.text = storedocs[0]['WhatsAppNo'];
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text("Update User"),
          ),
          body: Material(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  Form(
                      key: _registerformkey,
                      child: Column(
                        children: [
                          TextFormField(
                              controller: nameController,
                              //initialValue: storedocs[0]['name'],
                              decoration: const InputDecoration(
                                labelText: "Name",
                                hintText: "Enter Name",
                              ),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return " Name cannot be empty";
                                }
                                return null;
                              }),
                          TextFormField(
                            //initialValue: storedocs[0]['email'],
                            decoration: const InputDecoration(
                              labelText: "Email",
                              hintText: "Enter Email",
                            ),
                            controller: emailController,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Email cannot be empty";
                              } else {
                                bool emailValid = RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value);
                                if (emailValid) {
                                  return null;
                                } else {
                                  return "Invalid Email";
                                }
                              }
                            },
                          ),
                          TextFormField(
                              //  initialValue: storedocs[0]['phone'],
                              decoration: const InputDecoration(
                                labelText: "Phone No",
                                hintText: "Enter Phone No",
                              ),
                              controller: phoneController,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return " Phone No cannot be empty";
                                }
                                return null;
                              }),
                          TextFormField(
                              controller: wpnoController,
                              decoration: const InputDecoration(
                                labelText: "WhatsApp No",
                                hintText: "Enter WhatsApp No",
                              ),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return " Name cannot be empty";
                                }
                                return null;
                              }),
                          TextFormField(
                              controller: addController,
                              decoration: const InputDecoration(
                                labelText: "Address",
                                hintText: "Enter Address",
                              ),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return " Name cannot be empty";
                                }
                                return null;
                              }),
                          TextFormField(
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: "Joining Date",
                                hintText: "Enter Joining Date",
                              ),
                              keyboardType: TextInputType.datetime,
                              controller: joindateController,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return " join date cannot be empty";
                                }
                                return null;
                              }),
                          TextFormField(
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: "Password",
                                hintText: "Enter Password",
                              ),
                              controller: password2Controller,
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return " Password cannot be empty";
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
                                  : const Text("Update",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(height: 20.0),
                ]),
              ),
            ),
          ),
        );
      },
    );
  }
}
