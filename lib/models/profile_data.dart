class ProfileData {
  String id;
  String name;
  String image;
  String email;
  String password;
  String phoneNumber;
  String? location;
  String? rate;
  String? category;

  ProfileData(
      {required this.id,
      required this.name,
      required this.image,
      required this.email,
      required this.password,
      required this.phoneNumber,
      required this.location,
      this.rate,
      this.category});
}
