class AuthUser {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final bool acceptedTerms;
  final DateTime createdAt;

  const AuthUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.acceptedTerms,
    required this.createdAt,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'].toString(),
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      acceptedTerms: json['accepted_terms'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'accepted_terms': acceptedTerms,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class AuthSession {
  final String accessToken;
  final String tokenType;
  final DateTime expiresAt; // em segundos
  final AuthUser user;

  const AuthSession({
    required this.accessToken,
    required this.tokenType,
    required this.expiresAt,
    required this.user,
  });

  //a sessão já passou da validade?
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  //lê a RESPOSTA DO LOGIN, que traz expires_in (em segundos)
  factory AuthSession.fromJson(Map<String, dynamic> json) {
    final expiresIn = int.parse(json['expires_in'].toString());

    return AuthSession(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
      expiresAt: DateTime.now().add(Duration(seconds: expiresIn)),
      user: AuthUser.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  //transforma a sessão em JSON, para GRAVAR no aparelho
  Map<String, dynamic> toStorage() {
    return {
      'access_token': accessToken,
      'token_type': tokenType,
      'expires_at': expiresAt.toIso8601String(),
      'user': user.toJson(),
    };
  }

  //lê a sessão GRAVADA no aparelho, que traz expires_at (um data)
  factory AuthSession.fromStorage(Map<String, dynamic> json) {
    return AuthSession(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
      expiresAt: DateTime.parse(json['expires_at'] as String),
      user: AuthUser.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
