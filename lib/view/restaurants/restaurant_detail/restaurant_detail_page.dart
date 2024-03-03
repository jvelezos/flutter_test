import 'package:flutter/material.dart';
import 'package:restaurantour/dependency_injection/di_locator.dart';
import 'package:restaurantour/design_system/restaurant_details.dart';
import 'package:restaurantour/domain/restaurants/entities/restaurant_entity.dart';
import 'package:restaurantour/view/restaurants/restaurant_detail/restaurant_detail_view_model.dart';
import 'package:provider/provider.dart';

class RestaurantDetailPage extends StatelessWidget {
  const RestaurantDetailPage({
    Key? key,
    required this.restaurant,
  }) : super(key: key);
  final RestaurantEntity restaurant;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RestaurantDetailViewModel>(
      create: (context) =>
          locator<RestaurantDetailViewModel>()..init(restaurant),
      builder: (context, child) {
        return Consumer<RestaurantDetailViewModel>(
          builder: (context, viewModel, child) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  restaurant.name,
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    // Navigate back to the previous page
                    Navigator.pop(context);
                  },
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      viewModel.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                    ),
                    onPressed: () {
                      final priorStatus = viewModel.isFavorite;
                      // toggle the favorite status
                      viewModel.toggleFavorite();

                      // Show a snackbar to confirm the action
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            priorStatus
                                ? 'Removed from favorites'
                                : 'Added to favorites',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    // Display the hero image
                    Hero(
                      tag: restaurant.id,
                      child: Image.network(
                        restaurant.heroImage,
                        fit: BoxFit.cover,
                        height: 300,
                        width: double.infinity,
                      ),
                    ),
                    // Display the restaurant details
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RestaurantDetails(
                        price: restaurant.price,
                        category: restaurant.category,
                      ),
                    ),
                    // Display the restaurant rating
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Rating: ${restaurant.rating}',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    // Display the restaurant price
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Price: ${restaurant.price}',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    // Display the restaurant open status
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Open: ${restaurant.isOpen ? 'Yes' : 'No'}',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    // Display the restaurant reviews
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: restaurant.reviews
                            .map(
                              (review) => ListTile(
                                // leading: CircleAvatar(
                                //   backgroundImage:
                                //       NetworkImage(review.author.profileImageUrl),
                                // ),
                                title: Text(review.author.name),
                                subtitle: Text(review.comment),
                                trailing: Text('${review.rating}'),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
