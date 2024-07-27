import 'package:buscador_de_peliculas/main.dart';
import 'package:buscador_de_peliculas/models/pelicula.dart';
import 'package:buscador_de_peliculas/services/pelicula_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailPelicula extends StatelessWidget {
  final PeliculaService peliculaService;
  final int id;

  const DetailPelicula(
      {super.key, required this.peliculaService, required this.id});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon:
                Image.network('https://img.icons8.com/color/48/themoviedb.png'),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainApp()),
              );
            },
          ),
          title: const Text('Lista de Películas'),
        ),
        body: Center(
          child: FutureBuilder<Pelicula>(
            future: peliculaService.obtenerPeliculasPorId(id),
            builder: (BuildContext context, AsyncSnapshot<Pelicula> snapshot) {
              if (snapshot.hasData) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    SizedBox(
                        child: snapshot.data!.backdropPath != null &&
                                snapshot.data!.backdropPath!.isNotEmpty
                            ? Image.network(
                                'https://image.tmdb.org/t/p/original${snapshot.data!.backdropPath}',
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                'https://img.freepik.com/vector-premium/icono-carga-porcentaje-carga-descarga-progreso-carga-ilustracion-vectorial_266660-667.jpg')),
                    Opacity(
                      opacity: 0.8,
                      child: Container(
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: SizedBox(
                              child: snapshot.data!.imageUrl != null &&
                                      snapshot.data!.imageUrl!.isNotEmpty
                                  ? Image.network(
                                      'https://image.tmdb.org/t/p/original${snapshot.data!.imageUrl}',
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'https://img.freepik.com/vector-premium/icono-carga-porcentaje-carga-descarga-progreso-carga-ilustracion-vectorial_266660-667.jpg'),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(9.0),
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(snapshot.data!.id.toString()),
                                    Text(
                                      ' ${snapshot.data!.title ?? 'No disponible'}',
                                      style: const TextStyle(
                                          fontSize: 30, color: Colors.white),
                                    ),
                                    const Text(
                                      'Fecha de lanzamiento: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          DateFormat('yyyy-MM-dd').format(
                                              DateTime.parse(snapshot
                                                      .data!.releaseDate
                                                      ?.toString() ??
                                                  'No disponible')),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    const Text(
                                      'Duración: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${snapshot.data!.runtime?.toString() ?? 'No disponible'} minutos',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    const Text(
                                      'Géneros: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            snapshot.data!.genres?.join(', ') ??
                                                'No disponible',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Director: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            snapshot.data!.companies
                                                    ?.join(', ') ??
                                                'No disponible',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Text(
                                      'Descripción: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            snapshot.data!.overview ??
                                                'No disponible',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Popularidad: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data!.popularity
                                                  ?.toString() ??
                                              'No disponible',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Calificación: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data!.voteAverage
                                                  ?.toString() ??
                                              'No disponible',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
