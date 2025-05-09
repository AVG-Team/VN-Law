class LoginRequest {
  final String username;
  final String password;

  LoginRequest({required this.username, required this.password});

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
  };
}

class RegisterRequest {
  final String username;
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  RegisterRequest({
    required this.username,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'email': email,
    'password': password,
    'firstName': firstName,
    'lastName': lastName,
  };
}

class ResetPasswordRequest {
  final String email;

  ResetPasswordRequest({required this.email});

  Map<String, dynamic> toJson() => {
    'email': email,
  };
}

class GoogleLoginRequest {
  final String idToken;

  GoogleLoginRequest({required this.idToken});

  Map<String, dynamic> toJson() => {
    'idToken': idToken,
  };
}

class TokenResponse {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final String tokenType;

  TokenResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.tokenType,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      expiresIn: json['expires_in'],
      tokenType: json['token_type'],
    );
  }
}