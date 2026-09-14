import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedCategory = 0;
  int navIndex = 0;

  final categories = const [
    {"name": "Pizza", "icon": "🍕"},
    {"name": "Burger", "icon": "🍔"},
    {"name": "Biryani", "icon": "🍛"},
    {"name": "Momos", "icon": "🥟"},
    {"name": "Drinks", "icon": "🧋"},
    {"name": "Dessert", "icon": "🍰"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F4),

      bottomNavigationBar: _bottomBar(),

      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFFF97316),
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 700));
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 110),
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE8D8),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Color(0xFFF97316),
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 12),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Good Evening 👋",
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Shourya",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Stack(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.notifications_none),
                        ),
                        const Positioned(
                          right: 10,
                          top: 10,
                          child: CircleAvatar(
                            radius: 5,
                            backgroundColor: Color(0xFFF97316),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ADDRESS
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
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF1E8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Color(0xFFF97316),
                        ),
                      ),
                      const SizedBox(width: 12),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Deliver to",
                              style: TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "221B Baker Street, New Delhi",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),

                      const Icon(Icons.keyboard_arrow_down),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // SEARCH
                Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: Color(0xFF9CA3AF)),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search biryani, pizza, momos...",
                          ),
                        ),
                      ),
                      Icon(Icons.mic, color: Color(0xFFF97316)),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // HERO BANNER
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF97316), Color(0xFFFB923C)],
                    ),
                  ),
                  child: Stack(
                    children: [
                      const Positioned(
                        left: 20,
                        top: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "FLAT",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "50% OFF",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "on your first\n3 orders",
                              style: TextStyle(
                                color: Colors.white,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                        left: 20,
                        bottom: 18,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Text(
                            "Order Now",
                            style: TextStyle(
                              color: Color(0xFFF97316),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                      const Positioned(
                        right: 10,
                        bottom: 6,
                        child: Text("🍔🍟🥤", style: TextStyle(fontSize: 66)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 26),
                // CATEGORIES
                const Text(
                  "Categories",
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
                ),

                const SizedBox(height: 14),

                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final selected = selectedCategory == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = index;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFFF97316)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            children: [
                              Text(
                                categories[index]["icon"]!,
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                categories[index]["name"]!,
                                style: TextStyle(
                                  color: selected ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    const Text(
                      "Popular Near You",
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    TextButton(onPressed: () {}, child: const Text("See All")),
                  ],
                ),

                const SizedBox(height: 12),

                _restaurantCard(
                  emoji: "🍛",
                  name: "Spice Garden",
                  rating: "4.8",
                  time: "25 min",
                  offer: "Free Delivery",
                  price: "₹250 for two",
                ),

                const SizedBox(height: 18),

                _restaurantCard(
                  emoji: "🍕",
                  name: "Pizza Hub",
                  rating: "4.6",
                  time: "30 min",
                  offer: "20% OFF",
                  price: "₹199 for two",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _restaurantCard({
    required String emoji,
    required String name,
    required String rating,
    required String time,
    required String offer,
    required String price,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Container(
            height: 170,
            decoration: const BoxDecoration(
              color: Color(0xFFFFEDD5),
              borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 82)),
                ),
                const Positioned(
                  right: 12,
                  top: 12,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.favorite_border, size: 18),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      offer,
                      style: const TextStyle(
                        color: Color(0xFFF97316),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      rating,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "• $time",
                      style: const TextStyle(color: Color(0xFF6B7280)),
                    ),
                    const Spacer(),
                    Text(
                      price,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _nav(Icons.home_filled, 0),
            _nav(Icons.search, 1),
            _nav(Icons.receipt_long, 2),
            _nav(Icons.person_outline, 3),
          ],
        ),
      ),
    );
  }

  Widget _nav(IconData icon, int index) {
    final active = navIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() => navIndex = index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFFFF1E8) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Icon(
          icon,
          size: 28,
          color: active ? const Color(0xFFF97316) : const Color(0xFF9CA3AF),
        ),
      ),
    );
  }
}
