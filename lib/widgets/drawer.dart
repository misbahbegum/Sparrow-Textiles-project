import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:godownmanager/screens/updateuser.dart';
import 'package:godownmanager/utils/myroutes.dart';

// ignore: camel_case_types
class mydrawer extends StatefulWidget {
  const mydrawer({Key? key}) : super(key: key);

  @override
  State<mydrawer> createState() => _mydrawerState();
}

class _mydrawerState extends State<mydrawer> {
  final Stream<QuerySnapshot> crudStrem =
      FirebaseFirestore.instance.collection("user_master").snapshots();

  final UserImageUrl =
      "https://images.pexels.com/photos/736230/pexels-photo-736230.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500";

  @override
  Widget build(BuildContext context) {
    String id = "";
    return StreamBuilder<QuerySnapshot>(
      stream: crudStrem,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print("something want wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final List storedocs = [];
        if (snapshot.data!.docs.isEmpty) {
          print("data not found");
        } else {
          snapshot.data!.docs.map((DocumentSnapshot ds) {
            id = ds.id;
            storedocs.add(ds.data());
          }).toList();
        }
        return Drawer(
          child: Container(
            padding: EdgeInsets.zero,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                    padding: EdgeInsets.zero,
                    child: UserAccountsDrawerHeader(
                      margin: EdgeInsets.zero,
                      accountName: Text(storedocs[0]['UserName']),
                      accountEmail: Text(storedocs[0]['Email']),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: NetworkImage(UserImageUrl),
                        //Image.network(UserImageUrl)
                      ),
                    )),
                ListTile(
                  iconColor: Colors.blue,
                  textColor: Colors.blue,
                  onTap: () =>
                      Navigator.pushNamed(context, MyRoutes.homeRoustes),
                  leading: const Icon(CupertinoIcons.house_fill),
                  title: const Text("Home"),
                ),
                ListTile(
                  iconColor: Colors.blue,
                  textColor: Colors.blue,
                  onTap: () {
                    var route = MaterialPageRoute(
                        builder: (BuildContext context) => updateuser(id: id));
                    Navigator.of(context).push(route);
                  },
                  leading: const Icon(CupertinoIcons.profile_circled),
                  title: const Text("Profile"),
                ),
                ListTile(
                  iconColor: Colors.blue,
                  textColor: Colors.blue,
                  onTap: () =>
                      Navigator.pushNamed(context, MyRoutes.categoryRoustes),
                  leading: const Icon(Icons.category),
                  title: const Text("Manage Category"),
                ),
                ListTile(
                  iconColor: Colors.blue,
                  textColor: Colors.blue,
                  onTap: () =>
                      Navigator.pushNamed(context, MyRoutes.homeRoustes),
                  leading: const Icon(
                      CommunityMaterialIcons.order_bool_ascending_variant),
                  title: const Text("Manage Orders"),
                ),
                ListTile(
                  iconColor: Colors.blue,
                  textColor: Colors.blue,
                  onTap: () =>
                      Navigator.pushNamed(context, MyRoutes.loginRoustes),
                  leading: const Icon(CupertinoIcons.square_arrow_right_fill),
                  title: const Text("Logout"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
