import 'package:flutter/material.dart';

import '../Models/User.dart';
import '../service/UserService.dart';
 // Import your model here

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late Future<List<AppUser>> _users;

  @override
  void initState() {
    super.initState();
    _users = UserService().getAllUsers(); // Fetch users on init
  }

  void _refreshUserList() {
    setState(() {
      _users = UserService().getAllUsers();
    });
  }

  void _navigateToAddUserPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddUserPage()),
    );

    if (result == true) {
      _refreshUserList(); // Refresh user list if a new user was added
    }
  }

  void _deleteUser(String id) async {
    await UserService().deleteUser(id);
    _refreshUserList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: FutureBuilder<List<AppUser>>(
        future: _users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No users found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final user = snapshot.data![index];
              return ListTile(
                title: Text(user.name),
                subtitle: Text(user.email),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteUser(user.id),
                ),
                onTap: ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AddUserPage(user: user,))),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddUserPage,
        child: Icon(Icons.add),
        tooltip: 'Add User',
      ),
    );
  }
}


class AddUserPage extends StatefulWidget {
  final AppUser? user;

  AddUserPage({this.user});

  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String _role = 'Trainer';
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _nameController.text = widget.user!.name;
      _emailController.text = widget.user!.email;
      _role = widget.user!.role;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? 'Add User' : 'Edit User'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text('Trainer'),
                      leading: Radio<String>(
                        value: 'Trainer',
                        groupValue: _role,
                        onChanged: (value) {
                          setState(() {
                            _role = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text('Manager'),
                      leading: Radio<String>(
                        value: 'Manager',
                        groupValue: _role,
                        onChanged: (value) {
                          setState(() {
                            _role = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final user = AppUser(
                      id: widget.user?.id ?? '',
                      name: _nameController.text,
                      email: _emailController.text,
                      role: _role,
                      assignedMembers: widget.user?.assignedMembers ?? [],
                      membershipRequests: widget.user?.membershipRequests ?? [],
                    );

                    if (widget.user == null) {
                      await _userService.createUser(user);
                    } else {
                      await _userService.updateUser(widget.user!.id, user);
                    }

                    Navigator.of(context).pop(true);
                  }
                },
                child: Text(widget.user == null ? 'Add User' : 'Update User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


