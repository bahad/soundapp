class Favorite {
  String? id;
  String? name;
  String? path;
  String? category;
  Favorite({this.id, this.name, this.path, this.category});
  Favorite.withId({this.id, this.name, this.path, this.category});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["path"] = path;
    map["category"] = category;
    return map;
  }

  Favorite.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    name = map["name"];
    path = map["path"];
    category = map["category"];
  }
}
