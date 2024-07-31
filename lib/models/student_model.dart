class Student {
  int? id;
  String studentName;
  String lastName;
  DateTime birthDate;
  DateTime registrationDate;
  DateTime registrationEndDate;
  String imagePath;

  Student({
    this.id,
    required this.studentName,
    required this.lastName,
    required this.birthDate,
    required this.registrationDate,
    required this.registrationEndDate,
    required this.imagePath,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json["id"] is int
          ? json["id"]
          : int.tryParse(json["id"].toString()) ?? 0,
      studentName: json["studentName"]?.toString() ?? '',
      lastName: json["lastName"]?.toString() ?? '',
      birthDate: DateTime.parse(json["birthDate"].toString()),
      registrationDate: DateTime.parse(json["registrationDate"].toString()),
      registrationEndDate:
          DateTime.parse(json["registrationEndDate"].toString()),
      imagePath: json["imagePath"]?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "studentName": studentName,
        "lastName": lastName,
        "birthDate": birthDate.toIso8601String(),
        "registrationDate": registrationDate.toIso8601String(),
        "registrationEndDate": registrationEndDate.toIso8601String(),
        "imagePath": imagePath,
      };
}
