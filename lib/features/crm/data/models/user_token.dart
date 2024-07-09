import 'dart:convert';

class UserToken {
  UserToken({
    this.accessToken,
    this.tokenType,
    this.refreshToken,
    this.scope,
    this.expiresIn,
  });

  String? accessToken;
  String? tokenType;
  String? refreshToken;
  String? scope;
  int? expiresIn;

  factory UserToken.fromRawJson(String str) =>
      UserToken.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserToken.fromJson(Map<String, dynamic> json) => UserToken(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        refreshToken: json["refresh_token"],
        scope: json["scope"],
        expiresIn: json["expires_in"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "token_type": tokenType,
        "refresh_token": refreshToken,
        "scope": scope,
        "expires_in": expiresIn,
      };
}
