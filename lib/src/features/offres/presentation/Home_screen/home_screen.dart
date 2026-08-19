import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_share/src/features/offres/data/offre_list_provider.dart';
import 'package:local_share/src/features/offres/domain/offre.dart';
import 'package:local_share/src/features/offres/routing/app_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  // final bool isAdmin;

  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final config = ref.watch(offreListNotifierProvider);
    return config.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
        ),
      ),
      error: (error, _) => Scaffold(
        body: Center(
          child: Text(
            'Erreur : $error',
            style: const TextStyle(color: Color(0xFFFF4757)),
          ),
        ),
      ),
      data: (dataMap) {
        final listOfoffres = dataMap['offres'] as List<Offre>;
        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.hub, color: Color(0xFF6C63FF), size: 22),
                const SizedBox(width: 8),
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
                    padding: const EdgeInsets.only(top: 12.0),
                    itemCount: listOfoffres.length,
                    itemBuilder: (context, index) {
                      final offre = listOfoffres[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(
                                      0xFF6C63FF,
                                    ).withValues(alpha: 0.4),
                                    width: 1.5,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6.5),
                                  child: Container(
                                    width: 70,
                                    height: 70,
                                    color: const Color(0xFF2C2C2C),
                                    child: const Icon(
                                      Icons.image_outlined,
                                      color: Color(0xFF6C63FF),
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            offre.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFFF5F6FA),
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                              255,
                                              0,
                                              223,
                                              212,
                                            ).withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: const Text(
                                            'Dispo',
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                255,
                                                0,
                                                223,
                                                212,
                                              ),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      offre.description ?? 'Aucune description',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Color(0xFFA4B0BE),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.goNamed(AppRoute.creatOffer.name);
            },
            backgroundColor: const Color.fromARGB(255, 0, 223, 212),
            child: const Icon(Icons.add, color: Color(0xFF121212)),
          ),
        );
      },
    );
  }
}
