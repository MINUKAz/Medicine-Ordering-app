import 'package:flutter/material.dart';
import 'aboutuspage.dart';
import 'contactus.dart';
import 'homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloudinary/cloudinary.dart';
import 'cartpage.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  final Cloudinary cloudinary = Cloudinary.signedConfig(
    apiKey: '628515619397789',
    apiSecret: 'hrQRvjoMsIq_Jgxqo6PGJOwnCJA',
    cloudName: 'dwez9bgmh',
  );

  int _selectedIndex = 0;

  Future<void> _addMultipleProducts() async {
    final products = [
      {
        'name': 'Atorvastatin 20mg',
        'price': 15.99,
        'category': 'Heart',
        'description': 'Cholesterol lowering tablets',
        'imageUrl': 'assets/images/atorvastatin-20-mg-tablets.jpg',
        'isPopular': true,
        'stock': 45,
      },
      {
        'name': 'Albuterol Inhaler',
        'price': 18.50,
        'category': 'Lung',
        'description': 'Bronchospasm treatment',
        'imageUrl': 'assets/images/images.jpg',
        'isPopular': false,
        'stock': 25,
      },
      {
        'name': 'Artificial Tears',
        'price': 6.99,
        'category': 'Eye',
        'description': 'Lubricating eye drops',
        'imageUrl': 'assets/images/images (1).jpg',
        'isPopular': true,
        'stock': 80,
      },
      {
        'name': 'Ibuprofen 400mg',
        'price': 5.49,
        'category': 'Pain',
        'description': 'Anti-inflammatory tablets',
        'imageUrl': 'assets/images/ibuprofen-400-mg-bp-tablets.jpg',
        'isPopular': true,
        'stock': 120,
      },

    ];

    final batch = FirebaseFirestore.instance.batch();

    for (final product in products) {
      final docRef = FirebaseFirestore.instance.collection('products').doc();
      batch.set(docRef, product);
    }

    await batch.commit();
  }

  void _addSampleProduct() async {
    final product = {
      'name': 'Paracetamol',
      'price': 3.99,
      'category': 'Pain',
      'description': 'Pain relief tablets',
      'imageUrl': 'https://example.com/paracetamol.jpg',
      'isPopular': true,
      'stock': 50,
    };

    try {
      await FirebaseFirestore.instance.collection('products').add(product);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sample product added successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product: $e')),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AboutUsScreen()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ContactUsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
        appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pharmacy', 
              style: TextStyle(
                color: Colors.blue[800],
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search medicines...",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    Icon(Icons.filter_list, color: Colors.grey),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Categories",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CategoryButton(
                      icon: Icons.favorite,
                      label: "Heart",
                      isActive: true,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Heart category selected')),
                        );
                      },
                    ),
                    SizedBox(width: 8),
                    CategoryButton(
                      icon: Icons.medical_services,
                      label: "Lung",
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Lung category selected')),
                        );
                      },
                    ),
                    SizedBox(width: 8),
                    CategoryButton(
                      icon: Icons.remove_red_eye,
                      label: "Eye",
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Eye category selected')),
                        );
                      },
                    ),
                    SizedBox(width: 8),
                    CategoryButton(
                      icon: Icons.medication,
                      label: "Pain",
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Pain category selected')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Popular Products",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Viewing all products')),
                      );
                    },
                    child: Text(
                      "See all",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (!snapshot.hasData) {
                        return Center(
                          child: Text('No products available'),
                        );
                      }

                      final products = snapshot.data!.docs;

                      return GridView.builder(
                        physics: BouncingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index].data() as Map<String, dynamic>;
                          return ProductCard(
                            productId: products[index].id,
                            name: product['name'],
                            price: "\$${product['price']}",
                            category: product['category'],
                            imageUrl: product['imageUrl'],
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
      
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _addMultipleProducts, 
            mini: true,
            heroTag: 'adminBtn',
            child: Icon(Icons.admin_panel_settings),
          ),
          SizedBox(height: 16),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .collection('cart')
                .snapshots(),
            builder: (context, snapshot) {
              int count = snapshot.data?.docs.length ?? 0;
              return FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartPage()), // Navigate to CartPage
                  );
                },
                backgroundColor: Colors.blue,
                child: Stack(
                  children: [
                    const Icon(Icons.shopping_cart, color: Colors.white),
                    if (count > 0)
                      Positioned(
                        right: 0,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.red,
                          child: Text(
                            '$count',
                            style: const TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
        bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: "About Us",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail),
            label: "Contact Us",
          ),
        ],
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const CategoryButton({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? Colors.white : Colors.blue,
            ),
            SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String productId;
  final String name;
  final String price;
  final String category;
  final String imageUrl;

  const ProductCard({
    required this.productId,
    required this.name,
    required this.price,
    required this.category,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    // Replace this child with the new code
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: imageUrl.startsWith('assets/')
                          ? Image.asset(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                print('Error loading asset image: $error');
                                return _buildErrorPlaceholder();
                              },
                            )
                          : Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                print('Error loading network image: $error');
                                return _buildErrorPlaceholder();
                              },
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    // Cart Button with Quantity
                    StreamBuilder<DocumentSnapshot>(
                      stream: user != null 
                          ? FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .collection('cart')
                              .doc(productId)
                              .snapshots()
                          : null,
                      builder: (context, snapshot) {
                        int quantity = 0;
                        if (snapshot.hasData && snapshot.data!.exists) {
                          quantity = (snapshot.data!.data() 
                              as Map<String, dynamic>)['quantity'] ?? 0;
                        }

                        return Row(
                          children: [
                            if (quantity > 0) ...[
                              InkWell(
                                onTap: () => _updateCart(context, false),
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text('$quantity'),
                              SizedBox(width: 8),
                            ],
                            InkWell(
                              onTap: () => _updateCart(context, true),
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Favorite Button
          Positioned(
            top: 8,
            right: 8,
            child: StreamBuilder<DocumentSnapshot>(
              stream: user != null 
                  ? FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .collection('favorites')
                      .doc(productId)
                      .snapshots()
                  : null,
              builder: (context, snapshot) {
                bool isFavorite = snapshot.hasData && snapshot.data!.exists;
                
                return InkWell(
                  onTap: () => _toggleFavorite(context),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

Widget _buildErrorPlaceholder() {
  return Container(
    color: Colors.blue[50],
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.medical_services, color: Colors.blue, size: 32),
        SizedBox(height: 4),
        Text(
          'No Image',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}

Future<void> _updateCart(BuildContext context, bool increment) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to use cart')),
      );
      return;
    }

    try {
      final cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc(productId);

      if (increment) {
        await cartRef.set({
          'productId': productId,
          'quantity': FieldValue.increment(1),
          'name': name,
          'price': price,
          'imageUrl': imageUrl,
        }, SetOptions(merge: true));
      } else {
        final doc = await cartRef.get();
        final currentQuantity = (doc.data()?['quantity'] ?? 0) as int;
        
        if (currentQuantity <= 1) {
          await cartRef.delete();
        } else {
          await cartRef.update({'quantity': FieldValue.increment(-1)});
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating cart: $e')),
      );
    }
  }

  Future<void> _toggleFavorite(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to favorite items')),
      );
      return;
    }

    try {
      final favoriteRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(productId);

      final doc = await favoriteRef.get();
      if (doc.exists) {
        await favoriteRef.delete();
      } else {
        await favoriteRef.set({
          'productId': productId,
          'name': name,
          'price': price,
          'imageUrl': imageUrl,
          'addedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating favorites: $e')),
      );
    }
  }
}