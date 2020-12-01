class Reminders {
  String name;
  String dateTime;
  Reminders(String name, String dateTime) {
    this.name = name;
    this.dateTime = dateTime;
  }
  Reminders.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        dateTime = json['dateTime'];
  Map<String, dynamic> toJson() => {'name': name, 'dateTime': dateTime};
}
