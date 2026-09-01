import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:local_share/src/common_widgets/app_bar_widget.dart';
import 'package:local_share/src/common_widgets/offer_card.dart';
import 'package:local_share/src/constant/app_size.dart';
import 'package:local_share/src/features/offres/data/offre_list_provider.dart';
import 'package:local_share/src/features/offres/data/user_provider.dart';
import 'package:local_share/src/features/offres/domain/offre.dart';
import 'package:local_share/src/features/offres/routing/app_router.dart';
import 'package:local_share/src/theme/theme.dart';

class OffersScreen extends ConsumerStatefulWidget {
  const OffersScreen({super.key});

  @override
  ConsumerState<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends ConsumerState<OffersScreen> {
  Future<void> deleteOffre(String offerId) async {
    try {
      final response = await http.delete(
        Uri.parse("http://localhost:3000/offres/$offerId"),
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

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final config = ref.watch(offerListNotifierProvider);

    return config.when(
      loading: () => Scaffold(
        appBar: AppBarWidget(title: "Vos offres"),
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
        final listOfoffers = (dataMap['offres'] as List<Offre>)
            .where((offre) => offre.user == user!.id)
            .toList();
        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.hub, color: AppColors.lightPurple, size: Sizes.p20),
                gapW8,
                Text("${listOfoffers.length} offres trouvées !"),
              ],
            ),
            centerTitle: true,
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              bool isDesktopOrTablet = constraints.maxWidth > Sizes.p768;
              return Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: isDesktopOrTablet ? Sizes.p700 : double.infinity,
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: Sizes.p12),
                    itemCount: listOfoffers.length,
                    itemBuilder: (context, index) {
                      return OfferCard(
                        offer: listOfoffers[index],
                        isAdmin: true,
                        onDelete: deleteOffre,
                      );
                    },
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
