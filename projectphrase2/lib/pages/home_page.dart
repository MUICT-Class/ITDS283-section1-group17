import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 60, 30, 20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Home',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
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
                childAspectRatio: 0.6,
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
