import 'package:flutter/material.dart';
import 'package:projectphrase2/pages/addItem.dart';
import 'package:projectphrase2/pages/chat.dart';
import 'package:projectphrase2/pages/favItem.dart';
import 'package:projectphrase2/pages/usermanage_page.dart';
import 'package:projectphrase2/widgets/navbar.dart';
import '../services/auth_service.dart';
import '../widgets/fieldinput.dart';
import '../widgets/product_display.dart';

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
      Navigator.push(context, MaterialPageRoute(builder: (_) => Chat()));
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
                padding: const EdgeInsets.fromLTRB(30, 60, 30, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Home',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w500,
                      ),
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
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: TextFieldSearch(
                    textEditingController: controllerSearch,
                    hintText: 'Looking for?',
                    icon: Icons.search,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Popular Items',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              sliver: SliverGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 0,
                crossAxisSpacing: 20,
                childAspectRatio: 0.57, //width/height
                children: const [
                  ProductDisplay(),
                  ProductDisplay(),
                  ProductDisplay(),
                  ProductDisplay(),
                  ProductDisplay(),
                  ProductDisplay(),
                  ProductDisplay(),
                  ProductDisplay(),
                ],
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
