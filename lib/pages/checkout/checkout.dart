import 'package:e_store/models/Address.dart';
import 'package:e_store/pages/auth/address.dart';
import 'package:e_store/pages/auth/login.dart';
import 'package:e_store/pages/cart/cart.dart';
import 'package:e_store/pages/homepage/landing.dart';
import 'package:e_store/pages/orders/orders.dart';
import 'package:e_store/services/address_service.dart';
import 'package:e_store/services/product_service.dart';
import 'package:e_store/state/cart_provider.dart';
import 'package:e_store/state/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  bool isCard = false;
  List<Address> myAddress = [];

  void _fetchCustomerAddresses() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.token;
    final user = userProvider.user;
    final addressService = AddressService();
    final addresses = await addressService.getCustomerAddresses(
        token!, user!.customerId.toString());
    if (addresses != null) {
      setState(() {
        myAddress = addresses;
      });
    } else {
      ProductService()
          .showToast('Failed to fetch customer addresses.', isError: true);
      myAddress = [];
    }
  }

  void placeOrder() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;
    final token = userProvider.token;
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final cartItems = cartProvider.cart.products;
    if (myAddress.isEmpty) {
      ProductService().showToast("Add an address for delivery", isError: true);
      return;
    }
    if (!userProvider.isAuthenticated()) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
      return;
    }
    ProductService productService = ProductService();
    final orderItems = cartItems.map((item) {
      return {
        "productId": item.product.productId,
        "quantity": item.quantity,
        "price": item.product.price
      };
    }).toList();
    final mobileMoneyPayment = {
      "paymentProvider": "MPESA",
      "msisdn": user!.msisdn
    };
    final result = await productService.placeOrder(
        orderItems: orderItems,
        customerId: user.customerId,
        merchantId: 5,
        totalAmount: cartProvider.cart.totalPrice,
        shippingAddressId: myAddress[0].shippingAddressId,
        isDelivery: true,
        paymentMethod: "mobile_Money",
        mobileMoneyPayment: mobileMoneyPayment,
        token: token!);
    if (result != null) {
      ProductService().showToast("Order placed successfully");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyOrders()),
      );
    } else {
      ProductService().showToast("Order placement failed.", isError: true);
    }
  }

  @override
  void initState() {
    _fetchCustomerAddresses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    int cartItemCount = cartProvider.cart.products.length;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Checkout",
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: <Widget>[
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
      backgroundColor: const Color(0xFFF3F6F9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 100,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: myAddress.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text(
                                'Deliver to',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${myAddress[0].zipCode}, ${myAddress[0].addressLine1}, ${myAddress[0].city}, ${myAddress[0].country}',
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal),
                              ),
                              Text(
                                userProvider.user!.msisdn,
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal),
                              )
                            ],
                          )
                        : GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyAddress()),
                              );
                            },
                            child: const Align(
                              child: Text(
                                'Click to add your address',
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 13),
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 250,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "PRICE DETAILS",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Divider(
                          color: Colors.grey[300],
                          thickness: 1,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Price(${cartProvider.cart.products.length} products)",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                NumberFormat.currency(
                                        symbol: 'KES ', decimalDigits: 2)
                                    .format(cartProvider.cart.totalPrice),
                                style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Divider(
                          color: Colors.grey[300],
                          thickness: 1,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Delivery",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "free",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Divider(
                          color: Colors.grey[300],
                          thickness: 1,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Total amount",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                NumberFormat.currency(
                                        symbol: 'KES ', decimalDigits: 2)
                                    .format(cartProvider.cart.totalPrice),
                                style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Divider(
                          color: Colors.grey[300],
                          thickness: 1,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "You saved KES 120.00 on this order",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: Colors.red),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 250,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "PAYMENT DETAILS",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Divider(
                          color: Colors.grey[300],
                          thickness: 1,
                        ),
                        Row(
                          children: [
                            Transform.scale(
                              scale: 0.6,
                              child: Checkbox(
                                value: isCard,
                                onChanged: (value) {},
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "Credit / Debit / ATM Card",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.grey[300],
                          thickness: 1,
                        ),
                        Row(
                          children: [
                            Transform.scale(
                              scale: 0.6,
                              child: Checkbox(
                                value: isCard,
                                onChanged: (value) {},
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "Paypal",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.grey[300],
                          thickness: 1,
                        ),
                        Row(
                          children: [
                            Transform.scale(
                                scale: 0.6,
                                child: Checkbox(
                                  value: isCard,
                                  onChanged: (value) {},
                                )),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "Cash on delivery",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.grey[300],
                          thickness: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              )),
        ),
      ),
      bottomNavigationBar: Container(
        height: 90,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Landing()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  minimumSize: const Size(0, 35),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    "Cancel order",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: placeOrder,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFF12B981),
                    side: const BorderSide(color: Color(0xFF12B981)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    minimumSize: const Size(60, 35),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      "Place order",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
