import 'package:flutter/material.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription Plans'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Choose a plan that suits you',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  buildPlanCard(
                    planName: 'Free',
                    price: 'Free',
                    description:
                        'Get basic access with limited features, perfect for personal use.',
                    buttonText: 'Select Free',
                    onTap: () {
                      // Handle free plan selection
                    },
                  ),
                  buildPlanCard(
                    planName: 'Monthly',
                    price: '\$9.99/month',
                    description:
                        'Enjoy premium features on a monthly subscription plan.',
                    buttonText: 'Select Monthly',
                    onTap: () {
                      // Handle monthly plan selection
                    },
                  ),
                  buildPlanCard(
                    planName: 'Yearly',
                    price: '\$99.99/year',
                    description:
                        'Best value! Get premium features with a yearly subscription.',
                    buttonText: 'Select Yearly',
                    onTap: () {
                      // Handle yearly plan selection
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPlanCard({
    required String planName,
    required String price,
    required String description,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              planName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              price,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onTap,
                child: Text(buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
