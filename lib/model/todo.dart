class ToDo{
  int id = -1;
  int user_id;
  String title;
  String due_on;
  String status;

  ToDo(this.title, this.due_on, this.status, this.user_id);
  ToDo.fromJson(Map<String, dynamic> json) :
        title = json["title"],
        id = json["id"] ?? -1,
        user_id = json["user_id"],
        status = json["status"],
        due_on = json["due_on"];

  Map<String, dynamic> toJson() => {
    'title': title,
    'id': id,
    'user_id': user_id,
    'status': status,
    'due_on': due_on
  };
}