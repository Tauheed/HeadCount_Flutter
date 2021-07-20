import 'package:http/http.dart';

class NetworkingManager {

  NetworkingManager({this.url, this.headers, this.json});

  final String url;
  final Map<String, String> headers;
  final String json;

  Future postRequest() async{
    //EasyLoading.show(status: 'please wait...', maskType: EasyLoadingMaskType.black);

    Response response = await post(url, headers: headers, body: json);
    // check the status code for the result
    // this API passes back the id of the new item added to the body
    String body = response.body;
    //EasyLoading.dismiss();

    if (response.statusCode == 200) {
      return [true, body];
//      Navigator.push(context, MaterialPageRoute(builder: (context) {
//        return AddCustomerScreen();
//      }));
    } else {
      return [false, body];
//      String msg = jsonDecode(body)['detail'];
//      EasyLoading.showToast(msg);
    }
  }


  Future getRequest() async {

    Response response = await get(url);
    String body = response.body;

    if (response.statusCode == 200) {
      return [true, body];
    } else {
      return [false, body];
    }
  }


  Future patchRequest() async{

    Response response = await patch(url, headers: headers, body: json);

    String body = response.body;

    if (response.statusCode == 200) {
      return [true, body];
    } else {
      return [false, body];
    }
  }


  Future deleteRequest() async{

    Response response = await delete(url, headers: headers);
    String body = response.body;

    if (response.statusCode == 200) {
      return [true, body];
    } else {
      return [false, body];
    }
  }


}