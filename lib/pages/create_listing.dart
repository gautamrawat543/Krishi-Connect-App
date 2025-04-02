import 'package:flutter/material.dart';
import 'package:krishi_connect_app/services/api/register_api.dart';
import 'package:krishi_connect_app/utils/shared_pref_helper.dart';

class CreateListing extends StatefulWidget {
  const CreateListing({super.key});

  @override
  State<CreateListing> createState() => _CreateListingState();
}

class _CreateListingState extends State<CreateListing> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _requiredQuantityController =
      TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  String _selectedCategory = 'GRAINS';
  String _selectedUnit = 'KG';

  final List<String> categories = ['GRAINS', 'FRUITS', 'VEGETABLES'];
  final List<String> units = ['KG', 'LITRE', 'TON'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _requiredQuantityController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  bool _isLoading = false;

RegisterService apiService = RegisterService();
  Future<void> _submitForm() async {
    setState(() {
      _isLoading = true;
    });

    try {

      final response = await apiService.createBuyerRequest(
        businessId:int.tryParse(SharedPrefHelper.getUserId()) ?? 0,
        title: _titleController.text,
        description: _descriptionController.text,
        category: _selectedCategory,
        unit: _selectedUnit,
        location: SharedPrefHelper.getLocation(),
        requiredQuantity: int.tryParse(_requiredQuantityController.text) ?? 0,
        maxPrice: double.tryParse(_maxPriceController.text) ?? 0.0,
        token: SharedPrefHelper.getToken(),
      );

      if (response.containsKey('error')) {
        _showSnackBar(response['error'], isError: true);
      } else {
        _showSnackBar("Listing created successfully!", isError: false);
      }
    } catch (e) {
      _showSnackBar("An unexpected error occurred", isError: true);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Listing'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildTextField('Title', _titleController, TextInputType.text),
              buildTextField(
                  'Description', _descriptionController, TextInputType.text),
              buildDropdownField('Category', categories, _selectedCategory,
                  (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              }),
              buildTextField('Required Quantity', _requiredQuantityController,
                  TextInputType.number),
              buildDropdownField('Unit', units, _selectedUnit, (value) {
                setState(() {
                  _selectedUnit = value!;
                });
              }),
              buildTextField(
                  'Max Price', _maxPriceController, TextInputType.number),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: _submitForm,
                      child: const Text('Create Listing',
                          style: TextStyle(color: Colors.white)),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      TextInputType keyboardType) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildDropdownField(String label, List<String> items,
      String selectedValue, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
