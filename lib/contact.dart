import 'dart:convert';

class Contact {
  final String name;
  final String surname;
  final String phone;
  Contact({required this.name, required this.surname, required this.phone});

  factory Contact.fromJson(Map<String, dynamic> jsonData) {
    return Contact(
      name: jsonData['name'],
      surname: jsonData['surname'],
      phone: jsonData['phone'],
    );
  }

  static Map<String, dynamic> toMap(Contact contact) => {
        'name': contact.name,
        'surname': contact.surname,
        'phone': contact.phone,
      };

  static String encode(List<Contact> musics) => json.encode(
        musics
            .map<Map<String, dynamic>>((music) => Contact.toMap(music))
            .toList(),
      );

  static List<Contact> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<Contact>((item) => Contact.fromJson(item))
          .toList();
}
