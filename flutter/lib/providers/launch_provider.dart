import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/launch.dart';
import '../models/filters.dart';

class LaunchProvider with ChangeNotifier {
  List<Launch> _launches = [];
  Set<String> _likedLaunchIds = {};
  Filters _filters = Filters(agency: null, showOnlyLiked: false);
  int _offset = 0;
  bool isLoading = false;

  List<Launch> get launches {
    var filtered = _launches;
    if (_filters.agency != null) {
      filtered = filtered.where((launch) => launch.agencyName == _filters.agency).toList();
    }
    if (_filters.showOnlyLiked) {
      filtered = filtered.where((launch) => _likedLaunchIds.contains(launch.id)).toList();
    }
    return filtered;
  }

  List<String> get agencies {
    return _launches.map((launch) => launch.agencyName).toSet().toList();
  }

  Filters get currentFilters => _filters;

  bool isLiked(String launchId) => _likedLaunchIds.contains(launchId);

  LaunchProvider() {
    _loadLikedLaunches();
  }

  Future<void> fetchLaunches({bool reset = false}) async {
    if (isLoading) return;
    isLoading = true;
    notifyListeners();
    final currentOffset = reset ? 0 : _offset;
    const retries = 3;
    const delay = 2000;
    for (int attempt = 0; attempt < retries; attempt++) {
      try {
        final url = 'https://ll.thespacedevs.com/2.2.0/launch/upcoming/?limit=10&offset=$currentOffset';
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final results = (data['results'] as List?)?.map((json) => Launch.fromJson(json)).toList() ?? [];
          if (reset) {
            _launches = results;
            _offset = 10;
          } else {
            _launches.addAll(results);
            _offset += 10;
          }
          isLoading = false;
          notifyListeners();
          return;
        } else {
          throw Exception('Failed to load launches');
        }
      } catch (e) {
        if (attempt == retries - 1) {
          isLoading = false;
          notifyListeners();
          throw e;
        }
        await Future.delayed(Duration(milliseconds: delay));
      }
    }
  }

  void toggleLike(String launchId) {
    if (_likedLaunchIds.contains(launchId)) {
      _likedLaunchIds.remove(launchId);
    } else {
      _likedLaunchIds.add(launchId);
    }
    _saveLikedLaunches();
    notifyListeners();
  }

  void setFilters(Filters newFilters) {
    _filters = newFilters;
    notifyListeners();
  }

  Future<void> _loadLikedLaunches() async {
    final prefs = await SharedPreferences.getInstance();
    _likedLaunchIds = (prefs.getStringList('likedLaunches') ?? []).toSet();
    notifyListeners();
  }

  Future<void> _saveLikedLaunches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('likedLaunches', _likedLaunchIds.toList());
  }
}