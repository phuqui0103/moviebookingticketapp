import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart'; // Thêm cho định dạng ngày
import 'package:cached_network_image/cached_network_image.dart'; // Thêm thư viện để sử dụng CachedNetworkImage

import '../../Model/Movie.dart';
import '../../Model/Genre.dart';
import '../../Data/data.dart';

class MovieEditScreen extends StatefulWidget {
  final bool isEdit;
  final Movie? movie;

  const MovieEditScreen({Key? key, required this.isEdit, this.movie})
      : super(key: key);

  @override
  _MovieEditScreenState createState() => _MovieEditScreenState();
}

class _MovieEditScreenState extends State<MovieEditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _durationController;
  late TextEditingController _releaseDateController;
  late TextEditingController _descriptionController;
  late TextEditingController _trailerUrlController;
  late TextEditingController _directorController;
  late TextEditingController _castController;
  late List<Genre> _selectedGenres;
  File? _imageFile;
  DateTime _selectedDate = DateTime.now(); // Mặc định là ngày hiện tại
  bool _isShowingNow = false; // Trạng thái phim đang chiếu

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.movie != null) {
      _titleController = TextEditingController(text: widget.movie!.title);
      _durationController = TextEditingController(text: widget.movie!.duration);
      _releaseDateController =
          TextEditingController(text: widget.movie!.releaseDate);
      _descriptionController =
          TextEditingController(text: widget.movie!.description);
      _trailerUrlController =
          TextEditingController(text: widget.movie!.trailerUrl);
      _directorController = TextEditingController(text: widget.movie!.director);
      _castController =
          TextEditingController(text: widget.movie!.cast.join(", "));
      _selectedGenres = List.from(widget.movie!.genres);
      if (!widget.movie!.imagePath.startsWith('http')) {
        _imageFile = File(widget.movie!.imagePath);
      }
      _isShowingNow = widget.movie!.isShowingNow; // Lấy trạng thái phim
    } else {
      _titleController = TextEditingController();
      _durationController = TextEditingController();
      _releaseDateController = TextEditingController();
      _descriptionController = TextEditingController();
      _trailerUrlController = TextEditingController();
      _directorController = TextEditingController();
      _castController = TextEditingController();
      _selectedGenres = [];
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _releaseDateController.dispose();
    _descriptionController.dispose();
    _trailerUrlController.dispose();
    _directorController.dispose();
    _castController.dispose();
    super.dispose();
  }

  void _selectGenres(List<Genre> selectedGenres) {
    setState(() {
      _selectedGenres = selectedGenres;
    });
  }

  // Chọn ảnh từ máy hoặc chụp ảnh
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        _releaseDateController.text =
            DateFormat('dd-MM-yyyy').format(_selectedDate);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? "Chỉnh sửa Phim" : "Thêm Phim"),
        backgroundColor: Colors.orange,
      ),
      backgroundColor: const Color(0xff252429),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Chọn ảnh từ máy hoặc chụp ảnh
              Container(
                width: 250,
                child: ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.add_photo_alternate),
                  label: Text(
                    _imageFile == null
                        ? 'Chọn Poster Phim'
                        : 'Thay Đổi Poster Phim',
                    style: const TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 200,
                height: 300, // Tăng chiều cao
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orange.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black12,
                ),
                child: _imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _imageFile!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : widget.movie?.imagePath != null &&
                            widget.movie!.imagePath.startsWith('http')
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: widget.movie!.imagePath,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.orange,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Center(
                                child: Icon(
                                  Icons.error,
                                  color: Colors.orange,
                                  size: 40,
                                ),
                              ),
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Center(
                            child: Icon(
                              Icons.movie,
                              size: 50,
                              color: Colors.orange,
                            ),
                          ),
              ),
              const SizedBox(height: 20),
              // Tên Phim
              _buildTextField(_titleController, "Tên Phim", Icons.movie),
              _buildTextField(_durationController, "Thời gian", Icons.timer),
              _buildTextField(
                _releaseDateController,
                "Ngày phát hành",
                Icons.calendar_today,
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              _buildTextField(
                _descriptionController,
                "Mô tả",
                Icons.description,
                maxLines: 3,
              ),
              _buildTextField(
                _trailerUrlController,
                "URL Trailer",
                Icons.play_circle_filled,
              ),
              _buildTextField(
                  _directorController, "Tên Đạo Diễn", Icons.person),
              _buildTextField(_castController, "Diễn Viên", Icons.people),

              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Thể loại phim",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    MultiSelectChip(
                      genres: Genres,
                      selectedGenres: _selectedGenres,
                      onSelectionChanged: _selectGenres,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Switch với style mới
              Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: SwitchListTile(
                  title: const Text(
                    "Phim đang chiếu",
                    style: TextStyle(color: Colors.white70),
                  ),
                  value: _isShowingNow,
                  onChanged: (value) {
                    setState(() {
                      _isShowingNow = value;
                    });
                  },
                  activeColor: Colors.orange,
                ),
              ),

              const SizedBox(height: 20),

              // Nút lưu
              ElevatedButton(
                onPressed: () {
                  if (_titleController.text.isEmpty ||
                      _durationController.text.isEmpty ||
                      _releaseDateController.text.isEmpty ||
                      _descriptionController.text.isEmpty ||
                      _trailerUrlController.text.isEmpty ||
                      _selectedGenres.isEmpty ||
                      _directorController.text.isEmpty ||
                      _castController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Vui lòng điền đầy đủ thông tin!'),
                      backgroundColor: Colors.red,
                    ));
                    return;
                  }

                  final newMovie = Movie(
                    id: widget.isEdit
                        ? widget.movie!.id
                        : "movie_${DateTime.now().millisecondsSinceEpoch}",
                    title: _titleController.text,
                    imagePath: _imageFile?.path ??
                        widget.movie?.imagePath ??
                        "", // Lưu đường dẫn file
                    trailerUrl: _trailerUrlController.text,
                    duration: _durationController.text,
                    releaseDate: _releaseDateController.text,
                    description: _descriptionController.text,
                    genres: _selectedGenres,
                    rating: widget.isEdit
                        ? widget.movie!.rating
                        : 0, // Mặc định, không cần chỉnh sửa rating
                    isShowingNow:
                        _isShowingNow, // Lưu trạng thái phim đang chiếu
                    cast: _castController.text.split(", "),
                    reviewCount: 0, // Không cần chỉnh sửa review count
                    comments: [],
                    director: _directorController.text, // Lưu tên đạo diễn
                  );

                  if (!widget.isEdit) {
                    setState(() {
                      movies.add(newMovie);
                    });
                  } else {
                    setState(() {
                      final index =
                          movies.indexWhere((m) => m.id == widget.movie!.id);
                      if (index != -1) {
                        movies[index] = newMovie;
                      }
                    });
                  }

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "LƯU",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          prefixIcon: Icon(icon, color: Colors.orange),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.orange.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.orange),
          ),
          filled: true,
          fillColor: Colors.black12,
        ),
      ),
    );
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<Genre> genres;
  final List<Genre> selectedGenres;
  final Function(List<Genre>) onSelectionChanged;

  const MultiSelectChip({
    Key? key,
    required this.genres,
    required this.selectedGenres,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  State<MultiSelectChip> createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<Genre> _selectedGenres = [];

  @override
  void initState() {
    super.initState();
    _selectedGenres = List.from(widget.selectedGenres);
  }

  @override
  void didUpdateWidget(MultiSelectChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedGenres != widget.selectedGenres) {
      _selectedGenres = List.from(widget.selectedGenres);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: widget.genres.map((genre) {
        return FilterChip(
          label: Text(genre.name),
          selected: _selectedGenres.contains(genre),
          selectedColor: Colors.orange.withOpacity(0.7),
          checkmarkColor: Colors.white,
          onSelected: (isSelected) {
            setState(() {
              if (isSelected) {
                _selectedGenres.add(genre);
              } else {
                _selectedGenres.removeWhere((g) => g.id == genre.id);
              }
              widget.onSelectionChanged(_selectedGenres);
            });
          },
        );
      }).toList(),
    );
  }
}
