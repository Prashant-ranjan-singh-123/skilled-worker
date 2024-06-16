import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NotificationShimmer extends StatelessWidget {
  late bool isAppBar;

  NotificationShimmer({super.key, required this.isAppBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isAppBar
          ? AppBar(
              centerTitle: false,
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.background,
              foregroundColor: Theme.of(context).colorScheme.background,
              automaticallyImplyLeading: false,
              title: const Center(child: Text("Notification")),
              titleTextStyle: const TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            )
          : null, // Set app bar to null if isAppBar is false
      body: _buildShimmerEffect(),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.6),
      highlightColor: Colors.grey.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.only(top: 13, left: 50, right: 32),
        child: ListView.builder(
          itemCount: 200, // Adjust based on your content
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 42),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle, // Change to rectangle
                      borderRadius: BorderRadius.circular(8),
                      color:
                          Colors.white, // Add color to the rectangle container
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: 10,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 10,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.delete_outline,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
