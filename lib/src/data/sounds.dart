class Sounds {
  String? name;
  String? path;
  String? category;

  Sounds({this.name, this.path, this.category});

  Sounds.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    path = json['path'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['path'] = this.path;
    data['category'] = this.category;
    return data;
  }
}
