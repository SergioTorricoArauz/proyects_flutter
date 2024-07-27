import 'dart:convert';

import 'package:buscador_de_peliculas/models/series.dart';
import 'package:buscador_de_peliculas/pages/detalle_serie.dart';
import 'package:buscador_de_peliculas/pages/series_almacenadas.dart';
import 'package:buscador_de_peliculas/services/pelicula_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final logger = Logger('LoggerMain');
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    logger.info('${record.level.name}: ${record.time}: ${record.message}');
  });
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  MainApp({Key? key}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final seriesService = PeliculaService();
  final searchController = TextEditingController();
  final yearController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int pagina = 1;
  List<Series> series = [];
  List<Series> resultadosBusqueda = [];
  List<Series> seriesSeleccionadas = [];

  Future<void> _busquedaAnoSerie() async {
    if (yearController.text.isNotEmpty) {
      try {
        resultadosBusqueda = await seriesService
            .buscarSeriesPorAno(int.parse(yearController.text));
        _updateState();
      } catch (e) {
        // Manejo de errores
      }
    }
  }

  Future<void> _busquedTextoSerie() async {
    if (searchController.text.isNotEmpty) {
      try {
        resultadosBusqueda =
            await seriesService.buscarSeriesTexto(searchController.text);
        _updateState();
      } catch (e) {
        // Manejo de errores
      }
    }
  }

  Future<void> _onRefreshPressedSerie() async {
    try {
      final peliculasCargadas = await cargarPeliculasDelLocalStorage();
      if (mounted) {
        series = peliculasCargadas;
        _updateState();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SeriesAlmacenadas(
              peliculas: series,
              peliculaService: series,
            ),
          ),
        );
      }
    } catch (e) {
      // Manejo de errores
    }
  }

  Future<void> _onLoadMorePressedSerie() async {
    try {
      pagina++;
      final masPeliculas = await seriesService.obtenerSeries(pagina);
      series.addAll(masPeliculas);
      _updateState();
    } catch (e) {
      // Manejo de errores
    }
  }

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  void _navigateToDetailSerie(
      BuildContext context, PeliculaService peliculaService, int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPelicula(
          peliculaService: peliculaService,
          id: id,
        ),
      ),
    );
  }

  Future<void> almacenarSerie(Series pelicula) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final peliculasJson = prefs.getStringList('sereies') ?? [];
      peliculasJson.add(jsonEncode(pelicula.toJson()));
      await prefs.setStringList('sereies', peliculasJson);
    } catch (e) {
      // Manejo de errores
    }
  }

  Future<List<Series>> cargarPeliculasDelLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final peliculasJson = prefs.getStringList('sereies') ?? [];
      return peliculasJson
          .map((peliculaJson) => Series.fromJson(jsonDecode(peliculaJson)))
          .toList();
    } catch (e) {
      // Manejo de errores
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: 'Buscar serie...',
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: _busquedTextoSerie,
              ),
              Expanded(
                child: TextField(
                  controller: yearController,
                  decoration: const InputDecoration(
                    hintText: 'Año de lanzamiento...',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: _busquedaAnoSerie,
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _onRefreshPressedSerie,
              )
            ],
          ),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: resultadosBusqueda.isNotEmpty
                      ? resultadosBusqueda.length
                      : series.length,
                  itemBuilder: (BuildContext context, int index) {
                    Series serie = resultadosBusqueda.isNotEmpty
                        ? resultadosBusqueda[index]
                        : series[index];
                    return Card(
                      child: ListTile(
                        leading: serie.backdropPath.isNotEmpty
                            ? Image.network(
                                'https://image.tmdb.org/t/p/w200${serie.backdropPath}',
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.error),
                              )
                            : const Icon(Icons
                                .error), // imagen por defecto si imageUrl es null
                        title: Text(serie.name),
                        onTap: () async {
                          int id = int.parse(serie.id.toString());
                          await almacenarSerie(serie);
                          if (mounted) {
                            _navigateToDetailSerie(context, seriesService, id);
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _onLoadMorePressedSerie,
                child: const Text('Cargar más'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
