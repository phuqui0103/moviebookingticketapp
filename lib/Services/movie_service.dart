import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/Movie.dart';
import '../Model/Genre.dart';
import '../Model/Comment.dart';

class MovieService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = 'movies';

  // Lấy danh sách phim
  Stream<List<Movie>> getMovies() {
    return _firestore.collection(collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        try {
          final data = doc.data();
          return Movie.fromJson({...data, 'id': doc.id});
        } catch (e) {
          return Movie(
            id: doc.id,
            title: 'Error loading movie',
            imagePath: '',
            trailerUrl: '',
            duration: 'N/A',
            genres: [], // Empty list of genres
            rating: 0,
            isShowingNow: false,
            description: '',
            cast: [],
            reviewCount: 0,
            releaseDate: '',
            director: '',
            comments: [],
          );
        }
      }).toList();
    });
  }

  // Thêm phim mới
  Future<String> addMovie(Movie movie) async {
    try {
      final docRef = await _firestore.collection(collection).add({
        ...movie.toJson(),
        'genres': movie.genres.map((genre) => genre.toJson()).toList(),
      });
      return docRef.id;
    } catch (e) {
      print('Error adding movie: $e');
      throw e;
    }
  }

  // Cập nhật phim
  Future<void> updateMovie(Movie movie) async {
    try {
      await _firestore.collection(collection).doc(movie.id).update({
        ...movie.toJson(),
        'genres': movie.genres.map((genre) => genre.toJson()).toList(),
      });
    } catch (e) {
      print('Error updating movie: $e');
      throw e;
    }
  }

  // Xóa phim
  Future<void> deleteMovie(String id) async {
    try {
      await _firestore.collection(collection).doc(id).delete();
    } catch (e) {
      print('Error deleting movie: $e');
      throw e;
    }
  }

  // Lấy phim theo ID
  Future<Movie?> getMovieById(String id) async {
    try {
      final doc = await _firestore.collection(collection).doc(id).get();
      if (doc.exists) {
        final data = doc.data()!;
        return Movie.fromJson({...data, 'id': doc.id});
      }
      return null;
    } catch (e) {
      print('Error getting movie: $e');
      throw e;
    }
  }

  // Lấy danh sách phim theo thể loại
  Stream<List<Movie>> getMoviesByGenre(String genreId) {
    return _firestore
        .collection(collection)
        .where('genres', arrayContains: {'id': genreId})
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return Movie.fromJson({...data, 'id': doc.id});
          }).toList();
        });
  }

  // Lấy danh sách phim đang chiếu
  Stream<List<Movie>> getNowShowingMovies() {
    try {
      return _firestore
          .collection('movies')
          .where('isShowingNow', isEqualTo: true)
          .snapshots()
          .map((snapshot) {
        List<Movie> movieList = [];
        for (var doc in snapshot.docs) {
          try {
            final data = doc.data();

            // Xử lý trường genres
            List<Genre> genres = [];
            if (data['genres'] != null) {
              List<dynamic> genresData = data['genres'];
              genres = genresData.map((g) {
                if (g is Map<String, dynamic>) {
                  return Genre.fromJson(g);
                } else {
                  // Nếu là string, tạo Genre mới với id và name là string đó
                  return Genre(id: g.toString(), name: g.toString());
                }
              }).toList();
            }

            // Xử lý trường cast
            List<String> cast = [];
            if (data['cast'] != null) {
              cast = List<String>.from(data['cast']);
            }

            // Xử lý trường comments
            List<Comment> comments = [];
            if (data['comments'] != null) {
              List<dynamic> commentsData = data['comments'];
              comments = commentsData.map((c) {
                if (c is Map<String, dynamic>) {
                  return Comment.fromJson(c);
                } else {
                  // Trả về comment mặc định nếu dữ liệu không đúng định dạng
                  return Comment(
                    id: 'unknown',
                    userId: 'unknown',
                    movieId: doc.id,
                    userName: 'Người dùng ẩn danh',
                    content: 'Nội dung không hợp lệ',
                    rating: 0.0,
                  );
                }
              }).toList();
            }

            movieList.add(Movie(
              id: doc.id,
              title: data['title'] ?? 'Phim không có tiêu đề',
              imagePath: data['imagePath'] ?? '',
              trailerUrl: data['trailerUrl'] ?? '',
              duration: data['duration'] ?? '',
              genres: genres,
              rating: (data['rating'] ?? 0).toDouble(),
              isShowingNow: data['isShowingNow'] ?? true,
              description: data['description'] ?? '',
              cast: cast,
              reviewCount: data['reviewCount'] ?? 0,
              releaseDate: data['releaseDate'] ?? '',
              director: data['director'] ?? '',
              comments: comments,
            ));
          } catch (e) {
            print('Lỗi khi parse movie: $e');
          }
        }

        print('Đã tải ${movieList.length} phim đang chiếu từ Firebase');

        // Sắp xếp theo rating giảm dần
        movieList.sort((a, b) => b.rating.compareTo(a.rating));

        return movieList;
      }).handleError((error) {
        print('Lỗi khi lấy dữ liệu phim: $error');
        // Nếu có lỗi, trả về dữ liệu phim mẫu
        return _getDummyMovies();
      });
    } catch (e) {
      print('Lỗi nghiêm trọng khi tạo stream cho movies: $e');
      // Tạo stream trả về dữ liệu mẫu
      return Stream.value(_getDummyMovies());
    }
  }

  // Tạo dữ liệu phim mẫu để đảm bảo app không bị lỗi
  List<Movie> _getDummyMovies() {
    return [
      Movie(
        id: 'm001',
        title: 'Phim Mẫu 1',
        imagePath: 'https://example.com/movie1.jpg',
        trailerUrl: '',
        duration: '120 phút',
        genres: [
          Genre(id: 'g1', name: 'Hành Động'),
          Genre(id: 'g2', name: 'Viễn Tưởng')
        ],
        rating: 8.5,
        isShowingNow: true,
        description: 'Mô tả phim mẫu 1',
        cast: ['Diễn viên 1', 'Diễn viên 2'],
        reviewCount: 150,
        releaseDate: '2023-01-01',
        director: 'Đạo diễn 1',
        comments: [],
      ),
      Movie(
        id: 'm002',
        title: 'Phim Mẫu 2',
        imagePath: 'https://example.com/movie2.jpg',
        trailerUrl: '',
        duration: '105 phút',
        genres: [
          Genre(id: 'g3', name: 'Tình Cảm'),
          Genre(id: 'g4', name: 'Hài Hước')
        ],
        rating: 7.8,
        isShowingNow: true,
        description: 'Mô tả phim mẫu 2',
        cast: ['Diễn viên 3', 'Diễn viên 4'],
        reviewCount: 120,
        releaseDate: '2023-02-15',
        director: 'Đạo diễn 2',
        comments: [],
      ),
    ];
  }

  // Lấy danh sách phim sắp chiếu
  Stream<List<Movie>> getUpcomingMovies() {
    return _firestore
        .collection(collection)
        .where('isShowingNow', isEqualTo: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Movie.fromJson({...data, 'id': doc.id});
      }).toList();
    });
  }

  // Lấy danh sách phim theo tên
  Stream<List<Movie>> searchMovies(String query) {
    return _firestore
        .collection(collection)
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThanOrEqualTo: query + '\uf8ff')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Movie.fromJson({...data, 'id': doc.id});
      }).toList();
    });
  }
}
