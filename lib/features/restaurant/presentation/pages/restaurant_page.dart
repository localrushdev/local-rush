import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/cart/cart_service.dart';
import '../../../cart/presentation/pages/cart_page.dart';

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({super.key});

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  final cartService = CartService.instance;
  final supabase = Supabase.instance.client;

  bool isLoading = true;
  int selectedCategory = 0;

  List<Map<String, dynamic>> menuItems = [];

  final categories = ["Recommended", "Biryani", "Curry", "Drinks"];

  @override
  void initState() {
    super.initState();
    loadMenu();
    cartService.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    cartService.removeListener(_refresh);
    super.dispose();
  }

  Future<void> loadMenu() async {
    try {
      final restaurant = await supabase
          .from('restaurants')
          .select('id')
          .eq('name', 'Spice Garden')
          .single();

      final data = await supabase
          .from('menu_items')
          .select()
          .eq('restaurant_id', restaurant['id']);

      setState(() {
        menuItems = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } catch (_) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F4),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.only(bottom: 110),
              children: [
                _heroBanner(),
                _restaurantInfo(),
                const Divider(
                  height: 1,
                  color: Color(0xFFE7E5E4),
                  indent: 20,
                  endIndent: 20,
                ),
                _categoryTabs(),
                const SizedBox(height: 8),
                _menuList(),
                const SizedBox(height: 20),
              ],
            ),

            if (cartService.totalItems > 0) _floatingCart(),
          ],
        ),
      ),
    );
  }

  // ---------------- HERO ----------------

  Widget _heroBanner() {
    return SizedBox(
      height: 220,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/images/spice_garden.png", fit: BoxFit.cover),

          Container(color: Colors.black.withOpacity(.15)),

          Positioned(
            top: 14,
            left: 16,
            child: _circleButton(
              Icons.arrow_back,
              () => Navigator.pop(context),
            ),
          ),

          Positioned(
            top: 14,
            right: 16,
            child: Row(
              children: [
                _circleButton(Icons.favorite_border, () {}),
                const SizedBox(width: 10),
                _circleButton(Icons.share, () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 42,
        height: 42,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Color(0xFF1D1B19)),
      ),
    );
  }

  // ---------------- INFO ----------------

  Widget _restaurantInfo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  "Spice Garden",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1D1B19),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF97316),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  "OPEN",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .5,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              const Icon(Icons.star, color: Color(0xFFF97316), size: 18),
              const SizedBox(width: 4),
              const Text("4.8", style: TextStyle(fontWeight: FontWeight.w700)),

              const SizedBox(width: 12),
              const Text("|", style: TextStyle(color: Colors.grey)),

              const SizedBox(width: 12),
              const Icon(Icons.schedule, color: Colors.grey, size: 18),
              const SizedBox(width: 4),
              const Text("25 min"),

              const SizedBox(width: 12),
              const Text("|", style: TextStyle(color: Colors.grey)),

              const SizedBox(width: 12),
              const Icon(
                Icons.local_shipping,
                color: Color(0xFF16A34A),
                size: 18,
              ),
              const SizedBox(width: 4),
              const Text(
                "Free Delivery",
                style: TextStyle(
                  color: Color(0xFF16A34A),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          const Text(
            "North Indian • Biryani • Mughlai",
            style: TextStyle(
              color: Color(0xFF57534E),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 6),

          Row(
            children: const [
              Text(
                "₹250 for two",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              SizedBox(width: 8),
              Text("•", style: TextStyle(color: Colors.grey)),
              SizedBox(width: 8),
              Text(
                "Pure Spices & Dum Cooked",
                style: TextStyle(color: Color(0xFF78716C), fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- CATEGORY ----------------

  Widget _categoryTabs() {
    return SizedBox(
      height: 54,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final selected = selectedCategory == index;

          return GestureDetector(
            onTap: () => setState(() => selectedCategory = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: selected ? const Color(0xFFF97316) : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: selected
                      ? const Color(0xFFF97316)
                      : const Color(0xFFE7E5E4),
                ),
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: TextStyle(
                    color: selected ? Colors.white : const Color(0xFF292524),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  // ---------------- MENU LIST ----------------

  Widget _menuList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _menuCard(
            tag: "BESTSELLER",
            veg: false,
            name: "Hyderabadi Biryani",
            desc: "Long grain basmati rice with saffron and chicken.",
            price: 320,
            image: "assets/images/biryani.jpg",
          ),

          const SizedBox(height: 14),

          _menuCard(
            tag: "Chef Special",
            veg: false,
            name: "Butter Chicken",
            desc: "Creamy tomato gravy with tender chicken.",
            price: 280,
            image: "assets/images/butter_chicken.jpg",
          ),

          const SizedBox(height: 14),

          _menuCard(
            tag: "Tandoori Bread",
            veg: true,
            name: "Garlic Naan",
            desc: "Soft tandoor naan with garlic butter.",
            price: 60,
            image: "assets/images/naan.jpg",
          ),
        ],
      ),
    );
  }

  // ---------------- MENU CARD ----------------

  Widget _menuCard({
    required bool veg,
    required String tag,
    required String name,
    required String desc,
    required int price,
    required String image,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 18,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // LEFT SIDE
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
                    Text(
                      tag,
                      style: TextStyle(
                        color: tag == "BESTSELLER"
                            ? const Color(0xFFF97316)
                            : const Color(0xFF78716C),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1D1B19),
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  desc,
                  style: const TextStyle(
                    color: Color(0xFF78716C),
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  "₹$price",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1D1B19),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // RIGHT IMAGE
          SizedBox(
            width: 110,
            height: 105,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    image,
                    width: 110,
                    height: 105,
                    fit: BoxFit.cover,
                  ),
                ),

                Positioned(
                  bottom: -8,
                  child: InkWell(
                    onTap: () {
                      cartService.add({
                        "name": name,
                        "price": price,
                        "is_veg": veg,
                        "image": image,
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("$name added"),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      width: 74,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: const Color(0xFFFFE2CF)),
                        boxShadow: const [
                          BoxShadow(color: Color(0x14000000), blurRadius: 6),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "ADD +",
                          style: TextStyle(
                            color: Color(0xFFF97316),
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ),
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
  // ---------------- FLOATING CART ----------------

  Widget _floatingCart() {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 16,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CartPage(
                menuItems: cartService.menuItems,
                cart: Map<String, int>.fromEntries(
                  cartService.menuItems.map(
                    (item) => MapEntry(
                      item['name'] as String,
                      cartService.quantity(item['name']),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 22),
          decoration: BoxDecoration(
            color: const Color(0xFFF97316),
            borderRadius: BorderRadius.circular(32),
            boxShadow: const [
              BoxShadow(
                color: Color(0x40F97316),
                blurRadius: 22,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${cartService.totalItems} Items",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              Text(
                "₹${cartService.subtotal}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const Spacer(),

              Row(
                children: const [
                  Text(
                    "View Cart",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
