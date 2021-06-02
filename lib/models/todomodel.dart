class TodoModel {
  int id;
  String title;
  String description;

  TodoModel(this.title, this.description);

  TodoModel.fromMap(Map<String, dynamic> map) {
    this.title = map['title'];
    this.description = map['description'];
    this.id = map['id'];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['title'] = this.title;
    map['description'] = this.description;
    if (id != null) {
      map['id'] = this.id;
    }
    return map;
  }
}
