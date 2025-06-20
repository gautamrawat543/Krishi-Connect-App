import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:krishi_connect_app/main_screen.dart';
import 'package:krishi_connect_app/services/api/api_service.dart';
import 'package:krishi_connect_app/utils/navigation_helper.dart';
import 'package:krishi_connect_app/utils/shared_pref_helper.dart';

class FarmerListing extends StatefulWidget {
  @override
  _FarmerListingState createState() => _FarmerListingState();
}

class _FarmerListingState extends State<FarmerListing> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  final TextEditingController _requiredQuantityController =
      TextEditingController();

  String category = 'GRAINS';
  String unit = 'KG';
  String status = 'AVAILABLE';

  File? imageFile;

  final List<String> categories = [
    'GRAINS',
    'FRUITS',
    'VEGETABLES',
    'DAIRY',
    'MEAT',
    'LIVESTOCK',
    'OTHERS'
  ];
  final List<String> units = ['KG', 'QUINTAL', 'TON', 'LITRE', 'DOZEN', 'UNIT'];
  final List<String> statusList = ['AVAILABLE', 'SOLD'];

  final ApiService apiService = ApiService();

  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }


   Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await apiService.createFarmerListing(
        farmerId: int.tryParse(SharedPrefHelper.getUserId()) ?? 0,
        title: _titleController.text,
        description: _descriptionController.text,
        category: category,
        unit: unit,
        location: SharedPrefHelper.getLocation(),
        requiredQuantity: int.tryParse(_requiredQuantityController.text) ?? 0,
        maxPrice: double.tryParse(_maxPriceController.text) ?? 0.0,
        profilePicFile: imageFile,
        status: status,
        token: SharedPrefHelper.getToken(),
      );

      if (response.containsKey('error')) {
        _showSnackBar(response['error'], isError: true);
      } else {
        _showSnackBar("Listing created successfully!", isError: false);
        NavigationHelper.pushReplacement(context, MainScreen());
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
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(107, 142, 35, 1),
        title: const Text("Bulk Purchase Request"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildLabel('Title'),
              _buildTextField(
                  _titleController, 'eg: Bulk Purchase of Tomatoes'),
              _buildLabel('Description'),
              _buildTextField(_descriptionController,
                  'eg: Looking for high quality tomatoes in bulk'),
              _buildLabel('Category'),
              _buildDropdown(categories, category,
                  (val) => setState(() => category = val!)),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Required Quantity'),
                        _buildTextField(_requiredQuantityController, 'eg: 500',
                            isNumber: true),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Unit'),
                        _buildDropdown(
                            units, unit, (val) => setState(() => unit = val!)),
                      ],
                    ),
                  ),
                ],
              ),
              _buildLabel('Max Price'),
              _buildTextField(_maxPriceController, 'eg: 1600', isNumber: true),
              _buildLabel('Select Image'),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  margin: EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: imageFile != null
                      ? Image.file(imageFile!, fit: BoxFit.cover)
                      : Center(child: Text('Tap to select image')),
                ),
              ),
              _buildLabel('Status'),
              _buildDropdown(
                  statusList, status, (val) => setState(() => status = val!)),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _submitForm,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  width: width * 0.9,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(85, 107, 47, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.white))
                      : const Text(
                          'Create Listing',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Color.fromRGBO(0, 0, 0, 0.3),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: hint,
          labelStyle: const TextStyle(fontSize: 14),
          border: const OutlineInputBorder(),
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
        validator: (val) {
          if (val == null || val.trim().isEmpty) return 'Required';
          if (isNumber && double.tryParse(val.trim()) == null)
            return 'Enter a valid number';
          return null;
        },
      ),
    );
  }

  Widget _buildDropdown(List<String> items, String selectedValue,
      ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        isExpanded: true,
        decoration: const InputDecoration(border: OutlineInputBorder()),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _maxPriceController.dispose();
    _requiredQuantityController.dispose();
    super.dispose();
  }
}
