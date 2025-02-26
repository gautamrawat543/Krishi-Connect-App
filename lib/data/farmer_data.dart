class Farmer {
  final String name;
  final String number;
  final String state;
  final String crop;

  Farmer({
    required this.name,
    required this.number,
    required this.state,
    required this.crop,
  });
}

List<Farmer> farmers = [
  Farmer(name: "Gautam", number: "+91 9876543210", state: "Maharashtra", crop: "Rice"),
  Farmer(name: "Amit", number: "+91 8765432109", state: "Punjab", crop: "Wheat"),
  Farmer(name: "Ramesh", number: "+91 7654321098", state: "Karnataka", crop: "Sugarcane"),
  Farmer(name: "Suresh", number: "+91 6543210987", state: "Gujarat", crop: "Cotton"),
  Farmer(name: "Vikram", number: "+91 9432109876", state: "Uttar Pradesh", crop: "Rice"), // Same as Gautam
  Farmer(name: "Manoj", number: "+91 9321098765", state: "Bihar", crop: "Wheat"), // Same as Amit
  Farmer(name: "Anil", number: "+91 9210987654", state: "Madhya Pradesh", crop: "Soybean"),
  Farmer(name: "Rajesh", number: "+91 9109876543", state: "Rajasthan", crop: "Mustard"),
  Farmer(name: "Harish", number: "+91 9098765432", state: "Tamil Nadu", crop: "Sugarcane"), // Same as Ramesh
  Farmer(name: "Mahesh", number: "+91 8987654321", state: "West Bengal", crop: "Jute"),
  Farmer(name: "Prakash", number: "+91 8876543210", state: "Telangana", crop: "Cotton"), // Same as Suresh
  Farmer(name: "Sunil", number: "+91 8765432101", state: "Andhra Pradesh", crop: "Chili"),
  Farmer(name: "Dinesh", number: "+91 8654321092", state: "Haryana", crop: "Wheat"), // Same as Amit & Manoj
  Farmer(name: "Naresh", number: "+91 8543210983", state: "Odisha", crop: "Pulses"),
  Farmer(name: "Yash", number: "+91 8432109874", state: "Himachal Pradesh", crop: "Apple"),
];
