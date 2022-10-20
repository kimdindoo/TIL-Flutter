import 'package:getx_level2/model/product_model.dart';
import 'package:http/http.dart' as http;

class Services{
  static var client = http.Client();

  static Future<List<Product>?> fetchProducts() async{
    var response = await client.get(Uri.parse('http://makeup-api.herokuapp.com'
        '/api/v1/products.json?brand=maybelline'));

    if(response.statusCode == 200){
      var jsonData = response.body;
      return productFromJson(jsonData);
    }else{
      return null;
    }
  }
}