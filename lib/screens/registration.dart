import 'package:flutter/material.dart';
import 'package:godownmanager/utils/myroutes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';

// ignore: camel_case_types
class registration extends StatefulWidget {
  const registration({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _registrationState();
}

// ignore: camel_case_types
class _registrationState extends State<registration> {
  bool changebutton = false;
  final _registerformkey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final password1Controller = TextEditingController();
  final password2Controller = TextEditingController();
  movetohome(BuildContext context) async {
    if (_registerformkey.currentState!.validate()) {
      setState(() {
        changebutton = true;
        FirebaseFirestore.instance.collection("user_master").add({
          'name': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          "password": password1Controller.text
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Welcome " + nameController.text),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registration"),
      ),
      body: Center(
        child: Material(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [
                Image.asset(
                  "assets/images/logo.png",
                  height: 150,
                  width: 200,
                  fit: BoxFit.fill,
                ),
                const SizedBox(height: 20.0),
                const Text("Sparrow Textiles",
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20.0),
                Form(
                    key: _registerformkey,
                    child: Column(
                      children: [
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
                        TextFormField(
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
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: "Password",
                              hintText: "Enter Password",
                            ),
                            controller: password1Controller,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return " Password cannot be empty";
                              }
                              if (value.length < 6) {
                                return " Password length should be atleast 6";
                              }
                              return null;
                            }),
                        TextFormField(
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: "Confrim Password",
                              hintText: "Enter Confrim Password",
                            ),
                            controller: password2Controller,
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return " Confrim Password cannot be empty";
                              } else {
                                if (value != password1Controller.text) {
                                  return " Passwords must be samer ";
                                }
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
                                : const Text("Registration",
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
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, MyRoutes.loginRoustes);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text("Already have account ?  ",
                        style: TextStyle(color: Colors.blueAccent)),
                  ),
                ),
                const SizedBox(height: 20.0),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
