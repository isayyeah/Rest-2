// lib/screens/pharmacies_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_pharmacies_2023/models/pharmacie.dart';
import 'package:flutter_pharmacies_2023/services/pharmacie_service.dart';
import 'package:flutter_pharmacies_2023/ui/ajoutPharmacie.dart';
import 'package:flutter_pharmacies_2023/ui/map_screen.dart';

class PharmaciesEcran extends StatefulWidget {
  @override
  _PharmaciesEcranState createState() => _PharmaciesEcranState();
}

class _PharmaciesEcranState extends State<PharmaciesEcran> {
  final PharmacieService pharmacieService = PharmacieService();

  Future<List<Pharmacie>> chargerPharmacies() async {
    try {
      final pharmacies = await pharmacieService.chargerPharmacies();
      return pharmacies;
    } catch (e) {
      throw Exception('Erreur de chargement des pharmacies: $e');
    }
  }

  List<Pharmacie> _pharmacies = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des pharmacies'),
      ),
      body: FutureBuilder<List<Pharmacie>>(
        future: chargerPharmacies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erreur: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Aucune pharmacie disponible.'),
            );
          } else {
            final pharmacies = snapshot.data!;
            return ListView.builder(
              itemCount: pharmacies.length,
              itemBuilder: (context, index) {
                final pharmacie = pharmacies[index];
                return ListTile(
                    title: Text(pharmacie.nom),
                    subtitle: Text(pharmacie.quartier),
                    leading:
                        Image.network(pharmacie.image, width: 50, height: 50),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapScreen(
                            latitude:
                                double.parse(pharmacie.latitude.toString()),
                            longitude:
                                double.parse(pharmacie.longitude.toString()),
                            pharmacyName: pharmacie.nom,
                          ),
                        ),
                      );
                    },
                    //add a delete button
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // Show confirmation dialog before deletion
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Supprimer la pharmacie'),
                              content: const Text(
                                  'Voulez-vous vraiment supprimer cette pharmacie?'),
                              actions: [
                                TextButton(
                                  child: const Text('Annuler'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Supprimer'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    //Suppression de la pharmacie
                                    pharmacieService
                                        .supprimerPharmacie(pharmacie.id);
                                    //refresh the list
                                    setState(() {
                                      pharmacies.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ));
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: //Ajout d'une pharmacie
            () {
          //show AjoutPharmacieEcran
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return AddPharmacyModal(
                onAddPharmacy: (Pharmacie) {
                  pharmacieService.creerPharmacie(Pharmacie);
                },
              );
            },
          );
        },
        tooltip: 'Ajouter une pharmacie',
        child: Icon(Icons.add),
      ),
    );
  }
}
