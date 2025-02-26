class CompanyListing {
  final String companyName;
  final String product;
  final int quantity;
  final double price;
  final String description;

  CompanyListing({
    required this.companyName,
    required this.product,
    required this.quantity,
    required this.price,
    required this.description,
  });
}

List<CompanyListing> sampleListings = [
  CompanyListing(
      companyName: 'AgroFarm Ltd.',
      product: 'Wheat',
      quantity: 200,
      price: 1500.0,
      description: 'High-quality organic wheat.'),
  CompanyListing(
      companyName: 'GreenHarvest',
      product: 'Corn',
      quantity: 150,
      price: 1200.0,
      description: 'Freshly harvested yellow corn.'),
  CompanyListing(
      companyName: 'Organic Fields',
      product: 'Rice',
      quantity: 300,
      price: 2000.0,
      description: 'Premium organic rice.'),
  CompanyListing(
      companyName: 'Farmers Hub',
      product: 'Barley',
      quantity: 180,
      price: 1300.0,
      description: 'Best quality barley grains.'),
  CompanyListing(
      companyName: 'Golden Crops',
      product: 'Soybeans',
      quantity: 250,
      price: 1800.0,
      description: 'Non-GMO soybeans for healthy consumption.'),
  CompanyListing(
      companyName: 'AgriCorp',
      product: 'Cotton',
      quantity: 400,
      price: 2500.0,
      description: 'High-grade cotton for textiles.'),
  CompanyListing(
      companyName: 'Nature Fresh',
      product: 'Sugarcane',
      quantity: 220,
      price: 1600.0,
      description: 'Sweet and juicy sugarcane.'),
  CompanyListing(
      companyName: 'Harvest Time',
      product: 'Oats',
      quantity: 130,
      price: 1400.0,
      description: 'Healthy and nutritious oats.'),
  CompanyListing(
      companyName: 'FarmTech',
      product: 'Lentils',
      quantity: 170,
      price: 1700.0,
      description: 'Protein-rich lentils for daily diet.'),
  CompanyListing(
      companyName: 'Pure Agro',
      product: 'Chickpeas',
      quantity: 280,
      price: 1900.0,
      description: 'Premium quality chickpeas.'),
  CompanyListing(
      companyName: 'EcoGrow',
      product: 'Peanuts',
      quantity: 210,
      price: 1550.0,
      description: 'Organic peanuts with rich flavor.'),
  CompanyListing(
      companyName: 'Crop Masters',
      product: 'Millets',
      quantity: 190,
      price: 1350.0,
      description: 'Gluten-free and highly nutritious millets.'),
  CompanyListing(
      companyName: 'Sunny Farms',
      product: 'Sesame',
      quantity: 260,
      price: 1750.0,
      description: 'Freshly harvested sesame seeds.'),
  CompanyListing(
      companyName: 'Rural Harvest',
      product: 'Coffee Beans',
      quantity: 300,
      price: 3000.0,
      description: 'Aromatic and rich coffee beans.'),
  CompanyListing(
      companyName: 'Evergreen Agro',
      product: 'Tea Leaves',
      quantity: 230,
      price: 2200.0,
      description: 'Premium tea leaves for a refreshing brew.'),
];
