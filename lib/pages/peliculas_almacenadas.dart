import 'package:buscador_de_peliculas/models/pelicula.dart';
import 'package:buscador_de_peliculas/pages/detalle_pelicula.dart';
import 'package:buscador_de_peliculas/services/pelicula_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PeliculasAlmacenadas extends StatelessWidget {
  final List<Pelicula> peliculas;
  final PeliculaService peliculaService;

  const PeliculasAlmacenadas({
    super.key,
    required this.peliculas,
    required this.peliculaService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peliculas Almacenadas'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: peliculas.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildPeliculaItem(context, peliculas[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeliculaItem(BuildContext context, Pelicula pelicula) {
    return Card(
      child: ListTile(
        leading: pelicula.imageUrl != null && pelicula.imageUrl!.isNotEmpty
            ? Image.network(
                'https://image.tmdb.org/t/p/w200${pelicula.imageUrl}',
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error),
              )
            : const Icon(Icons.error),
        title: Text(pelicula.title ?? 'No disponible'),
        subtitle: Text(
          pelicula.releaseDate != null
              ? DateFormat('yyyy-MM-dd').format(pelicula.releaseDate!)
              : 'No disponible',
        ),
        onTap: () {
          int id = int.parse(pelicula.id.toString());
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPelicula(
                peliculaService: peliculaService,
                id: id,
              ),
            ),
          );
        },
      ),
    );
  }
}
