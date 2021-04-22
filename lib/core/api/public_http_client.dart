import 'base_dio_client.dart';

class PublicHttpClient extends BaseDioClient {
  PublicHttpClient() : super();

  @override
  Future<String> getToken() async {
    return 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjIxMjYwNTgxLCJqdGkiOiJlOWI2Njk1YjJjNmM0ODgyYjgzYTViZjJiN2VkOWIzNCIsInVzZXJfaWQiOjJ9.K2xqpBTKCZE-OjP1F_pcSlY-8ofQnl2bUXZ6Ub5UBVo';
  }
}
