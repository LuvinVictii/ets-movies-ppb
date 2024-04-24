import 'package:flutter/material.dart';
import '../db/movies_database.dart';
import '../model/movie.dart';

class AddEditMoviePage extends StatefulWidget {
  final Movie? movie;

  const AddEditMoviePage({Key? key, this.movie}) : super(key: key);

  @override
  _AddEditMoviePageState createState() => _AddEditMoviePageState();
}

class _AddEditMoviePageState extends State<AddEditMoviePage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _coverImageController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.movie?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.movie?.description ?? '');
    _coverImageController =
        TextEditingController(text: widget.movie?.coverImage ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie == null ? 'Add Movie' : 'Edit Movie'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _coverImageController,
              decoration: const InputDecoration(labelText: 'Cover Image URL'),
            ),
            ElevatedButton(
              onPressed: () async {
                String title = _titleController.text;
                String description = _descriptionController.text;
                String coverImage = _coverImageController.text;

                if (title.isNotEmpty && description.isNotEmpty && coverImage.isNotEmpty) {
                  if (widget.movie == null) {
                    await MoviesDatabase.instance.create(Movie(
                      title: title,
                      addedDate: DateTime.now(),
                      description: description,
                      coverImage: coverImage,
                    ));
                  } else {
                    // Perbarui film yang sudah ada
                    await MoviesDatabase.instance.update(widget.movie!.copy(
                      title: title,
                      description: description,
                      coverImage: coverImage,
                    ));
                  }

                  Navigator.of(context).pop(); // Kembali ke halaman sebelumnya setelah menyimpan
                } else {
                  // Tampilkan pesan kesalahan jika ada data yang kosong
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill in all fields')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}