import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/network/api_client.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/cart/page/cart_page.dart';
import '../../features/products/data/datasources/product_remote_data_source.dart';
import '../../features/products/data/repositories/product_repository.dart';
import '../../features/products/presentation/bloc/product_bloc.dart';
import '../../features/products/presentation/bloc/product_event.dart';
import '../../features/products/presentation/details_bloc/product_details_bloc.dart';
import '../../features/products/presentation/details_bloc/product_details_event.dart';
import '../../features/products/presentation/pages/checkout_page.dart';
import '../../features/products/presentation/pages/home_page.dart';
import '../../features/products/presentation/pages/order_success_page.dart';
import '../../features/products/presentation/pages/product_details_page.dart';
import '../../features/profile/profile_page.dart';
import '../../features/wishlist/wishlist_page.dart';
import 'main_shell.dart';

ProductRepository _createProductRepository() {
  final apiClient = ApiClient();

  final remoteDataSource = ProductRemoteDataSource(
    apiClient,
  );

  return ProductRepository(
    remoteDataSource,
  );
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',

  redirect: (context, state) {
    final authState = context.read<AuthBloc>().state;

    final isAuthenticated =
        authState.status == AuthStatus.authenticated;

    final isLoggingIn =
        state.matchedLocation == '/login';

    final isRegistering =
        state.matchedLocation == '/register';

    final isPublicRoute =
        isLoggingIn || isRegistering;

    if (!isAuthenticated && !isPublicRoute) {
      return '/login';
    }

    if (isAuthenticated && isPublicRoute) {
      return '/home';
    }

    return null;
  },

  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) {
        return const RegisterPage();
      },
    ),
    ShellRoute(
      builder: (context, state, child) {
        return MainShell(
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) {
            final repository =
                _createProductRepository();

            return BlocProvider(
              create: (context) => ProductBloc(repository)
                ..add(const LoadProducts())
                ..add(const LoadCategories()),
              child: const HomePage(),
            );
          },
        ),
        GoRoute(
          path: '/wishlist',
          name: 'wishlist',
          builder: (context, state) {
            return const WishlistPage();
          },
        ),
        GoRoute(
          path: '/cart',
          name: 'cart',
          builder: (context, state) {
            return const CartPage();
          },
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) {
            return const ProfilePage();
          },
        ),
      ],
    ),
    GoRoute(
      path: '/products/:productId',
      name: 'productDetails',
      builder: (context, state) {
        final productId = int.parse(
          state.pathParameters['productId']!,
        );

        final repository =
            _createProductRepository();

        return BlocProvider(
          create: (context) =>
              ProductDetailsBloc(repository)
                ..add(
                  LoadProductDetails(productId),
                ),
          child: ProductDetailsPage(
            productId: productId,
          ),
        );
      },
    ),
    GoRoute(
      path: '/checkout',
      name: 'checkout',
      builder: (context, state) {
        return const CheckoutPage();
      },
    ),
    GoRoute(
      path: '/order-success',
      name: 'orderSuccess',
      builder: (context, state) {
        return const OrderSuccessPage();
      },
    ),
  ],
);