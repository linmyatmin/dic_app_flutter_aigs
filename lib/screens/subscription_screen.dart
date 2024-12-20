import 'package:dic_app_flutter/providers/subscription_provider.dart';
import 'package:flutter/material.dart';
import '../models/subscription_plan_model.dart';
import '../network/api.dart';
import 'package:dic_app_flutter/notifiers/auth_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/stripe_service.dart';

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor = Theme.of(context).primaryColor;
    final authState = ref.watch(authProvider);
    final plans = ref.watch(subscriptionPlansProvider);
    final int currentUserSubscriptionPlanId =
        authState.user?.subscriptionPlanId ?? 0;

    print('currentUserSubscriptionPlanId: ${currentUserSubscriptionPlanId}');

    Future<void> _handleSubscription(
        SubscriptionPlan plan, AuthState authState) async {
      print('_handleSubscription User ID: ${authState.user?.userId}');

      if (plan.id == currentUserSubscriptionPlanId) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You are already subscribed to this plan'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      try {
        // Check user ID
        if (authState.user?.userId == null) {
          throw Exception('User ID is null');
        }

        // Check if the plan is free
        if (plan.price <= 0) {
          // Directly update the backend for free plan subscription
          final api = API();
          final subscriptionData = await api.createUserSubscription(
            authState.user!.userId,
            plan.id,
            '', // No payment ID needed for free plans
          );

          print('subscriptionData: $subscriptionData');

          // Update the user state with the new subscription data
          await ref
              .read(authProvider.notifier)
              .updateUserSubscription(subscriptionData);

          // Refresh the subscription plans
          ref.refresh(subscriptionPlansProvider);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Free subscription activated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          return; // Exit the method after handling free plan
        }

        // Step 1: Create a payment intent for paid plans
        final paymentIntentData = await StripeService.createPaymentIntent(
          authState.user!.userId,
          plan.id,
        );

        // Validate payment intent data
        final clientSecret = paymentIntentData['clientSecret'];
        final paymentIntentId = paymentIntentData['paymentIntentId'];

        print('clientSecret: $clientSecret');
        print('paymentIntentId: $paymentIntentId');

        if (clientSecret == null || paymentIntentId == null) {
          throw Exception(
              'Payment intent data is incomplete: $paymentIntentData');
        }

        // Step 2: Confirm the payment
        await StripeService.confirmPayment(clientSecret);

        // Step 3: Handle successful subscription creation
        final api = API();
        final subscriptionData = await api.createUserSubscription(
          authState.user!.userId,
          plan.id,
          paymentIntentId.toString(),
        );

        // Update the user state with the new subscription data
        await ref
            .read(authProvider.notifier)
            .updateUserSubscription(subscriptionData);

        // Refresh the subscription plans
        ref.refresh(subscriptionPlansProvider);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Subscription activated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        // Handle payment failure
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Payment failed: $e'),
          backgroundColor: Colors.red,
        ));
      }

      // Show coming soon dialog
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return AlertDialog(
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(16),
      //       ),
      //       title: const Row(
      //         children: [
      //           Icon(Icons.access_time, color: Colors.blue),
      //           SizedBox(width: 8),
      //           Text('Coming Soon!'),
      //         ],
      //       ),
      //       content: const Text(
      //         'Online payment will be available soon. Please stay tuned!',
      //         style: TextStyle(fontSize: 16),
      //       ),
      //       actions: [
      //         TextButton(
      //           onPressed: () => Navigator.of(context).pop(),
      //           child: const Text('OK'),
      //         ),
      //       ],
      //     );
      //   },
      // );
    }

    Widget _buildSubscriptionCard(SubscriptionPlan plan, bool isCurrentPlan) {
      // Define colors
      final currentPlanColor = Colors.green.shade600;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: isCurrentPlan
              ? Border.all(color: currentPlanColor, width: 2)
              : Border.all(color: Colors.grey.shade300),
          color: isCurrentPlan ? Colors.green.shade50 : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            if (isCurrentPlan)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: currentPlanColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Current Plan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        plan.name ?? '',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color:
                              isCurrentPlan ? currentPlanColor : Colors.black,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isCurrentPlan
                              ? currentPlanColor
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          plan.price > 0 ? '\$${plan.price}' : 'Free',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color:
                                isCurrentPlan ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    plan.description ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isCurrentPlan
                          ? null
                          : () => _handleSubscription(
                              plan, ref.watch(authProvider)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isCurrentPlan ? Colors.grey.shade400 : primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isCurrentPlan)
                            const Icon(Icons.check, size: 20)
                          else
                            const Icon(Icons.shopping_cart_outlined, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            isCurrentPlan ? 'Current Plan' : 'Subscribe',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Subscription Plans',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: plans.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
        data: (plansList) => ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: plansList.length,
          itemBuilder: (context, index) {
            final plan = plansList[index];
            final isCurrentPlan = plan.id == currentUserSubscriptionPlanId;
            return _buildSubscriptionCard(plan, isCurrentPlan);
          },
        ),
      ),
    );
  }
}
