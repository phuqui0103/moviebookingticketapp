import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Model/Movie.dart';
import '../../Model/Comment.dart';

class CommentManagementScreen extends StatefulWidget {
  const CommentManagementScreen({Key? key}) : super(key: key);

  @override
  _CommentManagementScreenState createState() =>
      _CommentManagementScreenState();
}

class _CommentManagementScreenState extends State<CommentManagementScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _selectedMovieId;
  List<Movie> _movies = [];
  List<Comment> _comments = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMovies();
    _loadAllComments(); // Load tất cả bình luận khi vừa vào
  }

  Future<void> _loadMovies() async {
    try {
      final moviesSnapshot = await _firestore.collection('movies').get();
      setState(() {
        _movies = moviesSnapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return Movie.fromJson(data);
        }).toList();
      });
    } catch (e) {
      print('Error loading movies: $e');
    }
  }

  Future<void> _loadAllComments() async {
    setState(() => _isLoading = true);
    try {
      final commentsSnapshot = await _firestore
          .collection('comments')
          .orderBy('createdAt', descending: true)
          .get();

      final List<Comment> comments = [];

      for (var doc in commentsSnapshot.docs) {
        try {
          final data = doc.data();
          data['id'] = doc.id;

          // Get user name from userId
          final userDoc =
              await _firestore.collection('users').doc(data['userId']).get();
          if (userDoc.exists) {
            data['userName'] = userDoc.data()?['fullName'] ?? 'Unknown User';
          } else {
            data['userName'] = 'Unknown User';
          }

          if (!data.containsKey('ticketId')) {
            data['ticketId'] = '';
          }

          comments.add(Comment.fromMap(data));
        } catch (e) {
          print('Error processing comment: $e');
          continue;
        }
      }

      setState(() {
        _comments = comments;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading comments: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadComments(String movieId) async {
    setState(() => _isLoading = true);
    try {
      final commentsSnapshot = await _firestore
          .collection('comments')
          .where('movieId', isEqualTo: movieId)
          .orderBy('createdAt', descending: true)
          .get();

      final List<Comment> comments = [];

      for (var doc in commentsSnapshot.docs) {
        try {
          final data = doc.data();
          data['id'] = doc.id;

          // Get user name from userId
          final userDoc =
              await _firestore.collection('users').doc(data['userId']).get();
          if (userDoc.exists) {
            data['userName'] = userDoc.data()?['fullName'] ?? 'Unknown User';
          } else {
            data['userName'] = 'Unknown User';
          }

          if (!data.containsKey('ticketId')) {
            data['ticketId'] = '';
          }

          comments.add(Comment.fromMap(data));
        } catch (e) {
          print('Error processing comment: $e');
          continue;
        }
      }

      setState(() {
        _comments = comments;
        _selectedMovieId = movieId;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading comments: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteComment(String commentId) async {
    try {
      await _firestore.collection('comments').doc(commentId).delete();

      // Refresh comments
      if (_selectedMovieId != null) {
        _loadComments(_selectedMovieId!);
      } else {
        _loadAllComments();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã xóa bình luận'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error deleting comment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lỗi khi xóa bình luận'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff252429), Color(0xff1a1a1a)],
          ),
        ),
        child: Column(
          children: [
            // Dropdown chọn phim
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              width: double.infinity,
              child: DropdownButtonFormField<String?>(
                value: _selectedMovieId,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  filled: true,
                  fillColor: Colors.black12,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.orange.withOpacity(0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.orange.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.orange),
                  ),
                ),
                dropdownColor: const Color(0xff252429),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text(
                      'Tất cả phim',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ..._movies.map((movie) {
                    return DropdownMenuItem(
                      value: movie.id,
                      child: Text(
                        movie.title,
                        style: const TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                ],
                onChanged: (value) {
                  setState(() => _selectedMovieId = value);
                  if (value != null) {
                    _loadComments(value);
                  } else {
                    _loadAllComments();
                  }
                },
              ),
            ),
            // Danh sách bình luận
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.orange,
                      ),
                    )
                  : _comments.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.comment_outlined,
                                size: 64,
                                color: Colors.grey[700],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Không có bình luận nào',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: _comments.length,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemBuilder: (context, index) {
                            final comment = _comments[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                    color: Colors.orange.withOpacity(0.3)),
                              ),
                              color: Colors.black12,
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor:
                                              Colors.orange.withOpacity(0.2),
                                          child: const Icon(Icons.person,
                                              color: Colors.orange),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                comment.userName,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                _formatDateTime(
                                                    comment.createdAt),
                                                style: TextStyle(
                                                  color: Colors.grey[500],
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.orange
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons.star,
                                                    color: Colors.orange,
                                                    size: 16,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '${comment.rating}/10',
                                                    style: const TextStyle(
                                                      color: Colors.orange,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete_outline,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    backgroundColor:
                                                        const Color(0xff252429),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      side: BorderSide(
                                                          color: Colors.orange
                                                              .withOpacity(
                                                                  0.3)),
                                                    ),
                                                    title: const Text(
                                                      'Xác nhận xóa',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    content: const Text(
                                                      'Bạn có chắc chắn muốn xóa bình luận này?',
                                                      style: TextStyle(
                                                        color: Colors.white70,
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: const Text(
                                                          'Hủy',
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          _deleteComment(
                                                              comment.id);
                                                        },
                                                        child: const Text(
                                                          'Xóa',
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.black26,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.orange.withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        comment.content,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
