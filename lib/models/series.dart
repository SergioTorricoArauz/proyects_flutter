import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

final _logger = Logger('Pelicula');

class Series {
  bool adult;
  String backdropPath;
  List<CreatedBy> createdBy;
  List<int> episodeRunTime;
  List<Genre> genres;
  String homepage;
  int id;
  bool inProduction;
  List<String> languages;
  String name;
  dynamic nextEpisodeToAir;
  int numberOfEpisodes;
  int numberOfSeasons;
  List<String> originCountry;
  String originalLanguage;
  String originalName;
  String overview;
  double popularity;
  String posterPath;
  List<Season> seasons;
  String status;
  String tagline;

  Series({
    required this.adult,
    required this.backdropPath,
    required this.createdBy,
    required this.episodeRunTime,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.inProduction,
    required this.languages,
    required this.name,
    required this.nextEpisodeToAir,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.seasons,
    required this.status,
    required this.tagline,
  });

  factory Series.fromJson(Map<String, dynamic> json) {
    var firstAirDate = json['first_air_date'];
    if (firstAirDate is String && firstAirDate.isNotEmpty) {
      try {} catch (e) {
        _logger.severe('Error parsing date: $e');
      }
    }

    var lastAirDate = json['last_air_date'];
    if (lastAirDate is String && lastAirDate.isNotEmpty) {
      try {} catch (e) {
        _logger.severe('Error parsing date: $e');
      }
    }

    List<CreatedBy> createdBy = json['created_by'] != null
        ? List<CreatedBy>.from(
            json['created_by'].map((x) => CreatedBy.fromJson(x)))
        : [];

    List<Genre> genres = json['genres'] != null
        ? List<Genre>.from(json['genres'].map((x) => Genre.fromJson(x)))
        : [];

    List<Season> seasons = json['seasons'] != null
        ? List<Season>.from(json['seasons'].map((x) => Season.fromJson(x)))
        : [];

    return Series(
      adult: json['adult'],
      backdropPath: json['backdrop_path'],
      createdBy: createdBy,
      episodeRunTime: List<int>.from(json['episode_run_time']),
      genres: genres,
      homepage: json['homepage'],
      id: json['id'],
      inProduction: json['in_production'],
      languages: List<String>.from(json['languages']),
      name: json['name'],
      nextEpisodeToAir: json['next_episode_to_air'],
      numberOfEpisodes: json['number_of_episodes'],
      numberOfSeasons: json['number_of_seasons'],
      originCountry: List<String>.from(json['origin_country']),
      originalLanguage: json['original_language'],
      originalName: json['original_name'],
      overview: json['overview'],
      popularity: json['popularity'],
      posterPath: json['poster_path'],
      seasons: seasons,
      status: json['status'],
      tagline: json['tagline'],
    );
  }

  Map<String, dynamic> toJson() => {
        'adult': adult,
        'backdrop_path': backdropPath,
        'episode_run_time': episodeRunTime,
        'homepage': homepage,
        'id': id,
        'in_production': inProduction,
        'languages': languages,
        'name': name
      };
}

class CreatedBy {
  final String name;
  final int id;

  CreatedBy({required this.name, required this.id});

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      name: json['name'],
      id: json['id'],
    );
  }
}

class Genre {
  int id;
  String name;

  Genre({
    required this.id,
    required this.name,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Season {
  DateTime? airDate;
  int episodeCount;
  int id;
  String name;
  String overview;
  String? posterPath;
  int seasonNumber;

  Season({
    required this.airDate,
    required this.episodeCount,
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.seasonNumber,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    var airDate = json['air_date'];
    DateTime? parsedDate;
    if (airDate is String && airDate.isNotEmpty) {
      try {
        parsedDate = DateFormat('yyyy-MM-dd').parseStrict(airDate);
      } catch (e) {
        _logger.severe('Error parsing date: $e');
        parsedDate = null;
      }
    }

    return Season(
      airDate: parsedDate,
      episodeCount: json['episode_count'],
      id: json['id'],
      name: json['name'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      seasonNumber: json['season_number'],
    );
  }
}

class SpokenLanguage {
  String englishName;
  String iso6391;
  String name;

  SpokenLanguage({
    required this.englishName,
    required this.iso6391,
    required this.name,
  });

  factory SpokenLanguage.fromJson(Map<String, dynamic> json) {
    return SpokenLanguage(
      englishName: json['english_name'],
      iso6391: json['iso_639_1'],
      name: json['name'],
    );
  }
}
