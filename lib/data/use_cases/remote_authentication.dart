import 'package:clean_flutter_app/data/http/http.dart';
import 'package:clean_flutter_app/data/models/remote_account_model.dart';
import 'package:clean_flutter_app/domain/entities/entities.dart';
import 'package:clean_flutter_app/domain/helpers/helpers.dart';
import 'package:clean_flutter_app/domain/use_cases/use_cases.dart';

class RemoteAuthentication implements Authentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });

  @override
  Future<AccountEntity> auth(AuthenticationParams params) async {
    try {
      final Map<String, dynamic> response = await httpClient.request(
        url: url,
        method: 'post',
        body: RemoteAuthenticationParams.fromDomain(params).toJson(),
      );
      return RemoteAccountModel.fromJson(response).toEntity();
    } on HttpError catch (error) {
      error == HttpError.unauthorized
          ? throw DomainError.invalidCredentials
          : throw DomainError.unexpected;
    }
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({
    required this.email,
    required this.password,
  });

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams entity) =>
      RemoteAuthenticationParams(
        email: entity.email,
        password: entity.password,
      );

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}
