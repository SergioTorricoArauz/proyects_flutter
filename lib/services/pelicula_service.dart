import 'dart:convert';
import 'package:buscador_de_peliculas/models/series.dart';
import 'package:http/http.dart' as http;
import 'package:buscador_de_peliculas/models/pelicula.dart';
import 'package:logging/logging.dart';

class PeliculaService {
  final _logger = Logger('PeliculaService');
  final client = http.Client();

  Future<List<Pelicula>> obtenerListaPeliculas(int pagina) async {
    try {
      var url =
          'https://api.themoviedb.org/3/movie/top_rated?api_key=b284941f0d978f04beae57bd292c484d&page=$pagina';
      var response = await client.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('No se pudo obtener la lista de películas');
      }

      var jsonResponse = jsonDecode(response.body);
      var peliculas = (jsonResponse['results'] as List<dynamic>)
          .map((item) => Pelicula.fromJson(item))
          .toList();
      return peliculas;
    } catch (e) {
      _logger.severe('Error al obtener la lista de películas: $e');
      rethrow;
    }
  }

  Future<List<Pelicula>> buscarPeliculasTexto(String query) async {
    try {
      var url =
          'https://api.themoviedb.org/3/search/movie?api_key=b284941f0d978f04beae57bd292c484d&query=$query';
      var response = await client.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('No se pudo buscar las películas');
      }

      var jsonResponse = jsonDecode(response.body);
      var peliculas = (jsonResponse['results'] as List<dynamic>)
          .map((item) => Pelicula.fromJson(item))
          .toList();
      return peliculas;
    } catch (e) {
      _logger.severe('Error al buscar las películas: $e');
      rethrow;
    }
  }

  Future<List<Pelicula>> buscarPeliculasPorAno(int year) async {
    try {
      var url =
          'https://api.themoviedb.org/3/discover/movie?api_key=b284941f0d978f04beae57bd292c484d&primary_release_year=$year';
      var response = await client.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('No se pudo buscar las películas');
      }

      var jsonResponse = jsonDecode(response.body);
      var peliculas = (jsonResponse['results'] as List<dynamic>)
          .map((item) => Pelicula.fromJson(item))
          .toList();
      return peliculas;
    } catch (e) {
      _logger.severe('Error al buscar las películas por año: $e');
      rethrow;
    }
  }

  Future<List<Pelicula>> obtenerPeliculasRecomendadas() async {
    try {
      var url =
          'https://api.themoviedb.org/3/movie/popular?api_key=b284941f0d978f04beae57bd292c484d';
      var response = await client.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception(
            'No se pudo obtener la lista de películas recomendadas');
      }

      var jsonResponse = jsonDecode(response.body);
      var peliculas = (jsonResponse['results'] as List<dynamic>)
          .map((item) => Pelicula.fromJson(item))
          .toList();
      return peliculas;
    } catch (e) {
      _logger.severe('Error al obtener las películas recomendadas: $e');
      rethrow;
    }
  }

  Future<Pelicula> obtenerPeliculasPorId(int id) async {
    try {
      var url =
          'https://api.themoviedb.org/3/movie/$id?api_key=b284941f0d978f04beae57bd292c484d';
      var response = await client.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('No se pudo obtener la película con id $id');
      }

      var jsonResponse = jsonDecode(response.body);
      var pelicula = Pelicula.fromJson(jsonResponse);
      return pelicula;
    } catch (e) {
      _logger.severe('Error al obtener la película por id: $e');
      rethrow;
    }
  }

  Future<List<Series>> obtenerSeries(int pagina) async {
    try {
      var url =
          'https://api.themoviedb.org/3/tv/top_rated?api_key=b284941f0d978f04beae57bd292c484d&page=$pagina';
      var response = await client.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('No se pudo obtener la lista de series');
      }

      var jsonResponse = jsonDecode(response.body);
      var peliculas = (jsonResponse['results'] as List<dynamic>)
          .map((item) => Series.fromJson(item))
          .toList();
      return peliculas;
    } catch (e) {
      _logger.severe('Error al obtener la lista de series: $e');
      rethrow;
    }
  }

  Future<List<Series>> buscarSeriesTexto(String query) async {
    try {
      var url =
          'https://api.themoviedb.org/3/search/tv?api_key=b284941f0d978f04beae57bd292c484d&query=$query';
      var response = await client.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('No se pudo buscar las series');
      }

      var jsonResponse = jsonDecode(response.body);
      var peliculas = (jsonResponse['results'] as List<dynamic>)
          .map((item) => Series.fromJson(item))
          .toList();
      return peliculas;
    } catch (e) {
      _logger.severe('Error al buscar las series: $e');
      rethrow;
    }
  }

  Future<List<Series>> buscarSeriesPorAno(int year) async {
    try {
      var url =
          'https://api.themoviedb.org/3/discover/tv?api_key=b284941f0d978f04beae57bd292c484d&first_air_date_year=$year';
      var response = await client.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('No se pudo buscar las series');
      }

      var jsonResponse = jsonDecode(response.body);
      var peliculas = (jsonResponse['results'] as List<dynamic>)
          .map((item) => Series.fromJson(item))
          .toList();
      return peliculas;
    } catch (e) {
      _logger.severe('Error al buscar las series por año: $e');
      rethrow;
    }
  }

  Future<List<Series>> obtenerSeriesId(int id) async {
    try {
      var url =
          'https://api.themoviedb.org/3/tv/$id?api_key=b284941f0d978f04beae57bd292c484d';
      var response = await client.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('No se pudo obtener la serie con id $id');
      }

      var jsonResponse = jsonDecode(response.body);
      var pelicula = Series.fromJson(jsonResponse);
      return [pelicula];
    } catch (e) {
      _logger.severe('Error al obtener la serie por id: $e');
      rethrow;
    }
  }
}
