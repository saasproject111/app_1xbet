import 'package:flutter/material.dart';
import '../models/subscription_plan.dart';

/// بطاقة عرض السعر بشكل احترافي
class PriceCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final bool showDetails;

  const PriceCard({
    super.key,
    required this.plan,
    this.showDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            plan.accentColor.withOpacity(0.3),
            plan.accentColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: plan.accentColor.withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: plan.accentColor.withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: plan.accentColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              plan.icon,
              size: 60,
              color: plan.accentColor,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            plan.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          if (showDetails) ...[
            const SizedBox(height: 12),
            Text(
              plan.description,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFFCBD5E1),
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                plan.price,
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.w900,
                  color: plan.accentColor,
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: plan.accentColor,
                      ),
                    ),
                    Text(
                      plan.duration,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
