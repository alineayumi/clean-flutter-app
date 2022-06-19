import 'package:clean_flutter_app/data/use_cases/use_cases.dart';
import 'package:clean_flutter_app/domain/entities/entities.dart';

abstract class Authentication {
  Future<AccountEntity> auth(RemoteAuthenticationParams params);
}

class AuthenticationParams {
  final String email;
  final String password;

  AuthenticationParams({
    required this.email,
    required this.password,
  });
}
