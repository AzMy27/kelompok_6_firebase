import 'package:flutter/material.dart';
import 'package:tugas_kelompok/navigasi/home.dart';
import 'package:tugas_kelompok/navigasi/product.dart';
import 'package:tugas_kelompok/navigasi/profile.dart';

class fireStore extends StatefulWidget {
  const fireStore({super.key});

  @override
  State<fireStore> createState() => _fireStoreState();
}

class _fireStoreState extends State<fireStore> {
  final _pages = [
    const Beranda(),
    const Produk(),
    const Profil(),
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.blue,
        onTap: (index) {
          setState(
            () {
              _selectedIndex = index;
            },
          );
        },
      ),
      body: _pages[_selectedIndex],
    );
  }
}
