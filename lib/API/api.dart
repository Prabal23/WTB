import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallApi {
  // LOCAL
  final String picUrl1 = 'https://mobile.tradister.com/';
  //
  final String picUrl = 'https://mobile.tradister.com/';
  //final String _url = 'https://mobile.tradelounge.co/app/mobile/';
  // final String baseUrl = 'http://backoffice.localhost';

  // PRODUCTION
  // final String _url = 'http://10.0.2.2:3005/app/mobile/';
  // final String _url1 = 'http://10.0.2.2:3005/app/';
  final String url = 'https://mobile.tradister.com/app/mobile/';
  final String url1 = 'https://mobile.tradister.com/app/';
  // final String baseUrl = 'http://backoffice.forehand.se';

  postData(data, apiUrl) async {
    var apiMainUri = url + apiUrl;
    print(apiMainUri);
    return await http.post(apiMainUri,
        body: jsonEncode(data), headers: _setHeaders());
  }

  postData1(data, apiUrl) async {
    var apiMainUri = url + apiUrl + await getToken2();
    print(apiMainUri);
    return await http.post(apiMainUri,
        body: jsonEncode(data), headers: _setHeaders());
  }

  postData2(apiUrl) async {
    var apiMainUri = url1 + apiUrl + await getToken2();
    print(apiMainUri);
    return await http.post(apiMainUri, headers: _setHeaders());
  }

  postData3(data, apiUrl) async {
    var apiMainUri = url1 + apiUrl + await getToken2();
    print(apiMainUri);
    return await http.post(apiMainUri,
        body: jsonEncode(data), headers: _setHeaders());
  }

  getData(apiUrl) async {
    var apiMainUri = url + apiUrl + await getToken();
    print(apiMainUri);
    return await http.get(apiMainUri, headers: _setHeaders());
  }

  getData1(apiUrl) async {
    var apiMainUri = url1 + apiUrl + await getToken2();
    print(apiMainUri);
    return await http.get(apiMainUri, headers: _setHeaders());
  }

  getData2(apiUrl) async {
    var apiMainUri = url + apiUrl + await getToken2();
    print(apiMainUri);
    return await http.get(apiMainUri, headers: _setHeaders());
  }

  getData3(apiUrl) async {
    var apiMainUri = url + apiUrl;
    print(apiMainUri);
    return await http.get(apiMainUri, headers: _setHeaders());
  }

  getData4(apiUrl) async {
    var apiMainUri = url1 + apiUrl;
    print(apiMainUri);
    return await http.get(apiMainUri, headers: _setHeaders());
  }

  _setHeaders() => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // _getToken() async {
  //   SharedPreferences localStorage = await SharedPreferences.getInstance();
  //   var token = localStorage.getString('token');
  //   return '?v=1&token=$token';
  // }

  getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return '&token=$token';
  }

  getToken2() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return '?token=$token';
  }
}
