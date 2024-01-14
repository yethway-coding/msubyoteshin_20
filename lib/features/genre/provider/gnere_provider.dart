import 'package:flutter/material.dart';
import '/common/models/genre_model.dart';

class GenreProvider extends ChangeNotifier {
  List<GenreModel> list = [];

  int get listCount => list.length;

  changeList(List<GenreModel> list) {
    this.list = list;
    notifyListeners();
  }

  addAll(List<GenreModel> list) {
    this.list.addAll(list);
    notifyListeners();
  }

  add(GenreModel item) {
    list.insert(0, item);
    notifyListeners();
  }

  remove(GenreModel item) {
    var idx = list.indexWhere((e) => e.id == item.id);
    if (idx != -1) {
      list.removeAt(idx);
      notifyListeners();
    }
  }

  update(GenreModel item) {
    var idx = list.indexWhere((e) => e.id == item.id);
    if (idx != -1) {
      list[idx] = item;
      notifyListeners();
    }
  }
}
