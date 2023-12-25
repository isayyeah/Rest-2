import 'package:flutter/material.dart';
import 'package:flutter_pharmacies_2023/models/pharmacie.dart';

class AddPharmacyModal extends StatefulWidget {
  final Function(Pharmacie) onAddPharmacy;

  const AddPharmacyModal({Key? key, required this.onAddPharmacy})
      : super(key: key);

  @override
  _AddPharmacyModalState createState() => _AddPharmacyModalState();
}

class _AddPharmacyModalState extends State<AddPharmacyModal> {
  TextEditingController nomController = TextEditingController();
  TextEditingController quartierController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Ajouter une pharmacie'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: nomController,
              decoration: InputDecoration(labelText: 'Nom de la pharmacie'),
            ),
            TextField(
              controller: quartierController,
              decoration: InputDecoration(labelText: 'Quartier'),
            ),
            TextField(
              controller: latitudeController,
              decoration: InputDecoration(labelText: 'Latitude'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: longitudeController,
              decoration: InputDecoration(labelText: 'Longitude'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the modal
          },
          child: Text('Annuler'),
        ),
        TextButton(
          onPressed: () {
            // Create a new Pharmacie object with the entered values
            Pharmacie newPharmacie = Pharmacie(
                id:
                    '', // Set to an empty string or generate a unique identifier
                nom: nomController.text,
                quartier: quartierController.text,
                latitude: double.parse(latitudeController.text),
                longitude: double.parse(longitudeController.text),
                image:
                    'https://www.meudon.fr/wp-content/uploads/sites/5/2021/04/Pharmacie_Centrale.jpg');

            // Call the onAddPharmacy function to add the new pharmacy
            widget.onAddPharmacy(newPharmacie);

            // Close the modal
            Navigator.of(context).pop();
          },
          child: Text('Ajouter'),
        ),
      ],
    );
  }
}
