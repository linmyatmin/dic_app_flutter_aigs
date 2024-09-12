class Subscription {
  int id;
  String plan;
  DateTime subscribedOn;
  DateTime expiredOn;

  Subscription({
    required this.id,
    required this.plan,
    required this.subscribedOn,
    required this.expiredOn,
  });
}
