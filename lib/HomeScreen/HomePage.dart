import 'dart:math';
import 'package:efms/Utils/AppUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> dataList = [
    {"title": "Ashish mohan", "subtitle": "Android Developer"},
    {"title": "Ashish mohan", "subtitle": "Android Developer"},
    {"title": "Ashish mohan", "subtitle": "Android Developer"},
    {"title": "Ashish mohan", "subtitle": "Android Developer"},
    {"title": "Ashish mohan", "subtitle": "Android Developer"},
    {"title": "Suraj Kumar", "subtitle": "Python Developer"},
    {"title": "Suraj Kumar", "subtitle": "Python Developer"},
    {"title": "Suraj Kumar", "subtitle": "Python Developer"},
    {"title": "Suraj Kumar", "subtitle": "Python Developer"},
    {"title": "Suraj Kumar", "subtitle": "Python Developer"},
    {"title": "Surendra Kumar", "subtitle": "UI Developer"},
    {"title": "Surendra Kumar", "subtitle": "UI Developer"},
    {"title": "Surendra Kumar", "subtitle": "UI Developer"},
    {"title": "Surendra Kumar", "subtitle": "UI Developer"},
    {"title": "Surendra Kumar", "subtitle": "UI Developer"},
    {"title": "Vijay Kumar", "subtitle": "Frontend Developer"},
    {"title": "Vijay Kumar", "subtitle": "Frontend Developer"},
    {"title": "Vijay Kumar", "subtitle": "Frontend Developer"},
    {"title": "Vijay Kumar", "subtitle": "Frontend Developer"},
    {"title": "Vijay Kumar", "subtitle": "Frontend Developer"},];

  Future<void> _refrfeshData() async {
    // Simulate a delay for refreshing data (replace this with your data-fetching logic)
    await Future.delayed(Duration(seconds: 2));
    // Replace this logic with fetching updated data
    setState(() {
      // Sample updated data
      dataList.clear();
      dataList.addAll([
        {"title": "New Title 1", "subtitle": "New Subtitle 1"},
        {"title": "New Title 2", "subtitle": "New Subtitle 2"},
        // Add more updated data if needed
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RecyclerView Example'),
      ),
      body: ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          return CustomCard(
            title: dataList[index]["title"]!,
            subtitle: dataList[index]["subtitle"]!,
          );
        },
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String title;
  final String subtitle;

  CustomCard({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: Colors.grey.shade200,
      child: Container(
        width: 200.0,
        height: 250.0,
        child: ListTile(
          title: Row(
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 16, // Change the text size as needed
                  color: Colors.black, // Change the text color as needed
                ),
              ),
              SizedBox(width: 135), // Add some space between title and subtitle
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14, // Change the text size as needed
                  color: Colors.black, // Change the text color as needed
                ),
              ),
            ],
          ),
          onTap: () {
            AppUtils.showToastMessage(context, "$title $subtitle");
          },
        ),
      ),
    );
  }
}
