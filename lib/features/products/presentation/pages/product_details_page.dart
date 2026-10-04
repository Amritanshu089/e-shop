import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cart/domain/cart_item.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../../data/models/product_model.dart';
import '../details_bloc/product_details_bloc.dart';
import '../details_bloc/product_details_event.dart';
import '../details_bloc/product_details_state.dart';

class ProductDetailsPage extends StatefulWidget {
  final int productId;

  const ProductDetailsPage({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailsPage> createState() =>
      _ProductDetailsPageState();
}

class _ProductDetailsPageState
    extends State<ProductDetailsPage> {
  final PageController _pageController = PageController();

  int _currentImage = 0;
  int _quantity = 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      body: BlocBuilder<ProductDetailsBloc,
          ProductDetailsState>(
        builder: (context, state) {
          if (state.status ==
              ProductDetailsStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.status ==
              ProductDetailsStatus.failure) {
            return _buildErrorState(context, state);
          }

          final product = state.product;

          if (product == null) {
            return const Center(
              child: Text('Product not found'),
            );
          }

          final discountedPrice = product.price -
              (product.price *
                  product.discountPercentage /
                  100);

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor:
                    const Color(0xFFF8F7FC),
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: _appBarButton(
                    Icons.arrow_back_rounded,
                    () => Navigator.of(context).pop(),
                  ),
                ),
                actions: [
                  _appBarButton(
                    Icons.favorite_border_rounded,
                    () {},
                  ),
                  const SizedBox(width: 8),
                  _appBarButton(
                    Icons.shopping_bag_outlined,
                    () {},
                  ),
                  const SizedBox(width: 16),
                ],
              ),
              SliverToBoxAdapter(
                child: _buildGallery(product),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    22,
                    20,
                    30,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      _buildHeader(product),
                      const SizedBox(height: 20),
                      _buildPrice(
                        product,
                        discountedPrice,
                      ),
                      const SizedBox(height: 20),
                      _buildStock(product),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 22),
                      _buildDescription(product),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 22),
                      _buildQuantity(product),
                      const SizedBox(height: 25),
                      _buildCartButton(context, product),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _appBarButton(
    IconData icon,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(
            icon,
            size: 21,
            color: const Color(0xFF29243D),
          ),
        ),
      ),
    );
  }

  Widget _buildGallery(ProductModel product) {
    final images = product.images.isNotEmpty
        ? product.images
        : [product.thumbnail];

    return Column(
      children: [
        Container(
          height: 360,
          margin: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: images.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentImage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(30),
                      child: Image.network(
                        images[index],
                        fit: BoxFit.contain,
                      ),
                    );
                  },
                ),
                if (product.discountPercentage > 0)
                  Positioned(
                    left: 18,
                    top: 18,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF5C7A),
                        borderRadius:
                            BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${product.discountPercentage.toStringAsFixed(0)}% OFF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (images.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: List.generate(
                images.length,
                (index) => AnimatedContainer(
                  duration:
                      const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 3,
                  ),
                  width:
                      _currentImage == index ? 20 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: _currentImage == index
                        ? const Color(0xFF7C4DFF)
                        : const Color(0xFFD9D5E4),
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHeader(ProductModel product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.brand.isNotEmpty
              ? product.brand.toUpperCase()
              : product.category.toUpperCase(),
          style: const TextStyle(
            color: Color(0xFF7C4DFF),
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          product.title,
          style: const TextStyle(
            fontSize: 25,
            height: 1.15,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(
              Icons.star_rounded,
              color: Color(0xFFFFB020),
            ),
            const SizedBox(width: 4),
            Text(
              product.rating.toStringAsFixed(1),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${product.stock} items available',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPrice(
    ProductModel product,
    double discountedPrice,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '\$${discountedPrice.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 29,
            fontWeight: FontWeight.w900,
          ),
        ),
        if (product.discountPercentage > 0) ...[
          const SizedBox(width: 10),
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStock(ProductModel product) {
    final inStock = product.stock > 0;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: inStock
            ? const Color(0xFFEAF8EF)
            : const Color(0xFFFFEEF1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            inStock
                ? Icons.check_circle_rounded
                : Icons.cancel_rounded,
            color: inStock
                ? const Color(0xFF35A85B)
                : const Color(0xFFFF5C7A),
          ),
          const SizedBox(width: 10),
          Text(
            inStock
                ? 'In stock • Ready to ship'
                : 'Currently out of stock',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(ProductModel product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About this product',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          product.description,
          style: const TextStyle(
            color: Color(0xFF6D687D),
            fontSize: 13,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildQuantity(ProductModel product) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Quantity',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: _quantity > 1
                    ? () {
                        setState(() {
                          _quantity--;
                        });
                      }
                    : null,
                icon: const Icon(
                  Icons.remove_rounded,
                ),
              ),
              Text(
                '$_quantity',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
              IconButton(
                onPressed: _quantity < product.stock
                    ? () {
                        setState(() {
                          _quantity++;
                        });
                      }
                    : null,
                icon: const Icon(
                  Icons.add_rounded,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCartButton(
    BuildContext context,
    ProductModel product,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton.icon(
        onPressed: product.stock <= 0
            ? null
            : () {
                context.read<CartBloc>().add(
                      AddToCart(
                        CartItem(
                          product: product,
                          quantity: _quantity,
                        ),
                      ),
                    );

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  SnackBar(
                    content: Text(
                      '${product.title} added to cart',
                    ),
                    behavior:
                        SnackBarBehavior.floating,
                  ),
                );
              },
        icon: const Icon(
          Icons.shopping_bag_outlined,
        ),
        label: Text(
          product.stock > 0
              ? 'Add $_quantity to cart'
              : 'Out of stock',
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7C4DFF),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    ProductDetailsState state,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            size: 60,
            color: Color(0xFFFF5C7A),
          ),
          const SizedBox(height: 15),
          const Text(
            'Unable to load product',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              context
                  .read<ProductDetailsBloc>()
                  .add(
                    LoadProductDetails(
                      widget.productId,
                    ),
                  );
            },
            child: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}