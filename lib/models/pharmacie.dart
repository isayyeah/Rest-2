import 'package:uuid/uuid.dart';

class Pharmacie {
  String id; // Mappé à recordid
  String nom; // Mappé à pharmacie
  String quartier; // Mappé à quartier
  double latitude;
  double longitude;
  String image;

  Pharmacie({
    String? id,
    required this.nom,
    required this.quartier,
    required this.latitude,
    required this.longitude,
    required this.image,
  }) : id = id ?? const Uuid().v4();

  //Ajouter ce qu'il faut pour les conversions JSON: Pharmacie.fromJson et toJson
  factory Pharmacie.fromJson(Map<String, dynamic> json) {
    return Pharmacie(
      id: json['id'],
      nom: json['fields']['pharmacie'],
      quartier: json['fields']['quartier'],
      latitude: double.parse(json['fields']['latitude']),
      longitude: double.parse(json['fields']['longitude']),
      image: json['fields']['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recordid': id,
      'pharmacie': nom,
      'quartier': quartier,
      'latitude': latitude,
      'longitude': longitude,
      'image': image,
    };
  }
}
