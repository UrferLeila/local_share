import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:local_share/src/common_widgets/app_bar_widget.dart';
import 'package:local_share/src/common_widgets/offre_card.dart';
import 'package:local_share/src/constant/app_size.dart';
import 'package:local_share/src/features/offres/data/offre_list_provider.dart';
import 'package:local_share/src/features/offres/data/user_provider.dart';
import 'package:local_share/src/features/offres/domain/offre.dart';
import 'package:local_share/src/features/offres/routing/app_router.dart';
import 'package:local_share/src/theme/theme.dart';

class MyOffersScreen extends ConsumerStatefulWidget {
  const MyOffersScreen({super.key});

  @override
  ConsumerState<MyOffersScreen> createState() => _MyOffersScreenState();
}

class _MyOffersScreenState extends ConsumerState<MyOffersScreen> {
  Future<void> deleteOffre(String offreId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:3000/offres/$offreId'),
        headers: {'Content-Type': 'application/json'},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Offer successfully removed!')),
        );
        context.pop();
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['error'] ?? 'Error whilst deleting')),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to contact the server : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(userProvider);
    final config = ref.watch(offreListNotifierProvider);

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
            'Erreur : $error',
            style: TextStyle(color: AppColors.lightRed),
          ),
        ),
      ),
      data: (dataMap) {
        final listOfoffres = (dataMap['offres'] as List<Offre>)
            .where((offre) => offre.user == currentUser!.id)
            .toList();
        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.hub, color: AppColors.lightPurple, size: Sizes.p20),
                gapW8,
                Text("${listOfoffres.length} offres trouvées !"),
              ],
            ),
            centerTitle: true,
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              bool isDesktopOrTablet = constraints.maxWidth > 768;
              return Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: isDesktopOrTablet ? 700 : double.infinity,
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: Sizes.p12),
                    itemCount: listOfoffres.length,
                    itemBuilder: (context, index) {
                      return OffreCard(
                        offre: listOfoffres[index],
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
                AppRoute.creatOffer.name,
                extra: currentUser,
              );

              if (shouldRefresh == true) {
                ref.invalidate(offreListNotifierProvider);
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
