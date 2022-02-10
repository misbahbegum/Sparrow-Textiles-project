import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:godownmanager/utils/myroutes.dart';

// ignore: camel_case_types
class login extends StatefulWidget {
  login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

// ignore: camel_case_types
class _loginState extends State<login> {
  String name = "";
  bool changebutton = false;
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  movetohome(BuildContext context) async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        changebutton = true;
      });
      checkData(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log In"),
      ),
      body: Material(
        child: SingleChildScrollView(
            child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              const Text("Sparrow Textiles",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20.0),
              Image.asset(
                "assets/images/logo.png",
                height: 150,
                width: 200,
                fit: BoxFit.fill,
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text("Welcome$name",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20.0),
                    Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              labelText: "Email",
                              hintText: "Enter Email",
                            ),
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return " Email cannot be empty";
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
                            onChanged: (value) {
                              name = value == ""
                                  ? name = ""
                                  : name = name == ""
                                      ? value = ", " + value
                                      : ", " + value;
                              setState(() {});
                            },
                          ),
                          TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: "Password",
                                hintText: "Enter Password",
                              ),
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return " Password cannot be empty";
                                }
                                if (value.length < 6) {
                                  return " Password length should be atleast 6";
                                }
                                return null;
                              }),
                          const SizedBox(height: 20.0),
                          InkWell(
                            onTap: () {
                              setState(() {
                                changebutton = true;
                              });
                              Navigator.pushNamed(
                                  context, MyRoutes.homeRoustes);
                            },
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: const Text("Forget Password ?  ",
                                  style: TextStyle(color: Colors.blueAccent)),
                            ),
                          ),
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
                                  : const Text("Login",
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
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    InkWell(
                      onTap: () {
                        setState(() {
                          changebutton = true;
                        });
                        Navigator.pushNamed(
                            context, MyRoutes.registrationRoustes);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text("Don't have account ?  ",
                            style: TextStyle(color: Colors.blueAccent)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  checkData(BuildContext context) async {
    FirebaseFirestore.instance
        .collection("user_master")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((storedocs) async {
        if (emailController.text == storedocs['Email']) {
          if (passwordController.text == storedocs['Password']) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Login succesfully"),
            ));
            await Future.delayed(const Duration(seconds: 1));
            await Navigator.pushNamed(context, MyRoutes.homeRoustes);
            setState(() {
              changebutton = false;
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Worng Password"),
            ));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Invalid Email "),
          ));
        }
      });
    });
  }
}
