import 'package:clean_flutter_app/data/http/http.dart';
import 'package:clean_flutter_app/data/use_cases/use_cases.dart';
import 'package:clean_flutter_app/domain/entities/account_entity.dart';
import 'package:clean_flutter_app/domain/helpers/helpers.dart';
import 'package:clean_flutter_app/domain/use_cases/use_cases.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteAuthentication sut;
  late HttpClientSpy httpClientSpy;
  late String url;
  late AuthenticationParams params;

  setUp(() {
    // Arrange
    httpClientSpy = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(
        httpClient: httpClientSpy, url: url); // system under test
    params = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );
  });

  test('Should call http client with correct values', () async {
    // AAT - Arrange, Act, Assert
    // Act
    when(
      () => httpClientSpy.request(
        url: url,
        method: 'post',
        body: {'email': params.email, 'password': params.password},
      ),
    ).thenAnswer((_) async =>
        {'accessToken': faker.guid.guid(), 'name': faker.person.name()});

    await sut.auth(params);
    // Assert
    verify(() => httpClientSpy.request(
          url: url,
          method: 'post',
          body: {'email': params.email, 'password': params.password},
        )).called(1);
  });

  test('Should throw Unexpected Error if HttpClient returns 400', () async {
    // AAT - Arrange, Act, Assert
    // Arrange
    when(
      () => httpClientSpy.request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        body: any(named: 'body'),
      ),
    ).thenThrow(HttpError.badRequest);

    // Act
    final future = sut.auth(params);
    // Assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw Unexpected Error if HttpClient returns 404', () async {
    // AAT - Arrange, Act, Assert
    // Arrange
    when(
      () => httpClientSpy.request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        body: any(named: 'body'),
      ),
    ).thenThrow(HttpError.notFound);

    // Act
    final future = sut.auth(params);
    // Assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw Unexpected Error if HttpClient returns 500', () async {
    // AAT - Arrange, Act, Assert
    // Arrange
    when(
      () => httpClientSpy.request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        body: any(named: 'body'),
      ),
    ).thenThrow(HttpError.serverError);

    // Act
    final future = sut.auth(params);
    // Assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredentials Error if HttpClient returns 401',
      () async {
    // AAT - Arrange, Act, Assert
    // Arrange
    when(
      () => httpClientSpy.request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        body: any(named: 'body'),
      ),
    ).thenThrow(HttpError.unauthorized);

    // Act
    final future = sut.auth(params);
    // Assert
    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Should return an Account if HttpClient returns 200', () async {
    // AAT - Arrange, Act, Assert
    // Arrange
    final String accessToken = faker.guid.guid();
    final String name = faker.person.name();
    when(
      () => httpClientSpy.request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        body: any(named: 'body'),
      ),
    ).thenAnswer((_) async => {'accessToken': accessToken, 'name': name});

    // Act
    final AccountEntity account = await sut.auth(params);
    // Assert
    expect(account.accessToken, accessToken);
  });
}
