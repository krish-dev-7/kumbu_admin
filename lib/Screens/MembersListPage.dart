import 'package:flutter/material.dart';
import 'package:kumbu_admin/Common/ThemeData.dart';
import 'package:kumbu_admin/Screens/AppDrawer.dart';
import '../Models/Member.dart'; // Update path as per your project structure
import '../service/MemberService.dart';
import 'AddMembersPage.dart';
import 'MembersDetailsPage.dart';

enum MemberFilter { all, active, inactive }

class MembersListPage extends StatefulWidget {
  @override
  _MembersListPageState createState() => _MembersListPageState();
}

class _MembersListPageState extends State<MembersListPage> {
  List<GymMember> _members = [];
  bool _isLoading = true;
  List<GymMember> filteredMembers = [];
  MemberFilter _selectedFilter = MemberFilter.all;
  String searchQuery = "";
  int currentPage = 1;
  int totalPages = 1;

  @override
  void initState() {
    super.initState();
    _fetchMembers();
  }

  void _updateFilteredMembers() {
    setState(() {
      filteredMembers = _members.where((member) {
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
    });
  }

  Future<void> _fetchMembers({int page = 1, String search = ''}) async {
    setState(() {
      _isLoading = true;
    });
    try {
      MemberService memberService = MemberService();
      final result = await memberService.getMembers(page: page, search: search);
      setState(() {
        _members = result.members;
        currentPage = result.currentPage;
        totalPages = result.totalPages;
        _isLoading = false;
      });
      _updateFilteredMembers();
    } catch (e) {
      print('Error fetching members: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _nextPage() {
    if (currentPage < totalPages) {
      _fetchMembers(page: currentPage + 1, search: searchQuery);
    }
  }

  void _previousPage() {
    if (currentPage > 1) {
      _fetchMembers(page: currentPage - 1, search: searchQuery);
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _isLoading = true;
    });

    try {
      setState(() {
        build(context);
        _fetchMembers();
        _isLoading = false;
        debugPrint("Refreshed");
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        debugPrint("Error");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Members List'),
        actions: [
          IconButton(onPressed: _refresh, icon: const Icon(Icons.refresh))
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await _refresh();
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Members: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: appLightGreen),
                            ),
                            const SizedBox(width: 10),
                            _buildRadioButton('All', MemberFilter.all),
                            const SizedBox(width: 10),
                            _buildRadioButton('Active', MemberFilter.active),
                            const SizedBox(width: 10),
                            _buildRadioButton(
                                'Inactive', MemberFilter.inactive),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Search by name or ID',
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: appLightGreen),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: appLightGreen),
                        ),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onSubmitted: (value) {
                        setState(() {
                          searchQuery = value;
                          _fetchMembers(search: searchQuery);
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            int crossAxisCount =
                                constraints.maxWidth > 600 ? 3 : 1;
                            return GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
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
                                        builder: (context) =>
                                            MemberDetailsPage(member: member),
                                      ),
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: appLightGreen, width: 1),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Row(
                                              children: [
                                                member.imageUrl == null
                                                    ? Icon(
                                                        Icons
                                                            .account_circle_sharp,
                                                        size: 60,
                                                        color: appLightGreen)
                                                    : CircleAvatar(
                                                        backgroundImage:
                                                            NetworkImage(member
                                                                .imageUrl!),
                                                        radius: 30,
                                                      ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Icon(Icons.person,
                                                              color:
                                                                  appLightGreen,
                                                              size: 16),
                                                          const SizedBox(
                                                              width: 8),
                                                          Text(
                                                            member.name,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                              Icons
                                                                  .card_membership,
                                                              color:
                                                                  appLightGreen,
                                                              size: 14),
                                                          const SizedBox(
                                                              width: 8),
                                                          Text(
                                                            'ID: ${member.gymMemberID}',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .white70,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                              Icons
                                                                  .calendar_today,
                                                              color:
                                                                  appLightGreen,
                                                              size: 14),
                                                          const SizedBox(
                                                              width: 8),
                                                          Text(
                                                            'Due: ${member.subscriptionDue}',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .white70,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                              Icons
                                                                  .fitness_center,
                                                              color:
                                                                  appLightGreen,
                                                              size: 14),
                                                          const SizedBox(
                                                              width: 8),
                                                          Text(
                                                            member.level
                                                                .toString()
                                                                .split('.')
                                                                .last,
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .white70,
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
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: member.isActive
                                            ? Icon(Icons.check_circle,
                                                color: appLightGreen)
                                            : Icon(Icons.cancel,
                                                color: Colors.red),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: _previousPage,
                          child: Text('Previous'),
                        ),
                        Text('Page $currentPage of $totalPages'),
                        ElevatedButton(
                          onPressed: _nextPage,
                          child: Text('Next'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddMemberPage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildRadioButton(String title, MemberFilter filter) {
    return Row(
      children: [
        Radio<MemberFilter>(
          value: filter,
          groupValue: _selectedFilter,
          onChanged: (MemberFilter? value) {
            setState(() {
              _selectedFilter = value!;
              _updateFilteredMembers();
            });
          },
          activeColor: appLightGreen,
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
