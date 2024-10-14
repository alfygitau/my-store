import 'package:e_store/pages/auth/account.dart';
import 'package:e_store/services/address_service.dart';
import 'package:e_store/services/product_service.dart';
import 'package:e_store/state/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAddress extends StatefulWidget {
  const MyAddress({super.key});

  @override
  State<MyAddress> createState() => _MyAddressState();
}

class _MyAddressState extends State<MyAddress> {
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipcodeController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  bool _isLoading = false;

  void _createAddress() async {
    setState(() {
      _isLoading = true;
    });
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;
    final token = userProvider.token;
    AddressService addressService = AddressService();
    Map<String, dynamic> addressData = {
      "customerId": user?.customerId,
      "addressLine1": _address1Controller.text,
      "addressLine2": _address2Controller.text,
      "city": _cityController.text,
      "state": _stateController.text,
      "zipCode": _zipcodeController.text,
      "country": _countryController.text
    };
    bool success = await addressService.createAddress(addressData, token!);
    if (success) {
      setState(() {
        _isLoading = false;
      });
      ProductService().showToast('Address created successfully!');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AccountProfile()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to create address. Please try again.')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Create your address',
                      style: TextStyle(fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _buildInputLabel("My county"),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    _buildInputField("Enter my county", _stateController),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _buildInputLabel('My city'),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    _buildInputField("Enter my city", _cityController),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _buildInputLabel('Zipcode'),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    _buildInputField("Enter zipcode", _zipcodeController),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _buildInputLabel('My country'),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    _buildInputField("Enter my country", _countryController),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _buildInputLabel('Enter address 1'),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    _buildInputField("Enter address 1", _address1Controller),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _buildInputLabel('Enter address 2'),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    _buildInputField("Enter address 2", _address2Controller),
                    const SizedBox(
                      height: 20,
                    ),
                    OutlinedButton(
                      onPressed: _isLoading ? null : _createAddress,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Color(0xFF12B981)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          "Confirm",
                          style: TextStyle(
                            color: Color(0xFF12B981),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ));
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildInputField(String hintText, TextEditingController controller,
      {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      cursorColor: Colors.black,
      obscureText: isPassword,
      style: const TextStyle(fontSize: 13),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(40.0),
        bottomRight: Radius.circular(40.0),
      ),
      child: AppBar(
        backgroundColor: const Color(0xFF12B981),
        toolbarHeight: 100,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'My address',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100.0);
}
