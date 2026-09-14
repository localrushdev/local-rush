import 'package:flutter/material.dart';
import '../../../checkout/presentation/pages/checkout_page.dart';
import '../../../../core/cart/cart_service.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> menuItems;
  final Map<String, int> cart;

  const CartPage({super.key, required this.menuItems, required this.cart});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final cartService = CartService.instance;
  @override
  void initState() {
    super.initState();
    cartService.addListener(_refreshCart);
  }

  void _refreshCart() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    cartService.removeListener(_refreshCart);
    super.dispose();
  }

  int get subtotal => cartService.subtotal;

  int get deliveryFee => subtotal == 0 ? 0 : 40;

  double get gst => subtotal * 0.05;

  double get grandTotal => subtotal + deliveryFee + gst;

  int get total => grandTotal.round();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F4),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
              children: [
                // ================= APP BAR =================

                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),

                    const Expanded(
                      child: Text(
                        "Your Cart",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ================= RESTAURANT CARD =================
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          "assets/images/restaurant_hero.png",
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(width: 12),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Spice Garden",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),

                            SizedBox(height: 4),

                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Color(0xFFF97316),
                                  size: 16,
                                ),
                                SizedBox(width: 3),
                                Text("4.8"),

                                SizedBox(width: 8),

                                Icon(
                                  Icons.access_time,
                                  color: Color(0xFF6B7280),
                                  size: 16,
                                ),
                                SizedBox(width: 3),
                                Text("25 min"),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Free Delivery",
                          style: TextStyle(
                            color: Color(0xFF15803D),
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),
                // ================= CART ITEMS =================

                ...cartService.menuItems.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _cartItem(
                      image: item['image'] ?? "",
                      name: item['name'] ?? "",
                      price: item['price'] ?? 0,
                      qty: cartService.quantity(item['name']),
                      veg: item['is_veg'] ?? false,
                      onAdd: () {
                        cartService.add(item);
                        setState(() {});
                      },
                      onRemove: () {
                        cartService.remove(item['name']);
                        setState(() {});
                      },
                    ),
                  ),
                ),

                // ================= APPLY COUPON =================
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
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
                          Icons.local_offer_outlined,
                          color: Color(0xFFF97316),
                        ),
                      ),

                      const SizedBox(width: 14),

                      const Expanded(
                        child: Text(
                          "Apply Coupon",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      const Text(
                        "2 Offers",
                        style: TextStyle(
                          color: Color(0xFFF97316),
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(width: 4),

                      const Icon(Icons.chevron_right, color: Color(0xFF6B7280)),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // ================= BILL SUMMARY =================
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Bill Summary",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      _billRow("Subtotal", "₹${cartService.subtotal}"),

                      const SizedBox(height: 12),

                      _billRow(
                        "Delivery",
                        cartService.totalItems == 0 ? "₹0" : "FREE",
                        color: const Color(0xFF16A34A),
                      ),

                      const SizedBox(height: 12),

                      _billRow(
                        "GST",
                        "₹${(cartService.subtotal * 0.05).round()}",
                      ),

                      const Divider(height: 28),

                      _billRow(
                        "Total",
                        "₹${cartService.totalItems == 0 ? 0 : (cartService.subtotal + (cartService.subtotal * 0.05)).round()}",
                        bold: true,
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

            // ================= STICKY BUTTON =================
            // ================= STICKY BUTTON =================
            if (cartService.totalItems > 0)
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CheckoutPage()),
                    );
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
                            const Text(
                              "TO PAY",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "₹${cartService.totalItems == 0 ? 0 : (cartService.subtotal + (cartService.subtotal * 0.05)).round()}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        const Row(
                          children: [
                            Text(
                              "Proceed to Checkout",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(Icons.arrow_forward, color: Colors.white),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  // ================= CART ITEM =================

  Widget _cartItem({
    required String image,
    required String name,
    required int price,
    required int qty,
    required bool veg,
    required VoidCallback onAdd,
    required VoidCallback onRemove,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              _getMenuImage(image),
              width: 72,
              height: 72,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: veg
                              ? const Color(0xFF16A34A)
                              : const Color(0xFFDC2626),
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Center(
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: veg
                                ? const Color(0xFF16A34A)
                                : const Color(0xFFDC2626),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 6),

                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                qty == 1
                    ? Text(
                        "₹$price",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      )
                    : Row(
                        children: [
                          Text(
                            "₹$price",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "× $qty (₹${price * qty})",
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8F4),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: const Color(0xFFF3E8E1)),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onRemove,
                  child: const CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.remove,
                      size: 18,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ),

                SizedBox(
                  width: 28,
                  child: Text(
                    "$qty",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),

                GestureDetector(
                  onTap: onAdd,
                  child: const CircleAvatar(
                    radius: 15,
                    backgroundColor: Color(0xFFF97316),
                    child: Icon(Icons.add, size: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getMenuImage(String image) {
    if (image.startsWith("assets/")) {
      return image;
    }

    switch (image) {
      case "menu_biryani.png":
        return "assets/images/biryani.png";

      case "menu_butter_chicken.png":
        return "assets/images/butter_chicken.png";

      case "menu_garlic_naan.png":
        return "assets/images/naan.png";

      default:
        return "assets/images/biryani.png";
    }
  }

  // ================= BILL ROW =================

  Widget _billRow(
    String title,
    String value, {
    bool bold = false,
    Color color = const Color(0xFF1D1B19),
  }) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: bold ? 18 : 16,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
            color: bold ? const Color(0xFF1D1B19) : const Color(0xFF6B7280),
          ),
        ),

        const Spacer(),

        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 18 : 16,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}
