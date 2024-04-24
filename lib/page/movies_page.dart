import 'package:flutter/material.dart';
import '../db/movies_database.dart';
import '../model/movie.dart';
import 'add_edit_movie_page.dart';

class MoviesPage extends StatefulWidget {
  const MoviesPage({Key? key}) : super(key: key);

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  late List<Movie> movies;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshMovies();
  }

  Future refreshMovies() async {
    setState(() => isLoading = true);
    movies = await MoviesDatabase.instance.readAllMovies();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('My Favorite Movies'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddEditMoviePage(),
                ));
                refreshMovies();
              },
            ),
          ],
        ),
        body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : movies.isEmpty
                  ? const Text('No movies yet.')
                  : ListView.builder(
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        final movie = movies[index];
                        return ListTile(
                          title: Text(movie.title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(movie.description),
                              Text('Added: ${movie.addedDate.toString()}'),
                            ],
                          ),
                          leading: Image.network(movie.coverImage),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await MoviesDatabase.instance.delete(movie.id!);
                              refreshMovies();
                            },
                          ),
                          onTap: () async {
                            await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AddEditMoviePage(movie: movie),
                            ));
                            refreshMovies();
                          },
                        );
                      },
                    ),
        ),
      );
}