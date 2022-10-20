import 'package:get/get.dart';
import 'package:getx_level2/model/product_model.dart';
import 'package:getx_level2/data/services.dart';

class Controller extends GetxController{
  var productList = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() async{
    var products = await Services.fetchProducts();
    if(products !=null){
      productList.value = products;
    }
  }
}