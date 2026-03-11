class RefreshToken {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final String expiresIn;

  const RefreshToken({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
  });
}
