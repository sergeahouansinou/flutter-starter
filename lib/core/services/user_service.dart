import 'package:cardifly/config/net/api.dart';
import 'package:cardifly/core/models/user.dart';
import 'package:cardifly/core/services/base_service.dart';
import 'package:cardifly/utils/enums/connexion_source.dart';
import 'package:dio/dio.dart';

class UserService extends BaseService {
  static Future<Object?> register(User user) async {
    final response = await http.post<Object?>(
      'auth/register',
      data: {
        'firstname': user.firstname,
        'lastname': user.lastname,
        'email': user.email,
        'password': user.password,
        'password_confirmation': user.password,
      },
    );
    return response.data;
  }

  static Future<User> update(User user) async {
    final data = FormData.fromMap({
      'firstname': user.firstname,
      'lastname': user.lastname,
      if (user.pictureFile != null && user.pictureFile!.path.isNotEmpty)
        'picture': await MultipartFile.fromFile(
          user.pictureFile!.path,
          filename: user.pictureFile!.path.split('/').last,
        ),
    });

    final response = await http.post<Object?>(
      'users/update?_method=PUT',
      data: data,
    );
    return User.fromJson(response.data! as Map<String, dynamic>);
  }

  static Future<User> signIn(User user, ConnexionSource source) async {
    final response = await http.post<Object?>(
      'auth/login',
      data: {
        'email': user.email,
        'password': user.password,
        'source': source.name,
      },
    );

    final payload = response.data! as Map<String, dynamic>;
    final res = User.fromJson(payload['user'] as Map<String, dynamic>);
    res.token = payload['token'] as String?;
    return res;
  }

  static Future<User> getUser() async {
    final response = await http.get<Object?>('users/me');
    return User.fromJson(response.data! as Map<String, dynamic>);
  }

  static Future<User> verifyEmail(User userInput) async {
    final response = await http.post<Object?>(
      'auth/verify-account',
      data: {'email': userInput.email, 'code': userInput.code},
    );

    final payload = response.data! as Map<String, dynamic>;
    final user = User.fromJson(payload['user'] as Map<String, dynamic>);
    user.token = payload['token'] as String?;
    return user;
  }

  static Future<Object?> requestVerificationCode(String email) async {
    final response = await http.post<Object?>(
      'auth/request-verification-code',
      data: {'email': email},
    );
    return response.data;
  }

  static Future<Object?> passwordForgotten(String email) async {
    final response = await http.post<Object?>(
      'auth/password-forgotten',
      data: {'email': email},
    );
    return response.data;
  }

  static Future<Object?> resetPassword(User user) async {
    final response = await http.post<Object?>(
      'auth/reset-password',
      data: {'email': user.email},
    );
    return response.data;
  }

  static Future<Object?> logout() async {
    final response = await http.post<Object?>('auth/logout');
    return response.data;
  }

  static Future<User> changeCurrency(String currencyCode) async {
    final response = await http.put<Object?>(
      'change-currency',
      data: {'code': currencyCode},
    );
    return User.fromJson(response.data! as Map<String, dynamic>);
  }

  static Future<Object?> delete(int? id) async {
    final response = await http.delete<Object?>('users/$id');
    return response.data;
  }

  static Future<Object?> followArtist(int artistId) async {
    final response = await http.post<Object?>('artists/$artistId/follow');
    return response.data;
  }

  static Future<Object?> unfollowArtist(int artistId) async {
    final response = await http.delete<Object?>('artists/$artistId/unfollow');
    return response.data;
  }

  static Future<List<User>> getFollowers(int artistId) async {
    final response = await http.get<Object?>('artists/$artistId/followers');
    final payload = response.data! as Map<String, dynamic>;
    final data = payload['data'] as List<dynamic>;
    return data
        .map((raw) => User.fromJson(raw as Map<String, dynamic>))
        .toList();
  }
}
