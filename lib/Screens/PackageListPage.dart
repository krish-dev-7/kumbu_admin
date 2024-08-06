import 'package:flutter/material.dart';
import '../Models/Package.dart';
import '../service/PackageService.dart';

class PackageListPage extends StatefulWidget {
  @override
  _PackageListPageState createState() => _PackageListPageState();
}

class _PackageListPageState extends State<PackageListPage> {
  final PackageService _packageService = PackageService();
  List<Package> _packages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPackages();
  }

  Future<void> _fetchPackages() async {
    try {
      List<Package> packages = await _packageService.getPackages();
      setState(() {
        _packages = packages;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching packages: $e')),
      );
    }
  }



  void _deletePackage(String packageID) async {
    try {
      await _packageService.deletePackage(packageID);
      setState(() {
        _packages.removeWhere((package) => package.packageID == packageID);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Package deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting package: $e')),
      );
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _isLoading = true;
    });

    try {
      setState(() {
        build(context);
        _fetchPackages();
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
        title:  Text('Packages'),
        actions: [
          IconButton(onPressed: _refresh, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _packages.length,
        itemBuilder: (context, index) {
          Package package = _packages[index];
          return ListTile(
            subtitle: Text(package.level),
            title: Text('${package.getReadableDuration()} - ₹${package.amount.toString()}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deletePackage(package.packageID??""),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
