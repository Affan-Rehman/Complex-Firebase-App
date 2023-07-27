class myUser {
  String? name = "";
  String? email = "";
  String? date = "";
  List<Task> tasks = [];


  myUser(this. name, this.email, this.date);
}

class Task {
  late String name;
  late String date;

  Task(this.name, this.date);
    Map<String, dynamic> toMap() {
    return {
      'name': name,
      'date': date,
    };
  }
}
