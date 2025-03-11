import 'package:dic_app_flutter/notifiers/subscription_notifier.dart';
import 'package:dic_app_flutter/providers/subscription_provider.dart';
import 'package:flutter/material.dart';
import '../models/subscription_plan_model.dart';
import 'package:dic_app_flutter/notifiers/auth_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch current subscription when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = ref.read(authProvider).user?.userId ?? '';
      ref.read(subscriptionProvider.notifier).getCurrentSubscription();
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final authState = ref.watch(authProvider);
    final plans = ref.watch(subscriptionPlansProvider);
    final subscriptionState = ref.watch(subscriptionProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Use subscription state's plan ID if available, otherwise fall back to auth state
    final int currentUserSubscriptionPlanId =
        subscriptionState.currentSubscription?.id ??
            authState.user?.subscriptionPlanId ??
            0;

    print('currentUserSubscriptionPlanId: ${currentUserSubscriptionPlanId}');

    Future<void> _handleSubscription(
        SubscriptionPlan plan, AuthState authState) async {
      if (plan.id == currentUserSubscriptionPlanId) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('You are already subscribed to this plan')),
        );
        return;
      }

      try {
        if (plan.price <= 0) {
          // Handle free plan
          await ref
              .read(subscriptionProvider.notifier)
              .createSubscription(plan);

          // Add this: Refresh the subscription state
          await ref
              .read(subscriptionProvider.notifier)
              .getCurrentSubscription();

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Free subscription activated successfully!')),
            );
          }
          return;
        }

        // Handle paid plan
        final response = await ref
            .read(subscriptionProvider.notifier)
            .changePlan(plan.id, authState.user!.userId);

        // Add this: Refresh the subscription state
        await ref.read(subscriptionProvider.notifier).getCurrentSubscription();

        // Show the API response message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message)),
          );
        }
      } catch (e) {
        print('Subscription error: $e');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }

    Widget _buildSubscriptionCard(SubscriptionPlan plan, bool isCurrentPlan) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final currentPlanColor = Colors.green.shade600;
      final subscriptionState = ref.watch(subscriptionProvider);
      final currentSubscription = subscriptionState.currentSubscription;
      final authState = ref.watch(authProvider);

      final bool hasActivePaidPlan =
          currentSubscription != null && currentSubscription.price > 0;

      String? expirationText;
      if (isCurrentPlan && authState.user?.endDate != null) {
        final endDate = authState.user!.endDate;
        expirationText =
            'Expires: ${endDate.toLocal().toString().split(' ')[0]}';
      }

      String buttonLabel;
      bool isButtonEnabled;
      if (isCurrentPlan) {
        buttonLabel = 'Current Plan';
        isButtonEnabled = false;
      } else if (hasActivePaidPlan) {
        buttonLabel = 'Changes after current plan ends';
        isButtonEnabled = false;
      } else {
        buttonLabel = 'Subscribe';
        isButtonEnabled = true;
      }

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: isCurrentPlan
              ? Border.all(color: currentPlanColor, width: 2)
              : Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.grey.shade300),
          color: isDark
              ? (isCurrentPlan
                  ? Colors.green.shade900
                  : Theme.of(context).cardColor)
              : (isCurrentPlan ? Colors.green.shade50 : Colors.white),
          boxShadow: isDark
              ? []
              : [
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
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.check_circle, color: Colors.white, size: 18),
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
                    if (expirationText != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          expirationText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
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
                          color: isDark
                              ? (isCurrentPlan
                                  ? Colors.green.shade400
                                  : Colors.white)
                              : (isCurrentPlan
                                  ? currentPlanColor
                                  : Colors.black),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? (isCurrentPlan
                                  ? currentPlanColor
                                  : Colors.white.withOpacity(0.1))
                              : (isCurrentPlan
                                  ? currentPlanColor
                                  : Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          plan.price > 0 ? '\$${plan.price}' : 'Free',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.white
                                : (isCurrentPlan
                                    ? Colors.white
                                    : Colors.black87),
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
                      color: isDark ? Colors.white70 : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isButtonEnabled
                          ? () =>
                              _handleSubscription(plan, ref.watch(authProvider))
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isButtonEnabled
                            ? Theme.of(context).primaryColor
                            : (isDark
                                ? Colors.white.withOpacity(0.1)
                                : Colors.grey.shade400),
                        foregroundColor: Colors.white,
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
                          else if (!isButtonEnabled && hasActivePaidPlan)
                            const Icon(Icons.lock_clock, size: 20)
                          else
                            const Icon(Icons.shopping_cart_outlined, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            buttonLabel,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (hasActivePaidPlan && !isCurrentPlan && plan.price > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Current paid plan must expire before switching to another paid plan',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white60 : Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
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
      backgroundColor:
          isDark ? Theme.of(context).primaryColorLight : Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Subscription Plans',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: plans.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Error: $error',
            style: TextStyle(
              color: isDark ? Colors.red.shade300 : Colors.red,
            ),
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
