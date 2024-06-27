import 'package:flutter/material.dart';
import 'package:kumbu_admin/Common/ThemeData.dart';
import '../Models/Member.dart'; // Update path as per your project structure
import 'AddMembersPage.dart';
import 'MembersDetailsPage.dart';

enum MemberFilter { all, active, inactive }

class MembersListPage extends StatefulWidget {
  final List<GymMember> members;

  MembersListPage({required this.members});

  @override
  _MembersListPageState createState() => _MembersListPageState();
}

class _MembersListPageState extends State<MembersListPage> {
  List<GymMember> filteredMembers = [];
  MemberFilter _selectedFilter = MemberFilter.all;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _updateFilteredMembers();
  }

  void _updateFilteredMembers() {
    setState(() {
      filteredMembers = widget.members.where((member) {
        switch (_selectedFilter) {
          case MemberFilter.active:
            return member.isActive;
          case MemberFilter.inactive:
            return !member.isActive;
          case MemberFilter.all:
          default:
            return true;
        }
      }).toList();

      if (searchQuery.isNotEmpty) {
        filteredMembers = filteredMembers.where((member) {
          return member.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              member.id.toString().contains(searchQuery);
        }).toList();
      }

      sortMembersAlphabetically(filteredMembers);
      sortMembersByDueDate(filteredMembers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Members List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: appLightGreen, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Members: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10),
                    _buildRadioButton('All', MemberFilter.all),
                    const SizedBox(width: 10),
                    _buildRadioButton('Active', MemberFilter.active),
                    const SizedBox(width: 10),
                    _buildRadioButton('Inactive', MemberFilter.inactive),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search by name or ID',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  _updateFilteredMembers();
                });
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: appLightGreen, width: 1),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = constraints.maxWidth > 600 ? 3 : 1;
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 1.0,
                        mainAxisSpacing: 1.0,
                        childAspectRatio: 3,
                      ),
                      itemCount: filteredMembers.length,
                      itemBuilder: (context, index) {
                        GymMember member = filteredMembers[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MemberDetailsPage(member: member),
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: appLightGreen, width: 1),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        member.imageUrl == null
                                            ? Icon(Icons.account_circle_sharp, size: 60, color: appLightGreen)
                                            : CircleAvatar(
                                          backgroundImage: NetworkImage(member.imageUrl!),
                                          radius: 30,
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.person, color: appLightGreen, size: 16),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    member.name,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Icon(Icons.card_membership, color: appLightGreen, size: 14),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    'ID: ${member.id}',
                                                    style: TextStyle(
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Icon(Icons.calendar_today, color: appLightGreen, size: 14),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    'Due: ${member.subscriptionDue}',
                                                    style: TextStyle(
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Icon(Icons.access_time, color: appLightGreen, size: 14),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    '${member.membershipDuration}',
                                                    style: TextStyle(
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              if (!member.isActive)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.6),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Expired',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMemberPage()),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: appDarkGreen,
      ),
    );
  }

  Widget _buildRadioButton(String title, MemberFilter value) {
    return Row(
      children: [
        Radio<MemberFilter>(
          value: value,
          groupValue: _selectedFilter,
          onChanged: (MemberFilter? newValue) {
            setState(() {
              _selectedFilter = newValue!;
              _updateFilteredMembers();
            });
          },
          activeColor: appLightGreen,
        ),
        Text(title, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}

void sortMembersAlphabetically(List<GymMember> members) {
  members.sort((a, b) => a.name.compareTo(b.name));
}

void sortMembersByDueDate(List<GymMember> members) {
  members.sort((a, b) => a.membershipEndDate.compareTo(b.membershipEndDate));
}
