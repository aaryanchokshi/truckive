class SearchInfo {
  final String name;
  final double latitude;
  final double longitude;

  SearchInfo(
      {required this.name, required this.latitude, required this.longitude});

  factory SearchInfo.fromPhotonAPI(Map<String, dynamic> data) {
    final properties = data['properties'];
    final coordinates = data['geometry']['coordinates'];
    return SearchInfo(
      name: properties['name'],
      latitude: coordinates[1],
      longitude: coordinates[0],
    );
  }
}
