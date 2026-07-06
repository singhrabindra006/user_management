import 'package:http/http.dart' as http;
import 'dart:convert';

class FeatchingApi {
  Future<void> featchningApi() async {
  var url = Uri.https('jsonplaceholder.typicode.com', 'users/1');
 /* try{
    var res = await http.get(url);
    print(jsonDecode(res.body)['name']);
  }catch(ex){
    print("Exception is $ex");
  }*/


  http.get(url).then((value) {
     print(jsonDecode(value.body));
  }).catchError((err){
    print(err);
  });
}
}