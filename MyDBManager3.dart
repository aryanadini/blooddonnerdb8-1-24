import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBBdonnerManager{
  late Database _database;
  Future openDB() async {
    _database = await openDatabase(join(await getDatabasesPath(), "bdonner.db"),
        version: 1, onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE bdonner(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,age TEXT,bgroup TEXT,phone TEXT,email TEXT)");
        });
  }
  Future<int> insertBdonner(Bdonner bdonner) async {
    await openDB();
    return await _database.insert('bdonner', bdonner.toMap());

  }
  Future<List<Bdonner>> getBdonnerList() async {
    await openDB();
    final List<Map<String, dynamic>> maps = await _database.query('bdonner');
    return List.generate(maps.length, (index) {
      return Bdonner(id: maps[index]['id'], name: maps[index]['name'], age: maps[index]['age'],bgroup: maps[index]['bgroup'],
      phone: maps[index]['phone'],email: maps[index]['email']
      );
    });
  }
  Future<int> updateBdonner(Bdonner bdonner) async {
    await openDB();
    return await _database.update('bdonner', bdonner.toMap(), where: 'id=?', whereArgs: [bdonner.id]);
  }

  Future<void> deleteBdonner(int? id) async {
    await openDB();
    await _database.delete("bdonner", where: "id = ? ", whereArgs: [id]);
  }


}
class Bdonner{
  int? id;
 late String name,age,bgroup,phone,email;
 Bdonner({this.id,required this.name,required this.bgroup,required this.age,required this.phone,required this.email});
 Map<String,dynamic> toMap(){
   return{'name':name,'bgroup':bgroup,'age':age,'phone':phone,'email':email};

 }

}