import 'package:guia_restaurantes/data/services/user_service.dart';
import 'package:guia_restaurantes/data/session/session_store.dart';
import 'package:guia_restaurantes/models/auth_session.dart';
import 'package:guia_restaurantes/models/user.dart';

class UserRepository {
  final UserService _service = UserService();

  Future<void> createUser(User user) async {
    await _service.postUser(user);
  }

  Future<AuthSession> login(String email, String password) async {
    //1. pede ao service a resposta em JSON
    final json = await _service.postLogin(email, password);

    //2. converte o JSON em um objeto (com o usuário dentro)
    final session = AuthSession.fromJson(json);

    //3. grava a sessão na memória e no 'cofre' do aparelho
    await SessionStore.save(session);

    //4. devolve a sessão para o resto do app
    return session;
  }

  //lê a sessão gravada, quando o app abre
  Future<void> restoreSession() async {
    await SessionStore.load();
  }

  //encerra a sessão: apaga da memória e do aparelho
  Future<void> logout() async {
    await SessionStore.clear();
  }
}
