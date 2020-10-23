import 'package:http/http.dart' as http;

class Network{
  static String site = 'http://10.0.1.173:8000';

  static void Get() async {
    String url = '$site/hello/';
    var response = await http.get(url);
    print('${response.statusCode}: ${response.body}');
  }
}