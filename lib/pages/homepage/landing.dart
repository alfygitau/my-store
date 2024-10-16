import 'package:e_store/models/Product.dart';
import 'package:e_store/models/ProductCategory.dart';
import 'package:e_store/pages/auth/account.dart';
import 'package:e_store/pages/auth/login.dart';
import 'package:e_store/pages/cart/cart.dart';
import 'package:e_store/pages/orders/orders.dart';
import 'package:e_store/pages/products/product.dart';
import 'package:e_store/pages/products/products.dart';
import 'package:e_store/services/product_service.dart';
import 'package:e_store/state/cart_provider.dart';
import 'package:e_store/state/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  Map<String, int> productQuantities = {};
  int _selectedIndex = 0;
  List<Product> products = [];
  List<ProductCategory> categories = [];
  final List<String> imageList = [
    'assets/images/new_seeds.webp',
    'assets/images/hero.jpg',
    'assets/images/fungi.jpg',
  ];

  void fetchProducts() async {
    try {
      final result = await ProductService().fetchProducts();
      setState(() {
        products = result;
        for (var product in products) {
          productQuantities.putIfAbsent(product.productId.toString(), () => 0);
        }
      });
    } catch (e) {
      ProductService().showToast(e.toString(), isError: true);
    }
  }

  void fetchCategories() async {
    try {
      final result = await ProductService().fetchCategories();
      setState(() {
        categories = result;
      });
    } catch (e) {
      ProductService().showToast(e.toString(), isError: true);
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Landing()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyCart()),
        );
        break;
      case 2:
        if (userProvider.isAuthenticated()) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyOrders()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
          );
        }
        break;
      case 3:
        if (userProvider.isAuthenticated()) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AccountProfile()),
          );
        } else {
          userProvider.setLastRoute('/account-profile');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
          );
        }
        break;
    }
  }

  @override
  void initState() {
    fetchProducts();
    fetchCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    int cartItemCount = cartProvider.cart.products.length;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(
              'assets/images/logo.svg',
              width: 30,
              height: 30,
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: Color(0xFF12B981),
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Stack(
                    children: <Widget>[
                      const Icon(Icons.shopping_bag_outlined,
                          color: Color(0xFF12B981)),
                      if (cartItemCount > 0)
                        Positioned(
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 12,
                              minHeight: 12,
                            ),
                            child: Text(
                              '$cartItemCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyCart()),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.help_outline,
                    color: Color(0xFF12B981),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color(0xFFF3F6F9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 150,
                width: double.infinity,
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 150.0,
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    autoPlayInterval: const Duration(seconds: 3),
                    viewportFraction: 1.0,
                  ),
                  items: imageList.map((imagePath) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Categories',
                    style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF12B981),
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Products(
                                      categoryId: categories[index].categoryId,
                                      category: categories[index].name),
                                ),
                              );
                            },
                            child: Container(
                              height: 35,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: const Color(0xFF12B981), width: 1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5))),
                              child: Center(
                                child: Text(
                                  categories[index].name,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Products',
                    style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF12B981),
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: products.map((product) {
                    String productId = product.productId.toString();
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MyProduct(id: product.productId),
                            ),
                          );
                        },
                        child: Container(
                          height: 130,
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 10),
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 125,
                                width: 100,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.network(
                                    product.images[0].imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        product.title,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        product.description,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.grey,
                                        ),
                                        textAlign: TextAlign.left,
                                        maxLines: 2,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          NumberFormat.currency(
                                                  symbol: 'KES ',
                                                  decimalDigits: 2)
                                              .format(product.price),
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyProduct(
                                                          id: product
                                                              .productId),
                                                ),
                                              );
                                            },
                                            child: const Icon(
                                                Icons.visibility_outlined,
                                                size: 20,
                                                color: Colors.black)),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Icon(Icons.favorite_border,
                                            size: 20, color: Colors.black),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              cartProvider
                                                  .addOrIncreaseQuantity(
                                                      product, productId);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const MyCart()),
                                              );
                                            },
                                            child: const Icon(
                                                Icons.shopping_bag_outlined,
                                                size: 20,
                                                color: Colors.black)),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: <Widget>[
                const Icon(Icons.shopping_bag_outlined),
                if (cartItemCount > 0)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        '$cartItemCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Orders',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF12B981),
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle: const TextStyle(color: Colors.grey),
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}
