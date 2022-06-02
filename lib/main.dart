import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'addcontact.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

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

class HomePage extends StatefulWidget {
  late Contact? newContact;
  HomePage({this.newContact});

  @override
  State<HomePage> createState() => _HomePageState();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class _HomePageState extends State<HomePage> {
  List<Contact> _contacts = [];

  void getData() async {
    SharedPreferences s_prefs = await SharedPreferences.getInstance();
    setState(() {
      _contacts = Contact.decode(s_prefs.getString("contacts") ?? "");
    });
  }

  void addContact(Contact contact) {
    setState(() {
      _contacts.add(contact);
      saveData();
    });
  }

  void saveData() async {
    SharedPreferences s_prefs = await SharedPreferences.getInstance();
    s_prefs.setString("contacts", Contact.encode(_contacts));
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void makeCall(String number) async {
    Uri url = Uri.parse('tel:+48' + number);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      AlertDialog(
        title: Text("Coś poszło nie tak"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kontakty'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.elliptical(50, 50)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddContactPage(fn: addContact),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          size: 32,
                          Icons.account_circle,
                          color: Colors.blue,
                        ),
                        Text(
                          "Dodaj kontakt",
                          style: TextStyle(color: Colors.blue, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _contacts.length,
              itemBuilder: (BuildContext context, int i) {
                return ListTile(
                  leading: CircleAvatar(child: Text(_contacts[i].name[0])),
                  title: Text(_contacts[i].name + " " + _contacts[i].surname),
                  subtitle: Text(_contacts[i].phone),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        customBorder: CircleBorder(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.phone),
                        ),
                        onTap: () {
                          makeCall(_contacts[i].phone);
                        },
                      ),
                      InkWell(
                        customBorder: CircleBorder(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.more_vert),
                        ),
                        onTap: () {
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                height: 130,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          _contacts.removeAt(i);
                                          saveData();
                                          setState(() {});
                                          Navigator.pop(context);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.delete),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              "Usuń",
                                              style: TextStyle(fontSize: 24),
                                            )
                                          ],
                                        ),
                                      ),
                                      Divider(),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AddContactPage(
                                                      fn: addContact,
                                                      contact: _contacts[i]),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.settings),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              "Edytuj",
                                              style: TextStyle(fontSize: 24),
                                            )
                                          ],
                                        ),
                                      ),
                                      Divider(),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                          makeCall(_contacts[i].phone);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.phone),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              "Zadzwoń",
                                              style: TextStyle(fontSize: 24),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
            ),
          ],
        ),
      ),
    );
  }
}
