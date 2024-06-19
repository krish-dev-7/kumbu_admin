import 'package:flutter/material.dart';
import 'package:kumbu_admin/Common/ThemeData.dart';

import '../Common/GlobalFunctions.dart';
import '../Models/Member.dart';

class MembersListPage extends StatefulWidget {
  final List<GymMember> members;

  MembersListPage({required this.members});

  @override
  _MembersListPageState createState() => _MembersListPageState();
}

class _MembersListPageState extends State<MembersListPage> {
  late List<GymMember> sortedMembers;
  late Map<String, List<GymMember>> groupedMembers;

  final Map<String, GlobalKey> _keys = {};

  @override
  void initState() {
    super.initState();
    sortedMembers = sortMembersAlphabetically(widget.members);
    groupedMembers = groupMembersByAlphabet(sortedMembers);
  }

  Map<String, List<GymMember>> groupMembersByAlphabet(List<GymMember> members) {
    Map<String, List<GymMember>> grouped = {};
    for (var member in members) {
      String initial = member.name[0].toUpperCase();
      if (grouped[initial] == null) {
        grouped[initial] = [];
        _keys[initial] = GlobalKey();
      }
      grouped[initial]!.add(member);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Members List'),
      ),
      body: Row(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: groupedMembers.length,
              itemBuilder: (context, index) {
                String letter = groupedMembers.keys.elementAt(index);
                List<GymMember> members = groupedMembers[letter]!;
                return Column(
                  key: _keys[letter],
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...members.map((GymMember member) {
                      return ListTile(
                        title: Text(member.name),
                        subtitle: Text('ID: ${member.id}'),
                      );
                    }).toList(),
                  ],
                );
              },
            ),
          ),
          Container(
            width: 40,
            color: Colors.black,
            child: ListView(
              children: groupedMembers.keys.map((String letter) {
                return GestureDetector(
                  onTap: () {
                    final keyContext = _keys[letter]?.currentContext;
                    if (keyContext != null) {
                      Scrollable.ensureVisible(
                        keyContext,
                        duration: Duration(milliseconds: 500),
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(letter),
                  ),
                );
              }).toList(),
            ),
          ),

        ],
      ),
    );
  }
}
