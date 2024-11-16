import 'dart:async';

enum Role { Admin, Customer }

//class Product
class Product {
  String productName;
  double price;
  bool inStock;

  Product({required this.productName, required this.price, required this.inStock});
}

//class user
class User {
  String name;
  int age;
  late List<Product> products;
  Role? role;

  User({required this.name, required this.age, this.role}) {
    products = [];
  }

  void viewProducts() {
    if (products.isNotEmpty) {
      for (var product in products) {
        print("Nama Produk: ${product.productName}, Harga: ${product.price}, Tersedia: ${product.inStock}");
      }
    } else {
      print("Produk tidak tersedia.");
    }
  }
}

//subclass admin user
class AdminUser extends User {
  Set<String> productNames = {};

  AdminUser({required String name, required int age})
      : super(name: name, age: age) {
    role = Role.Admin; 
  }

  void addProduct(Product product, Map<String, Product> productList) {
    try {
      if (!product.inStock) {
        throw Exception("Produk tidak tersedia dalam stok.");
      }
      if (productNames.contains(product.productName)) {
        print("Produk sudah tersedia dalam daftar.");
      } else {
        productList[product.productName] = product;
        products.add(product);
        productNames.add(product.productName);
        print("Produk ${product.productName} berhasil ditambahkan.");
      }
    } on Exception catch (e) {
      print("Gagal menambahkan produk: ${e.toString()}");
    } catch (e) {
      print("Gagal menambahkan produk: Kesalahan tidak terduga: ${e.toString()}");
    }
  }

  void removeProduct(String productName, Map<String, Product> productList) {
    if (productList.containsKey(productName)) {
      productList.remove(productName);
      products.removeWhere((product) => product.productName == productName);
      productNames.remove(productName);
      print("Produk $productName berhasil dihapus.");
    } else {
      print("Produk tidak ditemukan dalam daftar.");
    }
  }
}

//subclass customer user
class CustomerUser extends User {
  CustomerUser({required String name, required int age})
      : super(name: name, age: age) {
    role = Role.Customer;
  }
}

Future<void> fetchProductDetails() async {
  print("Mengambil detail produk dari server...");
  await Future.delayed(Duration(seconds: 3));
  print("Detail produk telah berhasil diambil.");
}

void main() async {
  Map<String, Product> productList = {};

  var admin = AdminUser(name: "Sari", age: 20);
  var customer = CustomerUser(name: "Nir", age: 23);

  print("Admin: ${admin.name}, Usia: ${admin.age}");

  admin.addProduct(
      Product(productName: "Laptop", price: 15000000, inStock: true),
      productList);
  admin.addProduct(
      Product(productName: "Keyboard", price: 500000, inStock: true),
      productList);
  admin.addProduct(
      Product(productName: "Printer", price: 13000000, inStock: false),
      productList);

  admin.removeProduct("Laptop", productList);
  admin.viewProducts();

  customer.products = admin.products;

  print("\nCustomer: ${customer.name}, Usia: ${customer.age}");
  print("Customer dapat melihat daftar produk:");
  customer.viewProducts();

  await fetchProductDetails();
}