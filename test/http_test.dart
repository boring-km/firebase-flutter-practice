import 'package:biosns/services/public_api.dart';
import 'package:http/src/response.dart';
import 'package:test/test.dart';

void main() {
  test("공공 데이터 API 호출 테스트", () async {
    final String result = await PublicAPIService.getSampleResult();
    print(result);
  });
}