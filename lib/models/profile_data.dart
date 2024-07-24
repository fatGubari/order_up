class ProfileLocation {
  double latitude;
  double longitude;

  ProfileLocation({
    required this.latitude,
    required this.longitude,
  });

  factory ProfileLocation.fromMap(Map<String, dynamic> map) {
    return ProfileLocation(
        latitude: map["latitude"], longitude: map["longitude"]);
  }

  @override
  String toString() {
    return '$latitude, $longitude';
  }
}

class ProfileData {
  String id;
  String name;
  String image;
  String email;
  String password;
  String phoneNumber;
  ProfileLocation? location;
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
