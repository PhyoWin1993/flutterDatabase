import 'package:dataBase/model/user.dart';
import 'package:flutter/material.dart';
import 'package:dataBase/util/database_helper.dart';
// import 'package:flutter/widgets.dart';

List _user;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var dbs = new DatabaseHelper();
  int saveUs = await dbs.saveUser(new User("Mr John", "Admins"));
  print("Save Data is  $saveUs");
  int coutn = await dbs.getCount();
  print("Counta value ==>> $coutn");

  print("**********************");
  _user = await dbs.getAllUser();

  for (int i = 0; i < _user.length; i++) {
    User user = User.map(_user[i]);
    print(
        "User Name ==>> ${user.username}  and ${user.password} and user id ==>${user.id}");
  }

  // delete user

  // int deleteUser = await dbs.deleteUser(1);
  // print("Delete  user == > $deleteUser");

  // update User

  User naa = await dbs.getUser(7);
  User updateUser = User.fromMap(
      {"username": "Update Username", "password": "Update Amdin", "id": 7});
  //update
  await dbs.updataUser(updateUser);
  print("update data ${naa.id} and ${naa.username} and ${naa.password}");

/////////////////////////////////
  runApp(new MaterialApp(
    title: "DataBase Learnign",
    home: new Home(),
  ));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Database Learn"),
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
      ),

      //
      body: new ListView.builder(
          itemCount: _user.length,
          itemBuilder: (_, int position) {
            return new Card(
              color: Colors.white,
              elevation: 2.0,
              child: new ListTile(
                leading: new CircleAvatar(
                  child: new Text(
                      "${User.fromMap(_user[position]).username.substring(0, 1)}"),
                ),
                title: new Text(
                    "User : ${User.fromMap(_user[position]).username}"),
                subtitle: new Text("Id : ${User.fromMap(_user[position]).id}"),
              ),
            );
          }),
    );
  }
}
