import 'package:flutter/material.dart';

class FeatureCard extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String description;
  final Color backgroundColor;
  final Color iconBackgroundColor;

  const FeatureCard({
    Key? key,
    required this.imageAsset,
    required this.title,
    required this.description,
    required this.backgroundColor,
    required this.iconBackgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Image asset with background container
              Container(
                // padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(0.0),
                ),
                child: Image.asset(
                  imageAsset,
                  width: 32.0,
                  height: 32.0,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 16.0),
              // Title and description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 0.0),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
