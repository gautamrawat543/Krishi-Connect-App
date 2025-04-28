class ProduceItem {
  final String name;
  final String price;
  final String quantity;
  final String farmer;
  final String location;

  ProduceItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.farmer,
    required this.location,
  });
}

final List<ProduceItem> produceList = [
  ProduceItem(
    name: 'Tomatoes',
    price: '₹58/KG',
    quantity: '5500kg',
    farmer: 'Raj Kumar',
    location: 'Nashik',
  ),
  ProduceItem(
    name: 'Onions',
    price: '₹45/KG',
    quantity: '3000kg',
    farmer: 'Sita Devi',
    location: 'Pune',
  ),
  ProduceItem(
    name: 'Potatoes',
    price: '₹32/KG',
    quantity: '4800kg',
    farmer: 'Mohit Verma',
    location: 'Agra',
  ),
  ProduceItem(
    name: 'Carrots',
    price: '₹40/KG',
    quantity: '2500kg',
    farmer: 'Geeta Patel',
    location: 'Shimla',
  ),
  ProduceItem(
    name: 'Spinach',
    price: '₹28/KG',
    quantity: '1000kg',
    farmer: 'Ravi Yadav',
    location: 'Kanpur',
  ),
  ProduceItem(
    name: 'Cabbage',
    price: '₹35/KG',
    quantity: '1800kg',
    farmer: 'Sunita Meena',
    location: 'Jaipur',
  ),
  ProduceItem(
    name: 'Cauliflower',
    price: '₹38/KG',
    quantity: '2000kg',
    farmer: 'Harish Singh',
    location: 'Indore',
  ),
  ProduceItem(
    name: 'Green Peas',
    price: '₹60/KG',
    quantity: '1700kg',
    farmer: 'Anjali Reddy',
    location: 'Hyderabad',
  ),
  ProduceItem(
    name: 'Chillies',
    price: '₹55/KG',
    quantity: '1400kg',
    farmer: 'Karan Thakur',
    location: 'Bhopal',
  ),
  ProduceItem(
    name: 'Brinjal',
    price: '₹33/KG',
    quantity: '1600kg',
    farmer: 'Nisha Kumari',
    location: 'Patna',
  ),
];
