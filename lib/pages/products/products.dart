import 'package:e_store/models/CategoryProducts.dart';
import 'package:e_store/models/Product.dart';
import 'package:e_store/pages/products/product.dart';
import 'package:e_store/services/product_service.dart';
import 'package:e_store/state/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Products extends StatefulWidget {
  final int? categoryId;
  final String category;
  const Products({super.key, required this.categoryId, required this.category});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List<CategoryProduct> products = [];
  int productQuantity = 0;

  void fetchCategoryProducts() async {
    try {
      final result = await ProductService()
          .fetchProductsByCategory(widget.categoryId.toString());
      setState(() {
        products = result;
      });
    } catch (e) {
      ProductService().showToast(e.toString(), isError: true);
    }
  }

  Product convertToProduct(CategoryProduct categoryProduct) {
    return Product(
        productId: categoryProduct.productId,
        title: categoryProduct.title,
        description: categoryProduct.description,
        price: categoryProduct.price,
        discount: double.parse(categoryProduct.discount.toString()),
        quantity: categoryProduct.quantity,
        unitOfMeasurement: categoryProduct.unitOfMeasurement,
        stockBalance: categoryProduct.stockBalance,
        categoryId: categoryProduct.categoryId,
        merchantId: categoryProduct.merchantId,
        merchant: convertToProductMerchant(categoryProduct.merchant),
        images: categoryProduct.images
            .map((image) => convertToProductImage(image))
            .toList(),
        createdAt: DateTime.parse(categoryProduct.createdAt),
        updatedAt: DateTime.parse(categoryProduct.updatedAt));
  }

  ProductImage convertToProductImage(CategoryProductImage categoryImage) {
    return ProductImage(
        productImageId: categoryImage.productImageId,
        imageUrl: categoryImage.imageUrl);
  }

  Merchant convertToProductMerchant(CategoryProductsMerchant categoryMerchant) {
    return Merchant(
        merchantId: categoryMerchant.merchantId,
        businessName: categoryMerchant.businessName,
        merchantType: categoryMerchant.merchantType,
        subscriptionStatus: categoryMerchant.subscriptionStatus,
        subscriptionEndDate: categoryMerchant.subscriptionEndDate,
        createdAt: DateTime.parse(categoryMerchant.createdAt),
        updatedAt: DateTime.parse(categoryMerchant.updatedAt));
  }

  @override
  void initState() {
    fetchCategoryProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
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
            widget.category,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        backgroundColor: const Color(0xFFF3F6F9),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 70,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${products.length} products',
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.normal),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.filter_list,
                          size: 16,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Filter By',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: const Size(80, 30),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 600,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyProduct(
                                            id: products[index].productId)),
                                  );
                                },
                                child: Container(
                                  height: 150,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 7),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 10),
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 100,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: Image.network(
                                            products[index].images[0].imageUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              products[index].title,
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              products[index].description,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300,
                                                color: Colors.grey,
                                              ),
                                              textAlign: TextAlign.left,
                                              maxLines: 3,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "KES ${products[index].price}.00",
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      cartProvider
                                                          .decreaseQuantity(
                                                              products[index]
                                                                  .productId
                                                                  .toString());
                                                    },
                                                    child: Container(
                                                      height: 30,
                                                      width: 30,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 1,
                                                              color:
                                                                  Colors.grey),
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5))),
                                                      child: const Center(
                                                        child:
                                                            Icon(Icons.remove),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                      '${cartProvider.getQuantity(products[index].productId.toString())}'),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      cartProvider
                                                          .addOrIncreaseQuantity(
                                                              convertToProduct(
                                                                  products[
                                                                      index]),
                                                              products[index]
                                                                  .productId
                                                                  .toString());
                                                    },
                                                    child: Container(
                                                      height: 30,
                                                      width: 30,
                                                      decoration: const BoxDecoration(
                                                          color:
                                                              Color(0xFF12B981),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons.add,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ))
                                    ],
                                  ),
                                ))
                          ],
                        );
                      }),
                )
              ]),
            ),
          ),
        ));
  }
}
