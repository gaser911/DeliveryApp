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

  // Mock data for products
  final List<Map<String, String>> products = [
    {
      'image': 'assets/images/item1.png',
      'name': 'Cheeseburger',
      'desc': 'Wendy\'s Burger',
      'rating': '4.5',
    },
    {
      'image': 'assets/images/item1.png',
      'name': 'Hamburger',
      'desc': 'Classic Beef Burger',
      'rating': '4.7',
    },
    {
      'image': 'assets/images/item1.png',
      'name': 'Veggie Burger',
      'desc': 'Healthy Choice',
      'rating': '4.3',
    },
    {
      'image': 'assets/images/item1.png',
      'name': 'Bacon Burger',
      'desc': 'Extra Crispy',
      'rating': '4.8',
    },
    {
      'image': 'assets/images/item1.png',
      'name': 'Double Burger',
      'desc': 'Double Patty',
      'rating': '4.6',
    },
    {
      'image': 'assets/images/item1.png',
      'name': 'Chicken Burger',
      'desc': 'Grilled Chicken',
      'rating': '4.4',
    },
  ];

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

                    // Product Grid
                    SliverPadding(
                      padding: const EdgeInsets.only(
                          right: 15, left: 15, bottom: 20),
                      sliver: SliverGrid.builder(
                        itemCount: products.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.67,
                        ),
                        itemBuilder: (context, index) {
                          final product = products[index];
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