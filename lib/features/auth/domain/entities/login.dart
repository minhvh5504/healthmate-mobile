class Login {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final String expiresIn;

  final String? fullName;
  final String? phone;

  const Login({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    this.fullName,
    this.phone,
  });
}
