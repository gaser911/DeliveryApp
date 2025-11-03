// lib/features/home/view/home_view.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/core/constants/app.colors.dart';
import 'package:food_app/core/router/app_router.dart';
import 'package:food_app/features/home/widget/card_item.dart';
import 'package:food_app/features/home/widget/header_view.dart';
import 'package:food_app/features/home/widget/profile_image_view.dart';
import 'package:gap/gap.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late TextEditingController controller;
  List<String> category = ["All", "Burger", "Hotdog", "Drink", "Donut"];
  int selectedCategoryIndex = 0;

  // Mock data for products - UPDATED with category and more items
  final List<Map<String, String>> products = [
    {
      'image': 'assets/images/item1.png',
      'name': 'Cheeseburger',
      'desc': 'Wendy\'s Burger',
      'rating': '4.5',
      'category': 'Burger', // Added category
    },
    {
      'image': 'assets/images/item1.png',
      'name': 'Hamburger',
      'desc': 'Classic Beef Burger',
      'rating': '4.7',
      'category': 'Burger', // Added category
    },
    {
      'image': 'assets/images/item1.png',
      'name': 'Veggie Burger',
      'desc': 'Healthy Choice',
      'rating': '4.3',
      'category': 'Burger', // Added category
    },
    {
      'image': 'assets/images/item1.png',
      'name': 'Bacon Burger',
      'desc': 'Extra Crispy',
      'rating': '4.8',
      'category': 'Burger', // Added category
    },
    // New items for other categories
    {
      'image': 'assets/images/bacon.png',
      'name': 'Premium Hotdog',
      'desc': 'Grilled Beef Hotdog',
      'rating': '4.2',
      'category': 'Hotdog',
    },
    {
      'image': 'assets/images/bacon.png',
      'name': 'Spicy Hotdog',
      'desc': 'Chili Cheese Hotdog',
      'rating': '4.4',
      'category': 'Hotdog',
    },
    {
      'image': 'assets/images/coleslaw.png',
      'name': 'Coca-Cola',
      'desc': 'Refreshing Soda',
      'rating': '4.6',
      'category': 'Drink',
    },
    {
      'image': 'assets/images/coleslaw.png',
      'name': 'Sprite Lemon-Lime',
      'desc': 'Zero Sugar Option',
      'rating': '4.1',
      'category': 'Drink',
    },
    {
      'image': 'assets/images/onionrings.png',
      'name': 'Chocolate Donut',
      'desc': 'Sweet Treat',
      'rating': '4.9',
      'category': 'Donut',
    },
    {
      'image': 'assets/images/onionrings.png',
      'name': 'Glazed Donut',
      'desc': 'Classic Glaze',
      'rating': '4.5',
      'category': 'Donut',
    },
  ];

  // NEW: Filtered products getter
  List<Map<String, String>> get filteredProducts {
    if (selectedCategoryIndex == 0) {
      return products; // 'All' category
    }
    final selectedCategory = category[selectedCategoryIndex];
    return products
        .where((product) => product['category'] == selectedCategory)
        .toList();
  }

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Sticky Header
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Row(
                  children: [
                    HeaderView(),
                    Spacer(),
                    ProfileImageView(),
                  ],
                ),
              ),

              // Scrollable Section
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    // Search Bar
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          shadowColor: Colors.grey,
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          elevation: 2,
                          child: TextField(
                            controller: controller,
                            cursorColor: Appcolors.primary,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                              hintText: "  Search...",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: Gap(20)),

                    // Category List
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: category.length,
                          itemBuilder: (context, index) {
                            final itemText = category[index];
                            final isSelected = selectedCategoryIndex == index;

                            return Padding(
                              padding: EdgeInsets.only(
                                left: index == 0 ? 15 : 0,
                                right: 10,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedCategoryIndex = index;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Appcolors.primary
                                        : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    itemText,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SliverToBoxAdapter(child: Gap(30)),

                    // Product Grid - UPDATED to use filteredProducts
                    SliverPadding(
                      padding: const EdgeInsets.only(
                          right: 15, left: 15, bottom: 20),
                      sliver: SliverGrid.builder(
                        itemCount: filteredProducts.length, // Use filteredProducts
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                          childAspectRatio: 0.7,
                        ),
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index]; // Use filteredProducts
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRouter.productDetails,
                                arguments: product,
                              );
                            },
                            child: CardItem(
                              image: product['image']!,
                              name: product['name']!,
                              desc: product['desc']!,
                              rating: product['rating']!,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}