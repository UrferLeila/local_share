import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_share/src/features/offres/data/offre_list_provider.dart';
import 'package:local_share/src/features/offres/domain/offre.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final config = ref.watch(offreListNotifierProvider);
    return config.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) =>
          Scaffold(body: Center(child: Text('Erreur : $error'))),
      data: (dataMap) {
        final listOfoffres = dataMap['offres'] as List<Offre>;

        return Scaffold(
          appBar: AppBar(
            title: Text("${listOfoffres.length} found !"),
            centerTitle: true,
            backgroundColor: Colors.cyan,
          ),
          body: ListView.builder(
            itemCount: listOfoffres.length,
            itemBuilder: (context, index) {
              final offre = listOfoffres[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    offre.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    offre.description ?? 'Aucune description',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    'ID: ${offre.id.substring(offre.id.length > 6 ? offre.id.length - 6 : 0)}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
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
