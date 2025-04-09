class Launch {
  final String id;
  final String name;
  final String net;
  final String? image;
  final String agencyName;
  final String? missionDescription;
  final List<String>? vidUrls;
  final List<String>? infoUrls;

  Launch({
    required this.id,
    required this.name,
    required this.net,
    this.image,
    required this.agencyName,
    this.missionDescription,
    this.vidUrls,
    this.infoUrls,
  });

  factory Launch.fromJson(Map<String, dynamic> json) {
    return Launch(
      id: json['id'],
      name: json['name'],
      net: json['net'],
      image: json['image'],
      agencyName: json['launch_service_provider']['name'],
      missionDescription: json['mission']?['description'],
      vidUrls: (json['vid_urls'] as List?)?.map((e) => e['url'] as String).toList(),
      infoUrls: json['info_urls'] as List<String>?,
    );
  }
}