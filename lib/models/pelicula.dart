import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

final _logger = Logger('Pelicula');

class Pelicula {
  final int? id;
  String? title;
  String? name;
  DateTime? releaseDate;
  int? runtime;
  List<String>? genres;
  List<String>? directing;
  List<String>? companies;
  String? overview;
  String? imageUrl;
  String? backdropPath;
  double? popularity;
  double? voteAverage;

  Pelicula({
    this.id,
    this.title,
    this.name,
    this.releaseDate,
    this.runtime,
    this.genres,
    this.overview,
    this.imageUrl,
    this.backdropPath,
    this.popularity,
    this.voteAverage,
    this.directing,
    this.companies,
  });

  factory Pelicula.fromJson(Map<String, dynamic> json) {
    var releaseDate = json['release_date'];
    DateTime? parsedDate;
    if (releaseDate is String && releaseDate.isNotEmpty) {
      try {
        parsedDate = DateFormat('yyyy-MM-dd').parseStrict(releaseDate);
      } catch (e) {
        _logger.severe('Error parsing date: $e');
        parsedDate = null;
      }
    }

    var pelicula = Pelicula(
      id: json['id'],
      title: json['title'],
      releaseDate: parsedDate,
      runtime: json['runtime'],
      genres: json['genres'] != null
          ? List<String>.from(json['genres'].map((x) => x['name'].toString()))
          : [],
      name: json['name'],
      overview: json['overview'],
      imageUrl: json['poster_path'],
      backdropPath: json['backdrop_path'],
      popularity: json['popularity'],
      voteAverage: json['vote_average'],
      directing: json['directing'] != null
          ? List<String>.from(
              json['directing'].map((x) => x['name'].toString()))
          : [],
      companies: json['production_companies'] != null
          ? List<String>.from(
              json['production_companies'].map((x) => x['name'].toString()))
          : [],
    );

    return pelicula;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'name': name,
        'release_date': releaseDate != null
            ? DateFormat('yyyy-MM-dd').format(releaseDate!)
            : null,
        'runtime': runtime,
        'genres': genres,
        'overview': overview,
        'poster_path': imageUrl,
        'backdrop_path': backdropPath,
        'popularity': popularity,
        'vote_average': voteAverage,
        'directing': directing ?? '',
        'production_companies': companies ?? '',
      };
}
