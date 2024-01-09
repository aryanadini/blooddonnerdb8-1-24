import 'package:flutter/material.dart';

import 'MyDBManager3.dart';

class Db3 extends StatefulWidget {
  const Db3({super.key});

  @override
  State<Db3> createState() => _Db3State();
}

class _Db3State extends State<Db3> {
  final DBBdonnerManager dbBdonnerManager = DBBdonnerManager();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _bgroupController=TextEditingController();
  final _phoneController=TextEditingController();
  final _emailController=TextEditingController();
  final _formkey = GlobalKey<FormState>();
  Bdonner? bdonner;
  late int updateindex;

  late List<Bdonner> bdonnerlist;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return  Scaffold(
      appBar: AppBar(
        title: Text("Bdonner Example"),
      ),
      body: ListView(
        children: <Widget>[
          Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: "Name"),
                    controller: _nameController,
                    validator: (val) =>
                    val!.isNotEmpty ? null : "Name Should not be Empty",
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Age"),
                    controller: _ageController,
                    validator: (val) =>
                    val!.isNotEmpty ? null : "age Should not be Empty",
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Bgroup"),
                    controller: _bgroupController,
                    validator: (val) =>
                    val!.isNotEmpty ? null : "bgroup Should not be Empty",
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Phone"),
                    controller: _phoneController,
                    validator: (val) =>
                    val!.isNotEmpty ? null : "Phone Should not be Empty",
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Email"),
                    controller: _emailController,
                    validator: (val) =>
                    val!.isNotEmpty ? null : "Email Should not be Empty",
                  ),

                  ElevatedButton(

                    child: Container(
                        width: width * 0.9,
                        child: Text(
                          "Submit",
                          textAlign: TextAlign.center,
                        )),
                    onPressed: () {
                      submitBdonner(context);
                    },
                  ),
                  FutureBuilder(
                    future: dbBdonnerManager.getBdonnerList(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        bdonnerlist = snapshot.data as List<Bdonner>;
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: bdonnerlist == null ? 0 : bdonnerlist.length,
                          itemBuilder: (BuildContext context, int index) {
                            Bdonner bd = bdonnerlist[index];
                            return Card(
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: SizedBox(
                                      width: width * 0.50,
                                      child: Column(
                                        children: <Widget>[
                                          Text('ID: ${bd.id}'),
                                          Text('Name: ${bd.name}'),
                                          Text("Age:${bd.age}"),
                                          Text('Bldgroup:${bd.bgroup}'),
                                          Text('Phone:${bd.phone}'),
                                          Text('Email:${bd.email}'),
                                        ],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _nameController.text = bd.name;
                                      _ageController.text=bd.age;
                                      _phoneController.text = bd.phone;
                                      _emailController.text=bd.email;
                                      _bgroupController.text=bd.bgroup;
                                      bdonner = bd;
                                      updateindex = index;
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      dbBdonnerManager.deleteBdonner(bd.id);
                                      setState(() {
                                        bdonnerlist.removeAt(index);
                                      });
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                      return CircularProgressIndicator();
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),


    );
  }

  void submitBdonner(BuildContext context) {
    if (_formkey.currentState!.validate()) {
      if (bdonner == null) {
        Bdonner bd =  Bdonner(
            name: _nameController.text, age:_ageController.text,bgroup:_bgroupController.text,phone:_phoneController.text,email:_emailController.text);
        dbBdonnerManager.insertBdonner(bd).then((value) => {
          _nameController.clear(),
          _ageController.clear(),
          _bgroupController.clear(),
          _phoneController.clear(),

          _emailController.clear(),
          print("Bdonner Data Add to database $value"),
        });
      }
      else {
        bdonner?.name = _nameController.text;
        bdonner?.age = _ageController.text;
        bdonner?.phone=_phoneController.text;
        bdonner?.bgroup=_bgroupController.text;
        bdonner?.email=_emailController.text;

        dbBdonnerManager.updateBdonner(bdonner!).then((value) {
          setState(() {
            bdonnerlist[updateindex].name = _nameController.text;
            bdonnerlist[updateindex].age = _ageController.text;
            bdonnerlist[updateindex].bgroup=_bgroupController.text;
            bdonnerlist[updateindex].phone=_phoneController.text;
            bdonnerlist[updateindex].email=_emailController.text;
          });
          _nameController.clear();
          _ageController.clear();
          _bgroupController.clear();
          _phoneController.clear();
          _emailController.clear();

          bdonner=null;
        });
      }
    }
  }
}
