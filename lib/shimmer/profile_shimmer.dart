import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileShimmer extends StatefulWidget {
  @override
  _ProfileShimmerState createState() => _ProfileShimmerState();
}

class _ProfileShimmerState extends State<ProfileShimmer> {
  Future<void> _loadData() async {
    // Simulate loading data
    await Future.delayed(const Duration(seconds: 200));
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.6),
      highlightColor: Colors.grey.withOpacity(0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Center(
            child: Container(
              width: 154, // Width + 2 * border width
              height: 154, // Height + 2 * border width
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 2, // Border width
                  color: Colors.grey.shade300,
                ),
              ),
              clipBehavior: Clip.antiAlias, // Ensure the border is rendered outside the circle
              child: const Icon(Icons.person_4_rounded, size: 130,),
            ),
          ),
          const SizedBox(height: 50,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "General Information",
                style: TextStyle(
                    fontSize: 19,
                    height: 1.38,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Roboto',
                    color: Theme.of(context).colorScheme.onPrimary
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.edit_note,
                  color: Colors.grey.shade300,
                  size: 32,
                ),
                onPressed: () {
                  // Handle button press event
                },
              ),
            ],
          ),
          WidgetCards(context, 10, 10, 0, 0, 'Name', ''),
          // SizedBox(height: 0.5,),
          WidgetCards(context, 0, 0, 0, 0, 'Current Plan', ''),
          // SizedBox(height: 0.5,),
          WidgetCards(context, 0, 0, 0, 0, 'User Group', ''),
          // SizedBox(height: 0.5,),
          WidgetCards(context, 0, 0, 0, 0, 'Date of Birth', ''),
          // SizedBox(height: 0.5,),
          WidgetCards(context, 0, 0, 0, 0, 'Age', ''),
          // SizedBox(height: 0.5,),
          WidgetCards(context, 0, 0, 0, 0, 'Martial Status', ''),
          // SizedBox(height: 0.5,),
          WidgetCards(context, 0, 0, 0, 0, 'Height', ''),
          // SizedBox(height: 0.5,),
          WidgetCards(context, 0, 0, 0, 0, 'Weight', ''),
          WidgetCards(context, 0, 0, 10, 10, 'Blood Group', ''),
          // SizedBox(height: 30,),
          // SizedBox(height: 30,),
          // Add more WidgetCards as needed for other user data
          const SizedBox(height: 30,),
          Text(
            "Contact Detail",
            style: TextStyle(
              fontSize: 19,
              height: 1.38,
              fontWeight: FontWeight.w700,
              fontFamily: 'Roboto',
              color: Colors.grey.shade300,
            ),
          ),
          const SizedBox(height: 10,),
          WidgetCards(context, 10, 10, 0, 0, 'Mobile Number', ''),
          const SizedBox(height: 0.5,),
          WidgetCards(context, 0, 0, 0, 0, 'State', ''),
          const SizedBox(height: 0.5,),
          WidgetCards(context, 0, 0, 0, 0, 'City', ''),
          const SizedBox(height: 0.5,),
          WidgetCards(context, 0, 0, 10, 10, 'Pin code', ''),
          const SizedBox(height: 30,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Settings",
                style: TextStyle(
                    fontSize: 19,
                    height: 1.38,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Roboto',
                    color: Colors.grey.shade300,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8,),

          settingsCardWidget(context,title: 'Report',trailing: const Icon(Icons.report_gmailerrorred),),
          settingsCardWidget(context,title: 'Terms and Condition', trailing: const Icon(Icons.notes_outlined),),
          settingsCardWidget(context,title: 'Share App', trailing: const Icon(Icons.share),),
          settingsCardWidget(context,title: 'Rate App', trailing: const Icon(Icons.star_rate_rounded),),
          settingsCardWidget(context,title: 'Rate App', trailing: const Icon(Icons.logout_outlined),),
          const SizedBox(height: 110,)
        ],
      ),
    );
  }

  Widget WidgetCards(BuildContext context, int topLeft, int topRight,
      int bottomLeft, int bottomRight, String firstItem, String secondItem) {
    return Card(
      elevation: 6,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        // height: 35,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(topRight.toDouble()),
            topLeft: Radius.circular(topLeft.toDouble()),
            bottomRight: Radius.circular(bottomRight.toDouble()),
            bottomLeft: Radius.circular(bottomLeft.toDouble()),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                firstItem,
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Roboto',
                  fontSize: 14,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                secondItem,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            // Add more child widgets as needed
          ],
        ),
      ),
    );
  }

  Widget settingsCardWidget(BuildContext context,
      {Widget? leading,
        required String title,
        String? trailingText,
        Widget? trailing,
        BorderRadiusGeometry borderRadius = const BorderRadius.all(Radius.circular(10)),
        VoidCallback? onTap}) {
    return Card(
      elevation: 5,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: borderRadius,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: leading ?? const SizedBox.shrink(),
                      ),
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.grey.shade300,
                          fontSize: 14,
                          fontFamily: 'Work Sans',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailingText != null)
                  Text(
                    trailingText,
                    style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                if (trailing != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox.square(
                      dimension: 24,
                      child: trailing!,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}