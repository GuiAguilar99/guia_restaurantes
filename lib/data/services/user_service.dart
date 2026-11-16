import 'package:guia_restaurantes/data/network/requester.dart';
import 'package:guia_restaurantes/models/user.dart';

class UserService {
  final Requester _requester = Requester();

  Future<void> postUser(User user) async {
    await _requester.post('/api/v1/auth/register', user.toJson());
  }

  Future<Map<String, dynamic>> postLogin(String email, String password) async {
    final response = await _requester.post('/api/v1/auth/login', {
      'email': email,
      'password': password,
    });

    return response as Map<String, dynamic>;
  }
}
