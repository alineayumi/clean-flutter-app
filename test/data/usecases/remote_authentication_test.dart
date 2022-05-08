import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });

  Future<void> auth() async {
    await httpClient.request(
      url: url,
      method: 'post',
    );
  }
}

abstract class HttpClient {
  Future<void>? request({
    required String url,
    required String method,
  });
}

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
    await sut.auth();
    // Assert
    verify(httpClientSpy.request(
      url: url,
      method: 'post',
    ));
  });
}