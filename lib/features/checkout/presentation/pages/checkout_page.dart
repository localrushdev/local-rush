import 'package:flutter/material.dart';
import '../../../success/presentation/pages/payment_success_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/cart/cart_service.dart';
import '../../../orders/presentation/pages/orders_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final supabase = Supabase.instance.client;

  Map<String, dynamic>? address;
  bool isLoading = true;
  int payment = 0;
  bool placingOrder = false; // 0=UPI,1=Card,2=COD
  final cartService = CartService.instance;

  @override
  void initState() {
    super.initState();
    loadAddress();
  }

  Future<void> placeOrder() async {
    if (placingOrder) return;
    setState(() => placingOrder = true);
    try {
      if (address == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Address not found")));
        return;
      }

      if (cartService.totalItems == 0) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Cart is empty")));
        return;
      }

      final subtotal = cartService.subtotal;
      final gst = (subtotal * 0.05).round();
      final total = (subtotal + gst - 50).clamp(0, 999999);

      final order = await supabase
          .from('orders')
          .insert({
            'user_id': null,

            // Spice Garden restaurant id
            'restaurant_id': '792f220b-8add-4ed3-91a9-212fdef6865e',

            'total_amount': total,

            'delivery_address':
                "${address!['house_no']}, ${address!['area']}, ${address!['city']}",

            'payment_method': payment == 0
                ? 'UPI'
                : payment == 1
                ? 'CARD'
                : 'COD',

            'status': 'Placed',
          })
          .select()
          .single();

      for (final item in cartService.menuItems) {
        await supabase.from('order_items').insert({
          'order_id': order['id'],
          'item_name': item['name'],
          'quantity': cartService.quantity(item['name']),
          'price': item['price'],
        });
      }

      cartService.clear();

      // 2 second loading animation
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const OrdersPage()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
      debugPrint(e.toString());
    } finally {
      if (mounted) {
        setState(() => placingOrder = false);
      }
    }
  }

  Future<void> loadAddress() async {
    final data = await supabase
        .from('addresses')
        .select()
        .eq('is_default', true)
        .single();

    setState(() {
      address = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    /*if (cartService.totalItems == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.pop(context);
      });
    }*/
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F4),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 140),
              children: [
                // TOP BAR
                SizedBox(
                  height: 60,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: placingOrder
                            ? null
                            : () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            "Checkout",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.more_vert),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ADDRESS CARD
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.location_on,
                            color: Color(0xFFF97316),
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "DELIVER TO",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF8C7164),
                            ),
                          ),
                          Spacer(),
                          Text(
                            "EDIT",
                            style: TextStyle(
                              color: Color(0xFFF97316),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        isLoading
                            ? "Loading..."
                            : (address?['full_name'] ?? "No Name"),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isLoading
                            ? "Fetching address..."
                            : "${address?['house_no']}, ${address?['area']}, ${address?['city']}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.call,
                            size: 16,
                            color: Color(0xFF9CA3AF),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isLoading ? "" : "+91 ${address?['phone']}",
                            style: const TextStyle(color: Color(0xFF6B7280)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // DELIVERY NOTE
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFF1E8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit_note,
                          color: Color(0xFFF97316),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Text(
                          "Add delivery instructions",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // PAYMENT
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.account_balance_wallet,
                            color: Color(0xFFF97316),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Payment Method",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      _paymentTile(
                        index: 0,
                        title: "UPI",
                        subtitle: "Google Pay, PhonePe, Paytm",
                        icon: Icons.account_balance_wallet,
                      ),
                      const SizedBox(height: 12),
                      _paymentTile(
                        index: 1,
                        title: "Credit / Debit Card",
                        subtitle: "",
                        icon: Icons.credit_card,
                      ),
                      const SizedBox(height: 12),
                      _paymentTile(
                        index: 2,
                        title: "Cash on Delivery",
                        subtitle: "",
                        icon: Icons.payments_outlined,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // SUCCESS COUPON
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F8EC),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: const BoxDecoration(
                          color: Color(0xFF16A34A),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check, color: Colors.white),
                      ),
                      const SizedBox(width: 14),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "SAVE50 applied successfully",
                              style: TextStyle(
                                color: Color(0xFF15803D),
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "You unlocked ₹50 savings on this order",
                              style: TextStyle(
                                color: Color(0xFF16A34A),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD7F5DF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "-₹50",
                          style: TextStyle(
                            color: Color(0xFF15803D),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // ORDER SUMMARY
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              "assets/images/cart_restaurant.png",
                              width: 54,
                              height: 54,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Spice Garden",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  "Order Items (${cartService.totalItems})",
                                  style: const TextStyle(
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE7F8EF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "Verified",
                              style: TextStyle(
                                color: Color(0xFF15803D),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Divider(height: 28),

                      ...cartService.menuItems.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _orderItem(
                            item['is_veg'],
                            item['name'],
                            "×${cartService.quantity(item['name'])}",
                            "₹${item['price'] * cartService.quantity(item['name'])}",
                          ),
                        ),
                      ),

                      const Divider(height: 28),

                      _bill("Subtotal", "₹${cartService.subtotal}"),
                      const SizedBox(height: 8),

                      _bill(
                        "Delivery",
                        "FREE",
                        valueColor: const Color(0xFF16A34A),
                      ),
                      const SizedBox(height: 8),

                      _bill(
                        "GST & Restaurant Taxes",
                        "₹${(cartService.subtotal * 0.05).round()}",
                      ),
                      const SizedBox(height: 8),

                      _bill(
                        "Coupon Discount (SAVE50)",
                        "-₹50",
                        titleColor: const Color(0xFF16A34A),
                        valueColor: const Color(0xFF16A34A),
                      ),

                      const Divider(height: 26),

                      _bill(
                        "Total Payable",
                        "₹${((cartService.subtotal + (cartService.subtotal * 0.05) - 50).clamp(0, 999999)).round()}",
                        bold: true,
                      ),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Inclusive of all taxes",
                          style: TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.verified_user,
                      color: Color(0xFF16A34A),
                      size: 18,
                    ),
                    SizedBox(width: 6),
                    Text(
                      "Safe and contactless delivery guaranteed",
                      style: TextStyle(color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ],
            ),
            // ================= PLACE ORDER =================

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: GestureDetector(
                    onTap: placingOrder
                        ? null
                        : () async {
                            await placeOrder();
                          },
                    child: Container(
                      height: 64,
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF97316),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "₹${((cartService.subtotal + (cartService.subtotal * 0.05) - 50).clamp(0, 999999)).round()}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const Text(
                                "After discount",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),

                          const Spacer(),

                          Text(
                            placingOrder ? "Placing..." : "Place Order",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          const SizedBox(width: 8),

                          placingOrder
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (placingOrder)
              Positioned.fill(
                child: AbsorbPointer(
                  child: Container(
                    color: Colors.black54,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(height: 16),
                          Text(
                            "Placing your order...",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ================= PAYMENT TILE =================

  Widget _paymentTile({
    required int index,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final selected = payment == index;

    return GestureDetector(
      onTap: () => setState(() => payment = index),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? const Color(0xFFF97316) : const Color(0xFFE5E7EB),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xFFFFF1E8),
              child: Icon(icon, color: const Color(0xFFF97316)),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 13,
                      ),
                    ),
                ],
              ),
            ),

            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected
                  ? const Color(0xFFF97316)
                  : const Color(0xFFD1D5DB),
            ),
          ],
        ),
      ),
    );
  }

  // ================= ORDER ITEM =================

  Widget _orderItem(bool veg, String name, String qty, String price) {
    return Row(
      children: [
        Icon(
          veg ? Icons.square : Icons.crop_square,
          color: veg ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
          size: 18,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text("$name $qty", style: const TextStyle(fontSize: 15)),
        ),
        Text(price, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    );
  }

  // ================= BILL ROW =================

  Widget _bill(
    String title,
    String value, {
    bool bold = false,
    Color titleColor = const Color(0xFF6B7280),
    Color valueColor = const Color(0xFF1D1B19),
  }) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: bold ? Colors.black : titleColor,
            fontSize: bold ? 18 : 15,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: bold ? 18 : 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
