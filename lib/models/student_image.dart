import 'dart:convert';

Image imageFromJson(String str) => Image.fromJson(json.decode(str));

String imageToJson(Image data) => json.encode(data.toJson());

class Image {
  String id;
  String file;

  Image({
    required this.id,
    required this.file,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        id: json["id"],
        file: json["file"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "file": file,
      };
}
