import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:guia_restaurantes/models/auth_session.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionStore {
  //o 'cofre' do sistema e o nome da 'gaveta' onde a sessão fica guardada
  static const _storage = FlutterSecureStorage();
  static const _key = 'auth_session';

  //guarda a sessão e avisa quem estiver ouvindo quando ela mudar
  static final notifier = ValueNotifier<AuthSession?>(null);

  //a sessão em memória, agora lida do notifier (só leitura)
  static AuthSession? get current => notifier.value;

  static Timer? _expirationTimer;

  static Future<void> save(AuthSession session) async {
    _setSession(session);
    final text = jsonEncode(session.toStorage());
    await _storage.write(key: _key, value: text);
  }

  static Future<void> load() async {
    final text = await _storage.read(key: _key);

    //1. nada gravado: ninguém logado
    if (text == null) {
      _setSession(null);
      return;
    }

    try {
      final session = AuthSession.fromStorage(
        jsonDecode(text) as Map<String, dynamic>,
      );

      //2. gravado, mas vencido: apaga sem ninguém logado
      if (session.isExpired) {
        await clear();
        return;
      }

      //3.gravada e válida: o usuário continua logado
      _setSession(session);
    } catch (_) {
      //o que estava gravado não pode ser lido = começa do zero
      await clear();
    }
  }

  static Future<void> clear() async {
    _setSession(null);
    await _storage.delete(key: _key);
  }

  static void _setSession(AuthSession? session) {
    _expirationTimer?.cancel(); //desliga o despertador antigo
    notifier.value = session; //atualiza quem estiver ouvindo

    if (session != null) {
      final timeLeft = session.expiresAt.difference(DateTime.now());
      _expirationTimer = Timer(timeLeft, () => clear());
    }
  }
}
