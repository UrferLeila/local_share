import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:local_share/src/common_widgets/app_bar_widget.dart';
import 'package:local_share/src/common_widgets/inline_filter.dart';
import 'package:local_share/src/common_widgets/offer_card.dart';
import 'package:local_share/src/common_widgets/search_bar_offer.dart';
import 'package:local_share/src/constant/app_size.dart';
import 'package:local_share/src/features/offres/data/offer_list_provider.dart';
import 'package:local_share/src/features/offres/data/user_provider.dart';
import 'package:local_share/src/features/offres/domain/offer.dart';
import 'package:local_share/src/features/offres/routing/app_router.dart';
import 'package:local_share/src/theme/theme.dart';

class OffersScreen extends ConsumerStatefulWidget {
  const OffersScreen({super.key});

  @override
  ConsumerState<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends ConsumerState<OffersScreen> {
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

  Future<void> deleteOffre(String offerId) async {
    try {
      String baseUrl = kIsWeb
          ? "https://localhost:7024"
          : "https://10.0.2.2:7024";

      final response = await http.delete(
        Uri.parse("$baseUrl/api/offer/$offerId"),
        headers: {"Content-Type": "application/json"},
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
        final listOfoffers = (dataMap["offres"] as List<Offre>)
            .where((offre) => offre.user == user!.id)
            .toList();
        final filteredOffers = filterOffers(listOfoffers);
        return Scaffold(
          appBar: AppBarWidget(title: "Vos offres"),
          body: LayoutBuilder(
            builder: (context, constraints) {
              bool isDesktopOrTablet = constraints.maxWidth > Sizes.p768;
              return Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: isDesktopOrTablet ? Sizes.p700 : double.infinity,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(Sizes.p12),
                        child: Column(
                          children: [
                            Center(
                              child: SearchBarOffer(
                                hintText: "Rechercher une offre...",
                                onSearch: onSearch,
                              ),
                            ),
                            gapH12,
                            Center(
                              child: InlineFilter(
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
                              isAdmin: true,
                              onDelete: deleteOffre,
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
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final bool? shouldRefresh = await context.pushNamed<bool>(
                AppRoute.create.name,
                extra: user,
              );

              if (shouldRefresh == true) {
                ref.invalidate(offerListNotifierProvider);
              }
            },
            backgroundColor: AppColors.cyan,
            child: Icon(Icons.add, color: AppColors.black),
          ),
        );
      },
    );
  }
}
