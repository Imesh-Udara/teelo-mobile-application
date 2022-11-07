import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:teelo_flutter/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchingContriller = TextEditingController();
  bool isShowtheUser = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchingContriller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: searchingContriller,
          decoration: const InputDecoration(
            labelText: 'Search for a user'),
          onFieldSubmitted: (String _) {
            setState(() {
              isShowtheUser = true;
            });
          },
        ),
      ),
      body: isShowtheUser
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where(
                    'username',
                    isGreaterThanOrEqualTo: searchingContriller.text,
                  )
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          (snapshot.data! as dynamic).docs[index]['imageUrl'],
                        ),
                      ),
                      title: Text(
                          (snapshot.data! as dynamic).docs[index]['username']),
                    );
                  },
                );
              },
            )
          : const Text('No data'),
    );
  }
}
