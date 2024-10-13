import 'package:e_store/models/Product.dart';
import 'package:e_store/pages/cart/cart.dart';
import 'package:e_store/pages/checkout/checkout.dart';
import 'package:e_store/pages/homepage/landing.dart';
import 'package:e_store/services/product_service.dart';
import 'package:e_store/state/cart_provider.dart';
import 'package:flutter/material.dart';
import "package:e_store/models/SingleProduct.dart";
import 'package:provider/provider.dart';

class MyProduct extends StatefulWidget {
  final int? id;
  const MyProduct({super.key, required this.id});

  @override
  State<MyProduct> createState() => _MyProductState();
}

class _MyProductState extends State<MyProduct> {
  SigleProduct? product;
  void fetchProduct() async {
    try {
      final result = await ProductService().fetchProduct(widget.id.toString());
      setState(() {
        product = result;
      });
    } catch (e) {
      ProductService().showToast(e.toString(), isError: true);
    }
  }

  Product convertToProduct(SigleProduct singleProduct) {
    return Product(
        productId: singleProduct.productId,
        title: singleProduct.title,
        description: singleProduct.description,
        price: singleProduct.price.toDouble(),
        discount: singleProduct.discount.toDouble(),
        quantity: singleProduct.quantity,
        unitOfMeasurement: singleProduct.unitOfMeasurement,
        stockBalance: singleProduct.stockBalance,
        categoryId: singleProduct.categoryId,
        merchantId: singleProduct.merchantId,
        merchant: convertToProductMerchant(singleProduct.merchant),
        images: singleProduct.images
            .map((image) => convertToProductImage(image))
            .toList(),
        createdAt: DateTime.parse(singleProduct.createdAt),
        updatedAt: DateTime.parse(singleProduct.updatedAt));
  }

  ProductImage convertToProductImage(SingleProductImage singleProductImage) {
    return ProductImage(
        productImageId: singleProductImage.productImageId,
        imageUrl: singleProductImage.imageUrl);
  }

  Merchant convertToProductMerchant(
      SigleProductMerchant singleProductMerchant) {
    return Merchant(
        merchantId: singleProductMerchant.merchantId,
        businessName: singleProductMerchant.businessName,
        merchantType: singleProductMerchant.merchantType,
        subscriptionStatus: singleProductMerchant.subscriptionStatus,
        subscriptionEndDate: singleProductMerchant.subscriptionEndDate,
        createdAt: DateTime.parse(singleProductMerchant.createdAt),
        updatedAt: DateTime.parse(singleProductMerchant.updatedAt));
  }

  @override
  void initState() {
    fetchProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
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
        title: Text(
          product?.title ?? 'Loading...',
          style: const TextStyle(
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
                const Icon(
                  Icons.shopping_bag_outlined,
                  color: Color(0xFF12B981),
                ),
                if (cartItemCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
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
      body: product == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(children: [
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: product!.images.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                height: 250,
                                width: MediaQuery.of(context).size.width * 0.95,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                child: Center(
                                  child: Container(
                                    height: 250 * 0.9,
                                    width: MediaQuery.of(context).size.width *
                                        0.95 *
                                        0.9,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.network(
                                        product!.images[index].imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ));
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 130,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              product!.title,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Company: Kenya seeds',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.grey),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'KSH ${product!.price}.00',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.blue),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Units available in stock : ${product!.stockBalance} units',
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 170,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'PRODUCT DETAILS',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            Divider(
                              color: Colors.grey[300],
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                product?.description ?? "",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400),
                                maxLines: 5,
                              ),
                            ),
                          ]),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ]),
                ),
              ),
            ),
      bottomNavigationBar: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Checkout()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFF12B981),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      child: const Icon(
                        Icons.shopping_basket_outlined,
                        size: 20,
                        color: Color(0xFF12B981),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Landing()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFF12B981),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      child: const Icon(
                        Icons.home_outlined,
                        size: 20,
                        color: Color(0xFF12B981),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: cartProvider.isInCart(convertToProduct(product!))
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF12B981)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: IconButton(
                              icon: const Icon(
                                Icons.remove,
                                color: Color(0xFF12B981),
                              ),
                              onPressed: () {
                                cartProvider.decreaseQuantity(
                                    product?.productId.toString() ?? "");
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                            '${cartProvider.getQuantity(product!.productId.toString())}'),
                        const SizedBox(width: 20),
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF12B981),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: IconButton(
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                cartProvider.addOrIncreaseQuantity(
                                    convertToProduct(product!),
                                    product!.productId.toString());
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  : ElevatedButton.icon(
                      onPressed: () {
                        cartProvider.addProduct(convertToProduct(product!));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF12B981),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      icon: const Icon(
                        Icons.shopping_bag_outlined,
                        size: 20,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Add to Cart',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
