import 'package:flutter/foundation.dart';
import 'package:guia_restaurantes/data/network/requester.dart';
import 'package:guia_restaurantes/data/repositores/restaurant_repository.dart';
import 'package:guia_restaurantes/data/session/session_store.dart';
import 'package:guia_restaurantes/models/auth_session.dart';
import 'package:guia_restaurantes/models/restaurant.dart';

class HomeViewmodel {
  final RestaurantRepository _repository = RestaurantRepository();
  List<Restaurant> restaurants = [];

  //a tela ouve as mudanças de sessão por aqui
  ValueListenable<AuthSession?> get sessionListenable => SessionStore.notifier;

  //monta o texto de saudação
  String? greeting(AuthSession? session) {
    if (session == null) return null;

    final firstName = session.user.fullName.split(' ').first;
    return 'Olá, $firstName';
  }

  Future<String?> loadRestaurants() async {
    try {
      restaurants = await _repository.fetchRestaurants();
      return null;
    } on RequestException catch (e) {
      return e.message;
    } catch (_) {
      return 'Não foi possível carregar os restaurantes.';
    }
  }
}
