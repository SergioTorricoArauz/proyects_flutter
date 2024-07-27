import 'dart:convert';

import 'package:buscador_de_peliculas/models/pelicula.dart';
import 'package:buscador_de_peliculas/pages/detalle_pelicula.dart';
import 'package:buscador_de_peliculas/pages/peliculas_almacenadas.dart';
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
  final peliculaService = PeliculaService();
  final searchController = TextEditingController();
  final yearController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int pagina = 1;
  List<Pelicula> peliculas = [];
  List<Pelicula> resultadosBusqueda = [];
  List<Pelicula> peliculasSeleccionadas = [];

  Future<void> _busquedaAno() async {
    if (yearController.text.isNotEmpty) {
      try {
        resultadosBusqueda = await peliculaService
            .buscarPeliculasPorAno(int.parse(yearController.text));
        _updateState();
      } catch (e) {
        // Manejo de errores
      }
    }
  }

  Future<void> _busquedTexto() async {
    if (searchController.text.isNotEmpty) {
      try {
        resultadosBusqueda =
            await peliculaService.buscarPeliculasTexto(searchController.text);
        _updateState();
      } catch (e) {
        // Manejo de errores
      }
    }
  }

  Future<void> _onRefreshPressed() async {
    try {
      final peliculasCargadas = await cargarPeliculasDelLocalStorage();
      if (mounted) {
        peliculas = peliculasCargadas;
        _updateState();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PeliculasAlmacenadas(
              peliculas: peliculas,
              peliculaService: peliculaService,
            ),
          ),
        );
      }
    } catch (e) {
      // Manejo de errores
    }
  }

  Future<void> _onLoadMorePressed() async {
    try {
      pagina++;
      final masPeliculas = await peliculaService.obtenerListaPeliculas(pagina);
      peliculas.addAll(masPeliculas);
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

  void _navigateToDetailPelicula(
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

  Future<void> almacenarPelicula(Pelicula pelicula) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final peliculasJson = prefs.getStringList('peliculas') ?? [];
      peliculasJson.add(jsonEncode(pelicula.toJson()));
      await prefs.setStringList('peliculas', peliculasJson);
    } catch (e) {
      // Manejo de errores
    }
  }

  Future<List<Pelicula>> cargarPeliculasDelLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final peliculasJson = prefs.getStringList('peliculas') ?? [];
      return peliculasJson
          .map((peliculaJson) => Pelicula.fromJson(jsonDecode(peliculaJson)))
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
                    hintText: 'Buscar película...',
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: _busquedTexto,
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
                onPressed: _busquedaAno,
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _onRefreshPressed,
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
                      : peliculas.length,
                  itemBuilder: (BuildContext context, int index) {
                    Pelicula pelicula = resultadosBusqueda.isNotEmpty
                        ? resultadosBusqueda[index]
                        : peliculas[index];
                    return Card(
                      child: ListTile(
                        leading: pelicula.imageUrl != null &&
                                pelicula.imageUrl!.isNotEmpty
                            ? Image.network(
                                'https://image.tmdb.org/t/p/w200${pelicula.imageUrl}',
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.error),
                              )
                            : const Icon(Icons
                                .error), // imagen por defecto si imageUrl es null
                        title: Text(pelicula.title ?? 'No disponible'),
                        subtitle: Text(
                          pelicula.releaseDate != null
                              ? DateFormat('yyyy-MM-dd')
                                  .format(pelicula.releaseDate!)
                              : 'No disponible',
                        ),
                        onTap: () async {
                          int id = int.parse(pelicula.id.toString());
                          await almacenarPelicula(pelicula);
                          if (mounted) {
                            _navigateToDetailPelicula(
                                context, peliculaService, id);
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _onLoadMorePressed,
                child: const Text('Cargar más'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
