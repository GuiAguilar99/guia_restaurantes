import 'package:guia_restaurantes/data/network/requester.dart';
import 'package:guia_restaurantes/data/repositores/user_repository.dart';
import 'package:guia_restaurantes/models/auth_session.dart';

class LoginViewmodel {
  final UserRepository _repository = UserRepository();

  AuthSession? session; //preenchida quando o login dá certo

  //E-mail: obrigatório, no formato nome@dominio.com
  String? validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Informe o seu e-mail';

    final emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.]+$');
    if (!emailRegex.hasMatch(email)) return 'E-mail inválido';
    return null;
  }

  //Senha: no login, só precisa estar preenchida
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Informe a sua senha';
    return null;
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      session = await _repository.login(email.trim(), password);
      return null; //null = deu certo
    } on RequestException catch (e) {
      //401: o servidor recusou o e-mail ou a senha
      if (e.statusCode == 401) {
        return 'E-mail ou senha incorretos.';
      }
      return e.message;
    } catch (_) {
      return 'Não foi possível entrar. Tente novamente.';
    }
  }
}
