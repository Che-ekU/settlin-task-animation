import 'package:flutter/material.dart';
import 'package:flutter_application_1/check-out/provider/check_out.dart';
import 'package:flutter_application_1/settlin/models/order_details_schema.dart';
import 'package:provider/provider.dart';

class OrderDetailsCard extends StatelessWidget {
  const OrderDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    CheckOutProvider provider = context.read<CheckOutProvider>();
    OrderDetailsSchema order = provider.order;
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(
              5.0,
              5.0,
            ),
            blurRadius: 10.0,
            spreadRadius: 10.0,
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 18,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                const Text(
                  'Order details',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                ...order.items.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          e.name,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '\$${e.price}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 30,
            color: Colors.grey.shade300,
          ),
          _SummaryItem(
            heading: 'Subtotal',
            value: order.items
                .map((e) => e.price)
                .toList()
                .reduce((value, element) => value + element)
                .toStringAsFixed(2),
          ),
          _SummaryItem(
            heading: 'Shipping',
            value: order.shippingCharge.toStringAsFixed(2),
          ),
          _SummaryItem(
            heading: 'Tax',
            value: order.items
                .map((e) => e.tax)
                .toList()
                .reduce((value, element) => value + element)
                .toStringAsFixed(2),
          ),
          Divider(
            height: 36,
            color: Colors.grey.shade300,
          ),
          _SummaryItem(
            isBolder: true,
            heading: 'Total',
            value: (order.items
                        .map((e) => e.price + e.tax)
                        .toList()
                        .reduce((value, element) => value + element) +
                    order.shippingCharge)
                .toStringAsFixed(2),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.heading,
    required this.value,
    this.isBolder = false,
  });

  final String heading;
  final String value;
  final bool isBolder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Row(
        children: [
          const Spacer(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  heading,
                  style: TextStyle(
                    fontSize: isBolder ? 20 : 18,
                    fontWeight: isBolder ? FontWeight.w600 : FontWeight.w400,
                    color: isBolder ? Colors.black87 : Colors.black54,
                  ),
                ),
                Text(
                  '\$$value',
                  style: TextStyle(
                    fontSize: isBolder ? 20 : 18,
                    fontWeight: isBolder ? FontWeight.w600 : FontWeight.w400,
                    color: isBolder ? Colors.black87 : Colors.black54,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
