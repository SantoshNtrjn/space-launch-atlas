import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/launch.dart';
import 'gradient_button.dart';

class LaunchCard extends StatefulWidget {
  final Launch launch;
  final bool isLiked;
  final VoidCallback toggleLike;

  LaunchCard({required this.launch, required this.isLiked, required this.toggleLike});

  @override
  _LaunchCardState createState() => _LaunchCardState();
}

class _LaunchCardState extends State<LaunchCard> {
  String countdown = '';
  Timer? timer;

  @override
  void initState() {
    super.initState();
    updateCountdown();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      updateCountdown();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void updateCountdown() {
    final launchTime = DateTime.parse(widget.launch.net);
    final now = DateTime.now();
    final difference = launchTime.difference(now);
    if (difference.isNegative) {
      setState(() {
        countdown = 'Launched';
      });
    } else {
      final days = difference.inDays;
      final hours = difference.inHours % 24;
      final minutes = difference.inMinutes % 60;
      final seconds = difference.inSeconds % 60;
      setState(() {
        countdown = '$days:${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
      });
    }
  }

  Map<String, String> getSourceInfo() {
    final vidUrls = widget.launch.vidUrls ?? [];
    final infoUrls = widget.launch.infoUrls ?? [];
    final missionName = widget.launch.name;
    final agencyName = widget.launch.agencyName;

    if (vidUrls.isNotEmpty) {
      return {'url': vidUrls[0], 'label': 'Watch Live'};
    } else if (infoUrls.isNotEmpty) {
      return {'url': infoUrls[0], 'label': 'Read More'};
    } else {
      final searchQuery = Uri.encodeComponent('$missionName $agencyName mission details');
      return {'url': 'https://www.chatgpt.com/search?q=$searchQuery', 'label': 'Mission Info'};
    }
  }

  void handlePress() async {
    final sourceInfo = getSourceInfo();
    try {
      await launch(sourceInfo['url']!);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Could not open URL: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sourceInfo = getSourceInfo();
    final imageUrl = widget.launch.image ?? 'https://via.placeholder.com/150?text=No+Image';

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF424242), Color(0xFF212121)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey,
                  child: Center(child: Text('No Image')),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.launch.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    'Agency: ${widget.launch.agencyName}',
                    style: TextStyle(fontSize: 16, color: Color(0xFFCCCCCC)),
                  ),
                  SizedBox(height: 4), // Replaces marginTop: 4
                  Text(
                    'Countdown: $countdown',
                    style: TextStyle(fontSize: 18, color: Color(0xFF00FF00)),
                  ),
                  SizedBox(height: 8), // Replaces marginTop: 8
                  Text(
                    widget.launch.missionDescription ?? 'No mission details available.',
                    style: TextStyle(fontSize: 16, color: Color(0xFFAAAAAA)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GradientButton(onPressed: handlePress, text: sourceInfo['label']!),
                      IconButton(
                        icon: Icon(
                          widget.isLiked ? Icons.favorite : Icons.favorite_border,
                          color: widget.isLiked ? Colors.red : Colors.white,
                          size: 24,
                        ),
                        onPressed: widget.toggleLike,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}