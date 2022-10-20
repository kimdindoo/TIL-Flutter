import 'package:get/get.dart';

import 'package:getx_level1/model/product.dart';

class ShoppingController extends GetxController{
  var products = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() async{
    await Future.delayed(Duration(seconds: 2));
    var productData = [
      Product(id: 1, productName: 'Mouse', productDescription: 'some description about product', price: 30),
      Product(id: 2, productName: 'Keyboard', productDescription: 'some description about product', price: 40),
      Product(id: 3, productName: 'Monitor', productDescription: 'some description about product', price: 50),
      Product(id: 4, productName: 'Ram', productDescription: 'some description about product', price: 60),
      Product(id: 5, productName: 'Speaker', productDescription: 'some description about product', price: 70),
    ];

    products.assignAll(productData);
  }
}