import 'package:flutter/material.dart';
import 'package:qr_code/screens/qr_code_scanner.dart';
import 'package:qr_code/screens/qr_code_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _textEditingController = TextEditingController();
  final _key = GlobalKey<FormState>();
  String? selectedValue;
  List<String> valueList = ["Dot", "Plain"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text(
          "Home",
          style: Theme.of(
            context,
          ).textTheme.titleSmall!.copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => QrCodeScanner()),
              );
            },
            icon: Icon(Icons.document_scanner, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  hintText: "Enter Text",
                  hintStyle: Theme.of(
                    context,
                  ).textTheme.titleSmall!.copyWith(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter Qr Value";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              qrStyleSelector(),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (_key.currentState!.validate()) {
                    if (selectedValue != null) {
                      var data = _textEditingController.text;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QrCodeScreen(
                            data: data,
                            selectedData: selectedValue!,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Select qr type"),
                        backgroundColor: Colors.red,
                      ));
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Generate Qr Code",
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium!.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget qrStyleSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: valueList.map((value) {
        final bool isSelected = selectedValue == value;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected ? Colors.green : Colors.grey.shade300,
              foregroundColor: isSelected ? Colors.white : Colors.black,
              elevation: isSelected ? 4 : 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              setState(() {
                selectedValue = value;
              });
            },
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        );
      }).toList(),
    );
  }
}
