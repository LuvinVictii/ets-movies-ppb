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
                          subtitle: Text(movie.description),
                          leading: Image.network(movie.coverImage),
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


// class AddEditMoviePage extends StatelessWidget {
//   const AddEditMoviePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Declare TextEditingController untuk menyimpan nilai input pengguna
//     final TextEditingController _titleController = TextEditingController();
//     final TextEditingController _descriptionController = TextEditingController();
//     final TextEditingController _coverImageController = TextEditingController();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add Movie'),
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: _titleController,
//               decoration: const InputDecoration(labelText: 'Title'),
//             ),
//             TextField(
//               controller: _descriptionController,
//               decoration: const InputDecoration(labelText: 'Description'),
//             ),
//             TextField(
//               controller: _coverImageController,
//               decoration: const InputDecoration(labelText: 'Cover Image URL'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 String title = _titleController.text;
//                 String description = _descriptionController.text;
//                 String coverImage = _coverImageController.text;

//                 if (title.isNotEmpty && description.isNotEmpty && coverImage.isNotEmpty) {
//                   await MoviesDatabase.instance.create(Movie(
//                     title: title,
//                     addedDate: DateTime.now(),
//                     description: description,
//                     coverImage: coverImage,
//                   ));
//                   // Refresh halaman MoviesPage setelah menambahkan film baru
//                   Navigator.pop(context);
//                 } else {
//                   // Tampilkan pesan kesalahan jika ada data yang kosong
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Please fill in all fields')),
//                   );
//                 }
//               },
//               child: const Text('Save'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
