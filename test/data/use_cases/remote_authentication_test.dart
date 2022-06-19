import 'package:clean_flutter_app/data/http/http.dart';
import 'package:clean_flutter_app/data/use_cases/use_cases.dart';
import 'package:clean_flutter_app/domain/use_cases/use_cases.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteAuthentication sut;
  late HttpClientSpy httpClientSpy;
  late String url;

  setUp(() {
    // Arrange
    httpClientSpy = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClientSpy, url: url); // system under test
  });

  test('Should call http client with correct values', () async {
    // AAT - Arrange, Act, Assert
    // Act
    final AuthenticationParams params = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );

    when(
      () => httpClientSpy.request(
        url: url,
        method: 'post',
        body: {'email': params.email, 'password': params.password},
      ),
    ).thenAnswer((_) async => true);

    await sut.auth(params);
    // Assert
    verify(() => httpClientSpy.request(
          url: url,
          method: 'post',
          body: {'email': params.email, 'password': params.password},
        )).called(1);
  });
}