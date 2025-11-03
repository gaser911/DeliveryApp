import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/core/constants/app.colors.dart';
import 'package:food_app/features/auth/view/profile_view.dart';
import 'package:food_app/features/cart/view/cart_view.dart';
import 'package:food_app/features/home/view/home_view.dart';
import 'package:food_app/features/order_history/view/order_history_view.dart';

class RootView extends StatefulWidget {
  const RootView({super.key});

  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  late List<Widget> pages; 
  int _selectedIndex = 0;
  late PageController _pageController;

  // NEW METHOD: Function to switch to a new page index
  void _selectPage(int index) {
    if (index >= 0 && index < pages.length) {
      setState(() {
        _selectedIndex = index;
        _pageController.jumpToPage(_selectedIndex);
      });
    }
  }

  @override
  void initState() {
    // 💡 FIX: Pass the switch function down to CartView (index 1) AND ProfileView (index 3)
    pages = [
      const HomeView(),
      CartView(onNavigateHome: () => _selectPage(0)), 
      const OrderHistoryView(),
      ProfileView(onNavigateHome: () => _selectPage(0)) // Pass the callback to ProfileView
    ];
    _pageController = PageController(initialPage: _selectedIndex);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the bottom bar should be visible.
    // Index 3 is the ProfileView.
    final bool isBottomBarVisible = _selectedIndex != 3;

    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
      
        controller: _pageController,
        onPageChanged: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        children: pages,
      ),
      // 💡 Conditionally set bottomNavigationBar
      bottomNavigationBar: isBottomBarVisible
          ? Container(
              padding: const  EdgeInsets.symmetric(horizontal:10, vertical: 10 ),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only( 
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                color: Appcolors.primary,
              ),
              child: BottomNavigationBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.grey.shade700,
                currentIndex: _selectedIndex,
                onTap: (index) {
                  _selectPage(index); 
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(
                      CupertinoIcons.home,
                    ),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.shopping_cart,
                      ),
                      label: "Cart",
                      backgroundColor: Colors.white),
                  BottomNavigationBarItem(
                    icon: Icon(
                    Icons.local_restaurant_sharp,
                    ),
                    label: "Orders history",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person,
                    ),
                    label: "Account",
                  ),
                ],
              ),
            )
          : null, // Return null to hide the bottom bar
    );
  }
}