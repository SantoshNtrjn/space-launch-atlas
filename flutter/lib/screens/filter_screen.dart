import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/launch_provider.dart';
import '../models/filters.dart';
import '../widgets/blue_gradient_button.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String? selectedAgency;
  bool showOnlyLiked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<LaunchProvider>(context, listen: false);
    selectedAgency = provider.currentFilters.agency;
    showOnlyLiked = provider.currentFilters.showOnlyLiked;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LaunchProvider>(context);
    final agencies = provider.agencies;

    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Launches'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Select Agency',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  ...agencies.map((agency) => Container(
                        margin: EdgeInsets.only(bottom: 8, left: 16, right: 16),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0xFF333333),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          title: Text(agency, style: TextStyle(color: Colors.white)),
                          trailing: selectedAgency == agency ? Icon(Icons.check, color: Colors.green) : null,
                          onTap: () {
                            setState(() {
                              selectedAgency = selectedAgency == agency ? null : agency;
                            });
                          },
                          contentPadding: EdgeInsets.zero,
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Show Only Liked Launches', style: TextStyle(color: Colors.white, fontSize: 16)),
                        Switch(
                          value: showOnlyLiked,
                          onChanged: (value) => setState(() => showOnlyLiked = value),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: BlueGradientButton(
              onPressed: () {
                final newFilters = Filters(agency: selectedAgency, showOnlyLiked: showOnlyLiked);
                Navigator.pop(context, newFilters);
              },
              text: 'Refine',
            ),
          ),
        ],
      ),
    );
  }
}