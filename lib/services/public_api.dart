import 'package:http/http.dart' as http;

class PublicAPIService {
  static Future<String> getSampleResult() async {
    var url = Uri.parse("http://apis.data.go.kr/1400119/ChildService1/childIlstrInfo?q1=4316&serviceKey=XvIWPXWRvnkJPI4d2FFetPbsFKxe0Tl5eMLAF2Ok7jTEUbRJh0Wl1MPtdrbd0k%2FWKMkeluaCG1fUNauwSD3ORQ%3D%3D");

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return response.body;
    } else {

      return "error: ${response.statusCode} ${response.body}";
    }
  }
}