import 'package:in_app_purchase/in_app_purchase.dart';
import '../models/subscription_plan_model.dart';
import '../network/api.dart';
import 'package:flutter/foundation.dart';

class IAPService {
  // Map your subscription plan IDs to store product IDs
  final Map<int, String> _planToProductId = {
    2: 'monthly_subscription_9_99', // Monthly plan
    3: 'yearly_subscription_99_99', // Yearly plan
  };

  List<ProductDetails> _products = [];
  List<SubscriptionPlan> _apiPlans = [];

  Future<void> initializeIAP() async {
    if (await InAppPurchase.instance.isAvailable()) {
      // Get subscription plans from your API
      _apiPlans = await API().getSubscriptionPlans();

      // Filter out free plans and create product IDs set
      final Set<String> productIds = _apiPlans
          .where((plan) => plan.price > 0) // Skip free plans
          .map((plan) => _planToProductId[plan.id] ?? '')
          .where((id) => id.isNotEmpty)
          .toSet();

      final ProductDetailsResponse response =
          await InAppPurchase.instance.queryProductDetails(productIds);

      if (response.notFoundIDs.isNotEmpty) {
        print('Products not found: ${response.notFoundIDs}');
      }

      _products = response.productDetails;
    }
  }

  Future<void> buySubscription(SubscriptionPlan plan) async {
    if (plan.price <= 0) {
      // Handle free subscription
      await _handleFreeSubscription(plan);
      return;
    }

    final String? productId = _planToProductId[plan.id];
    if (productId == null) {
      throw Exception('No matching store product for plan ID: ${plan.id}');
    }

    final ProductDetails? product = _products.firstWhere(
      (p) => p.id == productId,
      orElse: () =>
          throw Exception('Product not available in store: $productId'),
    );

    // final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);

    try {
      // await InAppPurchase.instance
      //     .buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      throw Exception('Failed to purchase: $e');
    }
  }

  Future<void> _handleFreeSubscription(SubscriptionPlan plan) async {
    try {
      // Call your API to create a free subscription
      // await API().createSubscription(
      //   planId: plan.id,
      //   startDate: DateTime.now(),
      //   endDate: DateTime.now().add(_calculateDuration(plan)),
      //   status: 'Active',
      //   price: 0.0,
      // );
    } catch (e) {
      throw Exception('Failed to create free subscription: $e');
    }
  }

  Duration _calculateDuration(SubscriptionPlan plan) {
    switch (plan.durationUnit.toString().toLowerCase()) {
      case 'days':
        return Duration(days: plan.duration);
      case 'months':
        return Duration(days: plan.duration * 30);
      case 'years':
        return Duration(days: plan.duration * 365);
      default:
        return Duration.zero;
    }
  }

  Future<bool> purchaseSubscription(String planId) async {
    try {
      // // Show Stripe payment UI first
      // final paymentResult = await _stripe.showPaymentSheet(
      //   planId: planId,
      //   // other necessary parameters
      // );

      // return paymentResult.status == PaymentStatus.succeeded;
      return true;
    } catch (e) {
      debugPrint('Payment failed: $e');
      return false;
    }
  }
}
