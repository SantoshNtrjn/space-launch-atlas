import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/launch_provider.dart';
import '../widgets/launch_card.dart';
import '../widgets/blue_gradient_button.dart';
import '../models/filters.dart';

class LaunchListScreen extends StatefulWidget {
  @override
  _LaunchListScreenState createState() => _LaunchListScreenState();
}

class _LaunchListScreenState extends State<LaunchListScreen> {
  bool _isInitialLoading = true;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<LaunchProvider>(context, listen: false);
    provider
        .fetchLaunches()
        .then((_) {
          setState(() => _isInitialLoading = false);
        })
        .catchError((e) {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: Text('Error'),
                  content: Text('Failed to load launches: $e'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'),
                    ),
                  ],
                ),
          );
          setState(() => _isInitialLoading = false);
        });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LaunchProvider>(context);
    final launches = provider.launches;

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF37474F), Color(0xFF000000)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Space Launch Atlas',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () async {
                        final newFilters = await Navigator.pushNamed(
                          context,
                          '/filter',
                        );
                        if (newFilters != null) {
                          provider.setFilters(newFilters as Filters);
                        }
                      },
                      child: Text(
                        'Filter',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: () => provider.fetchLaunches(reset: true),
                      child: Text(
                        'Refresh',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child:
                _isInitialLoading
                    ? Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF00FFFF),
                      ),
                    )
                    : launches.isEmpty && provider.currentFilters.showOnlyLiked
                    ? Center(
                      child: Text(
                        'You haven\'t liked any launches yet.',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                    : RefreshIndicator(
                      onRefresh: () => provider.fetchLaunches(reset: true),
                      child: ListView.builder(
                        itemCount: launches.length + 1,
                        itemBuilder: (context, index) {
                          if (index == launches.length) {
                            return provider.isLoading
                                ? Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF00FFFF),
                                    ),
                                  ),
                                )
                                : Padding(
                                  padding: EdgeInsets.all(16),
                                  child: BlueGradientButton(
                                    onPressed: () => provider.fetchLaunches(),
                                    text: 'Load More',
                                  ),
                                );
                          }
                          final launch = launches[index];
                          return LaunchCard(
                            launch: launch,
                            isLiked: provider.isLiked(launch.id),
                            toggleLike: () => provider.toggleLike(launch.id),
                          );
                        },
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
