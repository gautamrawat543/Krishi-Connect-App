import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:krishi_connect_app/main_screen.dart';
import 'package:krishi_connect_app/services/api/api_service.dart';
import 'package:krishi_connect_app/utils/app_styles.dart';
import 'package:krishi_connect_app/utils/navigation_helper.dart';
import 'package:krishi_connect_app/utils/shared_pref_helper.dart';

class EditListing extends StatefulWidget {
  const EditListing({required this.listing, super.key});

  final dynamic listing;

  @override
  State<EditListing> createState() => _EditListingState();
}

class _EditListingState extends State<EditListing> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _requiredQuantityController =
      TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.listing['title'];
    _descriptionController.text = widget.listing['description'];
    _requiredQuantityController.text =
        widget.listing['requiredQuantity'].toString();
    _maxPriceController.text = widget.listing['maxPrice'].toString();
    _selectedCategory = widget.listing['category'];
    _selectedUnit = widget.listing['unit'];
  }

  String _selectedCategory = 'GRAINS';
  String _selectedUnit = 'KG';

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

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _requiredQuantityController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  ApiService apiService = ApiService();
  Future<void> _submitForm() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await apiService.updateBuyerRequest(
        requestId: widget.listing['requestId'],
        businessId: int.tryParse(SharedPrefHelper.getUserId()) ?? 0,
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
        _showSnackBar("Listing Updated Successfully!", isError: false);
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreenDark,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Edit Purchase Request',
                  style: AppTextStyles.pageHeading),
              SizedBox(height: 20),
              _buildLabel('Title'),
              _buildTextField('eg: Bulk Purchase of Tomatoes', _titleController,
                  TextInputType.text),
              _buildLabel('Description'),
              _buildTextField('eg: Looking for high quality tomatoes in bulk',
                  _descriptionController, TextInputType.text),
              _buildLabel('Category'),
              _buildDropdownField(categories, _selectedCategory, (value) {
                setState(() => _selectedCategory = value!);
              }),
              SizedBox(height: 8),
              Row(children: [
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Required Quantity'),
                        _buildTextField('eg: 500', _requiredQuantityController,
                            TextInputType.number),
                      ]),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Unit'),
                        _buildDropdownField(units, _selectedUnit, (value) {
                          setState(() => _selectedUnit = value!);
                        }),
                      ]),
                ),
              ]),
              SizedBox(height: 8),
              _buildLabel('Max Price'),
              _buildTextField(
                  'eg: 1600', _maxPriceController, TextInputType.number),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _submitForm(),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  width: width * 0.9,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Update Listing',
                          style: AppTextStyles.buttonTextStyle,
                          textAlign: TextAlign.center,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      TextInputType keyboardType) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: customInputDecoration(label),
      ),
    );
  }

  Widget _buildDropdownField(List<String> items, String selectedValue,
      ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        isExpanded: true,
        decoration: customInputDecoration(''),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(text, style: AppTextStyles.labelStyle),
    );
  }
}
