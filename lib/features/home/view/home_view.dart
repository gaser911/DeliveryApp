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
  // EXPANDED CATEGORY LIST
  List<String> category = ["All", "Burger", "Hotdog", "Drink", "Donut", "Sides", "Salad"];
  int selectedCategoryIndex = 0;
  String _searchQuery = ''; // NEW: State for search query

  // Mock data for products - EXPANDED with new categories
  final List<Map<String, String>> products = [
    {
      'image': 'assets/images/item1.png',
      'name': 'Cheeseburger Delight',
      'desc': 'Wendy\'s Best Burger',
      'rating': '4.5',
      'category': 'Burger', 
    },
    {
      'image': 'assets/images/item1.png',
      'name': 'Hamburger Classic',
      'desc': 'Classic Beef Patty',
      'rating': '4.7',
      'category': 'Burger', 
    },
    {
      'image': 'assets/images/item1.png',
      'name': 'Veggie Burger King',
      'desc': 'Healthy Choice',
      'rating': '4.3',
      'category': 'Burger', 
    },
    {
      'image': 'assets/images/item1.png',
      'name': 'Triple Baconator',
      'desc': 'Extra Crispy Bacon',
      'rating': '4.8',
      'category': 'Burger', 
    },
    // Hotdog
    {
      'image': 'assets/images/bacon.png',
      'name': 'Street Hotdog',
      'desc': 'Grilled Beef Hotdog',
      'rating': '4.2',
      'category': 'Hotdog',
    },
    {
      'image': 'assets/images/bacon.png',
      'name': 'Chili Cheese Dog',
      'desc': 'Spicy & Savory',
      'rating': '4.4',
      'category': 'Hotdog',
    },
    {
      'image': 'assets/images/bacon.png',
      'name': 'Corn Dog Classic',
      'desc': 'Golden Fried Batter',
      'rating': '4.1',
      'category': 'Hotdog',
    },
    // Drink
    {
      'image': 'assets/images/coleslaw.png',
      'name': 'Coca-Cola Zero',
      'desc': 'Refreshing Soda',
      'rating': '4.6',
      'category': 'Drink',
    },
    {
      'image': 'assets/images/coleslaw.png',
      'name': 'Orange Juice',
      'desc': 'Freshly Squeezed',
      'rating': '4.9',
      'category': 'Drink',
    },
    {
      'image': 'assets/images/coleslaw.png',
      'name': 'Lemonade Sparkle',
      'desc': 'Citrus Refreshment',
      'rating': '4.1',
      'category': 'Drink',
    },
    // Donut
    {
      'image': 'assets/images/onionrings.png',
      'name': 'Chocolate Glaze',
      'desc': 'Sweet Treat',
      'rating': '4.9',
      'category': 'Donut',
    },
    {
      'image': 'assets/images/onionrings.png',
      'name': 'Strawberry Jelly',
      'desc': 'Fruity Filling',
      'rating': '4.5',
      'category': 'Donut',
    },
    {
      'image': 'assets/images/onionrings.png',
      'name': 'Cinnamon Roll Donut',
      'desc': 'Warm Spices',
      'rating': '4.0',
      'category': 'Donut',
    },
    // Sides
    {
      'image': 'assets/images/fries.png',
      'name': 'Seasoned Fries',
      'desc': 'Crispy Potato',
      'rating': '4.6',
      'category': 'Sides',
    },
    {
      'image': 'assets/images/onionrings.png',
      'name': 'Golden Onion Rings',
      'desc': 'Crispy Onion',
      'rating': '4.7',
      'category': 'Sides',
    },
    {
      'image': 'assets/images/coleslaw.png',
      'name': 'Creamy Coleslaw',
      'desc': 'Classic Side',
      'rating': '4.5',
      'category': 'Sides',
    },
    // Salad
    {
      'image': 'assets/images/salad.png',
      'name': 'Garden Salad',
      'desc': 'Fresh Greens',
      'rating': '4.3',
      'category': 'Salad',
    },
    {
      'image': 'assets/images/salad.png',
      'name': 'Caesar Salad',
      'desc': 'Chicken Caesar',
      'rating': '4.4',
      'category': 'Salad',
    },
  ];

  // UPDATED: Filtered products getter now includes both Category and Search filtering.
  List<Map<String, String>> get filteredProducts {
    List<Map<String, String>> categoryFiltered;
    
    // 1. Filter by Category
    if (selectedCategoryIndex == 0 || selectedCategoryIndex >= category.length) {
      categoryFiltered = products; // 'All' category or invalid index returns all
    } else {
      final selectedCategory = category[selectedCategoryIndex];
      categoryFiltered = products
          .where((product) => product['category'] == selectedCategory)
          .toList();
    }

    // 2. Filter by Search Query
    if (_searchQuery.isEmpty) {
      return categoryFiltered;
    }

    final query = _searchQuery.toLowerCase().trim();

    return categoryFiltered
        .where((product) =>
            product['name']!.toLowerCase().contains(query) ||
            product['desc']!.toLowerCase().contains(query) ||
            product['category']!.toLowerCase().contains(query))
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
                    // Search Bar - ADDED onChanged for live filtering
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
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
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
                                    _searchQuery = ''; // Clear search when category changes
                                    controller.clear();
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

                    // Product Grid
                    SliverPadding(
                      padding: const EdgeInsets.only(
                          right: 15, left: 15, bottom: 20),
                      sliver: SliverGrid.builder(
                        itemCount: filteredProducts.length, // Uses filtered list
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                          childAspectRatio: 0.7,
                        ),
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index]; 
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