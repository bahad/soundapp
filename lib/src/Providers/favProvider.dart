import 'package:flutter/material.dart';
import 'package:soundapp/src/Services/sqlitedb.dart';

class FavProvider with ChangeNotifier {
  var favList;
  bool isFavMatch = false;
  bool loading = false;
  bool isInsert = false;
  DbHelper? _dbHelper = DbHelper();

  getFav() async {
    loading = true;
    favList = await _dbHelper!.getFavorite();
    loading = false;
    notifyListeners();
  }

  deleteFav(id) async {
    await _dbHelper!.removeFavorite(id);
    notifyListeners();
  }
}
