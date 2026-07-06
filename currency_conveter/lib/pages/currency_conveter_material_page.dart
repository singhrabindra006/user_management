import 'package:flutter/material.dart';
//import'package:flutter/foundation.dart';
//1. creating a variable that stores the converted value
//2. creating a funtion that multiplies the value given by the textfiled
//3. store the value in the variable that we created
//4. display the variable value

class CurrencyConveterMaterialPage extends StatefulWidget {
  const CurrencyConveterMaterialPage({super.key});
  @override
  State<CurrencyConveterMaterialPage> createState() =>
      _CurrencyConveterMaterialPageState();
}

class _CurrencyConveterMaterialPageState
    extends State<CurrencyConveterMaterialPage> {
  double result = 0;
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  final border = const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(10)),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 5,
        title: const Text(
          "Currency Converter",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),

        centerTitle: true,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //int -> string itergervalue.toString
            //string -> int int.parse(stringvalue)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'NRs ${result.toString()}',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 158, 54, 244),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: textEditingController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Please enter amount in USD",
                  hintStyle: const TextStyle(color: Colors.black),
                  prefixIcon: const Icon(Icons.monetization_on),
                  prefixIconColor: Colors.black,
                  filled: true,
                  fillColor: Colors.white60,

                  focusedBorder: border,
                  enabledBorder: border,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
            ),
            //button
            //raised button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TextButton(
                onPressed: () {
                  // update the field and trigger rebuild
                  setState(() {
                    result = (double.parse(textEditingController.text) * 151.8);
                    textEditingController.clear();
                  });

                  /*debug, release, profile---- from here we can run the debug mode in emulator but cannot release and profile its need real device
                  if (kDebugMode) {
                    print(double.parse(textEditingController.text) * 152.70);
                  }*/
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Convert'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
