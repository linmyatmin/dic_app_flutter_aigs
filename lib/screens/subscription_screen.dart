import 'package:dic_app_flutter/providers/subscription_provider.dart';
import 'package:flutter/material.dart';
import '../models/subscription_plan_model.dart';
import '../network/api.dart';
import 'package:dic_app_flutter/notifiers/auth_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:dic_app_flutter/screens/login_screen.dart';

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor = Theme.of(context).primaryColor;
    final authState = ref.watch(authProvider);
    print('Auth State: ${authState.isAuthenticated}');
    print('User: ${authState.user}');
    final plans = ref.watch(subscriptionPlansProvider);
    final int currentUserSubscriptionPlanId =
        authState.user?.subscriptionPlanId ?? 0;

    Future<void> _handleSubscription(
        SubscriptionPlan plan, AuthState authState) async {
      if (plan.id == currentUserSubscriptionPlanId) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You are already subscribed to this plan'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      if (!authState.isAuthenticated) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
        return;
      }

      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );

        final subscriptionService = ref.read(subscriptionServiceProvider);

        final startDate = DateTime.now();
        final endDate = subscriptionService.calculateEndDate(plan, startDate);

        print('startDate: $startDate, endDate: $endDate');
// ... existing code ...
        print(
            'Subscription Details: {userId: ${authState.user!.userId}, planId: ${plan.id}, startDate: $startDate, endDate: $endDate, price: ${plan.price}}');
// ... existing code ...
        await subscriptionService.createUserSubscription(
          userId: authState.user!.userId,
          planId: plan.id,
          startDate: startDate,
          endDate: endDate,
          price: plan.price,
        );

        // Close loading dialog
        Navigator.pop(context);

        // Refresh auth state to get updated subscription
        ref.refresh(authProvider);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully subscribed to ${plan.name} plan!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        // Close loading dialog
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Subscription Plans',
          style: TextStyle(color: Colors.white),
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.edit),
        //     onPressed: () {
        //       // TODO: Implement edit profile functionality
        //     },
        //   ),
        // ],
      ),
      body: plans.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (plansList) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: plansList.length,
          itemBuilder: (context, index) {
            final plan = plansList[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              color: plan.id == currentUserSubscriptionPlanId
                  ? primaryColor.withOpacity(0.1)
                  : null,
              child: ListTile(
                title: Text(plan.name ?? ''),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(plan.description ?? ''),
                    if (plan.id == currentUserSubscriptionPlanId)
                      const Text(
                        'Current Plan',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                trailing: Text(
                  plan.price > 0 ? '\$${plan.price}' : 'Free',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () => _handleSubscription(plan, ref.watch(authProvider)),
              ),
            );
          },
        ),
      ),
    );
  }
}
