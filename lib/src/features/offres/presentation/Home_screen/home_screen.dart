import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_share/src/common_widgets/offre_card.dart';
import 'package:local_share/src/features/offres/data/offre_list_provider.dart';
import 'package:local_share/src/features/offres/data/user_provider.dart';
import 'package:local_share/src/features/offres/domain/offre.dart';
import 'package:local_share/src/features/offres/routing/app_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(userProvider);
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
                      return OffreCard(
                        offre: listOfoffres[index],
                        isAdmin: currentUser?.isAdmin ?? false,
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
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            backgroundColor: const Color(0xFF1E1E1E),
            selectedItemColor: const Color(0xFF6C63FF),
            unselectedItemColor: const Color(0xFFA4B0BE),
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Accueil',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_offer_outlined),
                activeIcon: Icon(Icons.local_offer),
                label: 'Mes offres',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
          ),
        );
      },
    );
  }
}
