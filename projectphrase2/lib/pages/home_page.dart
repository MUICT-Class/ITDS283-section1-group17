import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projectphrase2/pages/addItem.dart';
import 'package:projectphrase2/pages/chat_page.dart';
import 'package:projectphrase2/pages/chathistory_page.dart';
import 'package:projectphrase2/pages/favItem.dart';
import 'package:projectphrase2/pages/usermanage_page.dart';
import 'package:projectphrase2/widgets/navbar.dart';
import '../services/auth_service.dart';
import '../widgets/fieldinput.dart';
import '../widgets/product_display.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectphrase2/models/product_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controllerSearch = TextEditingController();

  void onTap(int index, BuildContext context) {
    if (index == 0) {
      //stay here
    } else if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => FavItem()));
    } else if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => Additem()));
    } else if (index == 3) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => ChatHistory()));
    } else if (index == 4) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => UsermanagePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Navbar(
        currentIndex: 0,
        onTap: (index) => onTap(index, context),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 60, 25, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MU',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Marketplace',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SearchBarDelegate(
                child: Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFieldSearch(
                          textEditingController: controllerSearch,
                          hintText: 'Looking for?',
                          onSearchPressed: () {
                            setState(() {
                              print('search : ${controllerSearch.text}');
                            });
                          },
                        ),
                      ),
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/icons/search_icon.svg',
                          width: 30,
                          height: 30,
                          color: Color(0xFF007F55),
                        ),
                        onPressed: () => setState(() {
                          print("Search ${controllerSearch.text}");
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Items',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .where('name',
                        isGreaterThanOrEqualTo: controllerSearch.text)
                    .where('name',
                        isLessThanOrEqualTo: controllerSearch.text + '\uf8ff')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }

                  final docs = snapshot.data?.docs ?? [];
                  final products = docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return ProductModel.fromJson(data, id: doc.id);
                  }).toList();

                  return GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 20,
                    childAspectRatio: 0.60,
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    children: products
                        .map((product) => ProductDisplay(product: product))
                        .toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SearchBarDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 70;
  @override
  double get minExtent => 70;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
