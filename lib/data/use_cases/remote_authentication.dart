import 'package:clean_flutter_app/data/http/http.dart';
import 'package:clean_flutter_app/domain/use_cases/use_cases.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });

  Future<void> auth(AuthenticationParams params) async {
    await httpClient.request(
      url: url,
      method: 'post',
      body: RemoteAuthenticationParams.fromDomain(params).toJson(),
    );
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({
    required this.email,
    required this.password,
  });

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams entity) => RemoteAuthenticationParams(
        email: entity.email,
        password: entity.password,
      );

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}
