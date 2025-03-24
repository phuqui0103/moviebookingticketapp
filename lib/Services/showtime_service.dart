import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/Showtime.dart';
import '../Model/Room.dart';
import '../Model/Cinema.dart';
import '../Model/Seat.dart';
import 'package:intl/intl.dart';

class ShowtimeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Cache maps for rooms and cinemas
  final Map<String, Room> _roomCache = {};
  final Map<String, Cinema> _cinemaCache = {};

  // Caching timeout (5 minutes)
  final Duration _cacheDuration = const Duration(minutes: 5);
  final Map<String, DateTime> _roomCacheTimestamps = {};
  final Map<String, DateTime> _cinemaCacheTimestamps = {};

  // Tạo lịch chiếu mới
  Future<void> createShowtime(Showtime showtime) async {
    try {
      await _firestore
          .collection('showtimes')
          .doc(showtime.id)
          .set(showtime.toJson());
    } catch (e) {
      print('Error creating showtime: $e');
      throw e;
    }
  }

  // Lấy thông tin lịch chiếu theo ID
  Future<Showtime?> getShowtimeById(String showtimeId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('showtimes').doc(showtimeId).get();
      if (doc.exists) {
        return Showtime.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting showtime: $e');
      throw e;
    }
  }

  // Cập nhật thông tin lịch chiếu
  Future<void> updateShowtime(
      String showtimeId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('showtimes').doc(showtimeId).update(data);
    } catch (e) {
      print('Error updating showtime: $e');
      throw e;
    }
  }

  // Xóa lịch chiếu
  Future<void> deleteShowtime(String showtimeId) async {
    try {
      await _firestore.collection('showtimes').doc(showtimeId).delete();
    } catch (e) {
      print('Error deleting showtime: $e');
      throw e;
    }
  }

  // Lấy tất cả suất chiếu từ Firebase
  Stream<List<Showtime>> getAllShowtimes() {
    try {
      return _firestore.collection('showtimes').snapshots().map((snapshot) {
        List<Showtime> showtimeList = [];
        for (var doc in snapshot.docs) {
          try {
            final data = doc.data();
            // Chuyển đổi timestamp sang DateTime
            DateTime startTime;
            try {
              if (data['startTime'] is Timestamp) {
                startTime = (data['startTime'] as Timestamp).toDate();
              } else {
                // Nếu không phải timestamp, thử parse từ chuỗi hoặc số
                startTime = DateTime.parse(data['startTime'].toString());
              }
            } catch (e) {
              print("Lỗi khi parse startTime: $e");
              startTime = DateTime.now(); // Giá trị mặc định
            }

            // Chuyển đổi bookedSeats từ List dynamic sang List<String>
            List<String> bookedSeats = [];
            if (data['bookedSeats'] != null) {
              bookedSeats = List<String>.from(data['bookedSeats']);
            }

            showtimeList.add(Showtime(
              id: doc.id,
              movieId: data['movieId'] ?? '',
              cinemaId: data['cinemaId'] ?? '',
              roomId: data['roomId'] ?? '',
              startTime: startTime,
              bookedSeats: bookedSeats,
            ));
          } catch (e) {
            print('Lỗi khi parse showtime: $e');
          }
        }
        print('Đã tải ${showtimeList.length} suất chiếu từ Firebase');

        // Sắp xếp theo thời gian
        showtimeList.sort((a, b) => a.startTime.compareTo(b.startTime));

        return showtimeList;
      }).handleError((error) {
        print('Lỗi khi lấy dữ liệu suất chiếu: $error');
        // Trả về danh sách rỗng khi có lỗi, để stream không bị đóng
        return <Showtime>[];
      });
    } catch (e) {
      print('Lỗi nghiêm trọng khi tạo stream cho showtimes: $e');
      // Tạo stream trả về danh sách rỗng
      return Stream.value(<Showtime>[]);
    }
  }

  // Lấy danh sách lịch chiếu theo phim
  Stream<List<Showtime>> getShowtimesByMovie(String movieId) {
    return _firestore
        .collection('showtimes')
        .where('movieId', isEqualTo: movieId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Showtime.fromJson(doc.data());
      }).toList();
    });
  }

  // Lấy danh sách lịch chiếu theo rạp
  Stream<List<Showtime>> getShowtimesByCinema(String cinemaId) {
    return _firestore
        .collection('showtimes')
        .where('cinemaId', isEqualTo: cinemaId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Showtime.fromJson(doc.data());
      }).toList();
    });
  }

  // Lấy danh sách lịch chiếu theo phòng chiếu
  Stream<List<Showtime>> getShowtimesByRoom(String roomId) {
    return _firestore
        .collection('showtimes')
        .where('roomId', isEqualTo: roomId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Showtime.fromJson(doc.data());
      }).toList();
    });
  }

  // Lấy danh sách lịch chiếu theo ngày
  Stream<List<Showtime>> getShowtimesByDate(DateTime date) {
    String dateString = date.toIso8601String().split('T')[0];
    return _firestore
        .collection('showtimes')
        .where('date', isEqualTo: dateString)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Showtime.fromJson(doc.data());
      }).toList();
    });
  }

  // Lấy danh sách suất chiếu theo ID phim và ngày
  Stream<List<Showtime>> getShowtimesByMovieAndDate(
      String movieId, DateTime date) {
    try {
      // Tạo DateTime cho đầu ngày và cuối ngày để lọc
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      print('Tìm suất chiếu từ $startOfDay đến $endOfDay');

      return _firestore
          .collection('showtimes')
          .where('movieId', isEqualTo: movieId)
          .snapshots()
          .map((snapshot) {
        List<Showtime> filteredShowtimes = [];

        for (var doc in snapshot.docs) {
          try {
            final data = doc.data();

            // Xử lý trường startTime
            DateTime startTime;
            try {
              if (data['startTime'] is Timestamp) {
                startTime = (data['startTime'] as Timestamp).toDate();
              } else if (data['startTime'] is String) {
                startTime = DateTime.parse(data['startTime']);
              } else {
                print(
                    'Định dạng startTime không xác định: ${data['startTime']}');
                continue; // Bỏ qua suất chiếu này nếu không parse được startTime
              }
            } catch (e) {
              print('Lỗi khi parse startTime: $e');
              continue; // Bỏ qua suất chiếu này nếu không parse được startTime
            }

            // Chỉ lọc suất chiếu trong ngày được chọn
            bool isInSelectedDate = startTime.year == date.year &&
                startTime.month == date.month &&
                startTime.day == date.day;

            if (!isInSelectedDate) {
              continue; // Bỏ qua suất chiếu không nằm trong ngày đã chọn
            }

            // Chuyển đổi bookedSeats từ List dynamic sang List<String>
            List<String> bookedSeats = [];
            if (data['bookedSeats'] != null) {
              bookedSeats = List<String>.from(data['bookedSeats']);
            }

            filteredShowtimes.add(Showtime(
              id: doc.id,
              movieId: data['movieId'] ?? '',
              cinemaId: data['cinemaId'] ?? '',
              roomId: data['roomId'] ?? '',
              startTime: startTime,
              bookedSeats: bookedSeats,
            ));
          } catch (e) {
            print('Lỗi khi parse showtime: $e');
          }
        }

        print(
            'Tìm thấy ${filteredShowtimes.length} suất chiếu cho phim $movieId vào ngày ${DateFormat('dd/MM/yyyy').format(date)}');

        // Sắp xếp theo thời gian
        filteredShowtimes.sort((a, b) => a.startTime.compareTo(b.startTime));

        return filteredShowtimes;
      }).handleError((error) {
        print('Lỗi khi lấy dữ liệu suất chiếu theo phim và ngày: $error');
        return <Showtime>[];
      });
    } catch (e) {
      print('Lỗi nghiêm trọng trong getShowtimesByMovieAndDate: $e');
      return Stream.value(<Showtime>[]);
    }
  }

  // Lấy thông tin cinema theo ID với caching
  Future<Cinema> getCinemaById(String cinemaId) async {
    // Check if cinema is in cache and if cache is still valid
    if (_cinemaCache.containsKey(cinemaId)) {
      final cacheTime = _cinemaCacheTimestamps[cinemaId];
      if (cacheTime != null &&
          DateTime.now().difference(cacheTime) < _cacheDuration) {
        return _cinemaCache[cinemaId]!;
      }
    }

    try {
      final doc = await _firestore.collection('cinemas').doc(cinemaId).get();

      if (!doc.exists) {
        throw Exception('Cinema không tồn tại');
      }

      final cinema = Cinema.fromJson(doc.data() as Map<String, dynamic>);

      // Store in cache
      _cinemaCache[cinemaId] = cinema;
      _cinemaCacheTimestamps[cinemaId] = DateTime.now();

      return cinema;
    } catch (e) {
      print('Lỗi khi lấy thông tin cinema: $e');

      // If there was an error but we have a cached version, return it even if expired
      if (_cinemaCache.containsKey(cinemaId)) {
        return _cinemaCache[cinemaId]!;
      }

      throw Exception('Không thể lấy thông tin cinema');
    }
  }

  // Lấy thông tin room theo ID với caching
  Future<Room> getRoomById(String roomId) async {
    // Check if room is in cache and if cache is still valid
    if (_roomCache.containsKey(roomId)) {
      final cacheTime = _roomCacheTimestamps[roomId];
      if (cacheTime != null &&
          DateTime.now().difference(cacheTime) < _cacheDuration) {
        return _roomCache[roomId]!;
      }
    }

    try {
      final doc = await _firestore.collection('rooms').doc(roomId).get();

      if (!doc.exists) {
        throw Exception('Room không tồn tại');
      }

      final room = Room.fromJson(doc.data() as Map<String, dynamic>);

      // Store in cache
      _roomCache[roomId] = room;
      _roomCacheTimestamps[roomId] = DateTime.now();

      return room;
    } catch (e) {
      print('Lỗi khi lấy thông tin room: $e');

      // If there was an error but we have a cached version, return it even if expired
      if (_roomCache.containsKey(roomId)) {
        return _roomCache[roomId]!;
      }

      throw Exception('Không thể lấy thông tin room');
    }
  }

  // Clear caches method - call this when data might have changed
  void clearCaches() {
    _roomCache.clear();
    _cinemaCache.clear();
    _roomCacheTimestamps.clear();
    _cinemaCacheTimestamps.clear();
  }

  // Lấy danh sách rạp phim theo tỉnh thành
  Stream<List<Cinema>> getCinemasByProvince(String provinceId) {
    final query = provinceId.isEmpty
        ? _firestore.collection('cinemas')
        : _firestore
            .collection('cinemas')
            .where('provinceId', isEqualTo: provinceId);

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Cinema(
          id: doc.id,
          name: data['name'] ?? '',
          provinceId: data['provinceId'] ?? '',
          address: data['address'] ?? '',
        );
      }).toList();
    });
  }
}
