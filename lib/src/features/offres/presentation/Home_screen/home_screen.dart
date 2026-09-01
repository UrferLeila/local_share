import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:local_share/src/common_widgets/app_bar_widget.dart';
import 'package:local_share/src/common_widgets/inline_filter.dart';
import 'package:local_share/src/common_widgets/offer_card.dart';
import 'package:local_share/src/common_widgets/search_bar_offer.dart';
import 'package:local_share/src/constant/app_size.dart';
import 'package:local_share/src/features/offres/data/offre_list_provider.dart';
import 'package:local_share/src/features/offres/data/user_provider.dart';
import 'package:local_share/src/features/offres/domain/offre.dart';
import 'package:local_share/src/theme/theme.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String currentSearchQuery = "";
  int selectedPageNumber = 1;
  List<OfferType> selectedFilters = [];

  void onSearch(String query) {
    setState(() {
      currentSearchQuery = query.toLowerCase();
      selectedPageNumber = 1;
    });
  }

  void onFilterChanged(List<OfferType> filters) {
    setState(() {
      selectedFilters = filters;
      selectedPageNumber = 1;
    });
  }

  Future<void> deleteOffer(String offreId) async {
    try {
      final response = await http.delete(
        Uri.parse("http://localhost:3000/offres/$offreId"),
        headers: {'Content-Type': 'application/json'},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == Sizes.p200) {
        if (!mounted) return;

        ref.invalidate(offerListNotifierProvider);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Offer successfully removed!")),
        );
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["error"] ?? "Error whilst deleting")),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unable to contact the server : $e")),
      );
    }
  }

  List<Offre> filterOffers(List<Offre> offers) {
    return offers.where((offer) {
      final query = currentSearchQuery.toLowerCase();

      final matchSearch =
          query.isEmpty ||
          offer.name.toLowerCase().contains(query) ||
          (offer.description ?? "").toLowerCase().contains(query);

      final matchFilter =
          selectedFilters.isEmpty || selectedFilters.contains(offer.type);

      return matchSearch && matchFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final config = ref.watch(offerListNotifierProvider);

    return config.when(
      loading: () => Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.lightPurple),
        ),
      ),
      error: (error, _) => Scaffold(
        body: Center(
          child: Text(
            "Erreur : $error",
            style: TextStyle(color: AppColors.lightRed),
          ),
        ),
      ),
      data: (dataMap) {
        final listOfoffers = (dataMap["offres"] as List<Offre>);
        final filteredOffers = filterOffers(listOfoffers);
        return Scaffold(
          appBar: AppBarWidget(
            title: "${filteredOffers.length} offres trouvées !",
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              bool isDesktopOrTablet = constraints.maxWidth > Sizes.p768;
              return Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: isDesktopOrTablet ? Sizes.p700 : double.infinity,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsetsGeometry.all(Sizes.p12),
                        child: Column(
                          children: [
                            SearchBarOffer(
                              hintText: "Rechercher une offre...",
                              onSearch: onSearch,
                            ),
                            gapH12,
                            InlineFilter(
                              onFilterChanged: onFilterChanged,
                              typeOffers: {
                                OfferType.achat: "Achat",
                                OfferType.service: "Service",
                                OfferType.pret: "Prêt",
                              },
                              selectedColor: AppColors.lightPurple,
                              selectedTextColor: AppColors.lightwhite,
                              unselectedColor: AppColors.lightBrown,
                              unselectedTextColor: AppColors.lightwhite,
                              borderColor: AppColors.lightwhite,
                              borderWidth: Sizes.p0,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: Sizes.p12),
                          itemCount: filteredOffers.length,
                          itemBuilder: (context, index) {
                            return OfferCard(
                              offer: filteredOffers[index],
                              isAdmin: user?.isAdmin ?? false,
                              onDelete: deleteOffer,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
