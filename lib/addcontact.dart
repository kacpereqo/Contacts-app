import 'package:flutter/material.dart';
import 'package:phone_number/main.dart';

class AddContactPage extends StatelessWidget {
  final Contact? contact;
  final ValueChanged<Contact> fn;
  const AddContactPage({required this.fn, this.contact});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController =
        new TextEditingController(text: contact?.name ?? '');
    TextEditingController surnameController =
        new TextEditingController(text: contact?.surname ?? '');
    TextEditingController numberController =
        new TextEditingController(text: contact?.phone ?? '');

    return Scaffold(
      appBar: AppBar(
        title: Text("Dodaj nowy kontakt"),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 5, 32, 5),
          child: TextField(
            controller: nameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Imię",
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 5, 32, 5),
          child: TextField(
            controller: surnameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Nazwisko",
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 5, 32, 10),
          child: TextField(
            controller: numberController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Numer telefonu",
            ),
          ),
        ),
        ElevatedButton(
          child: Text("Dodaj"),
          onPressed: () {
            Navigator.pop(context);

            fn(
              Contact(
                name: nameController.text,
                surname: surnameController.text,
                phone: numberController.text,
              ),
            );
          },
        ),
      ]),
    );
  }
}
