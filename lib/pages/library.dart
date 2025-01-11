import 'package:flutter/material.dart';
import 'package:learn_loop/pages/feed.dart';
import 'package:learn_loop/pages/upload.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

int _pageIndex = 2;

class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent,),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50, bottom: 30),
              child: Text(
                  "Uploaded Documents",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)
              ),
            ),
            Text("hola soy doar"),
            Text("hola soy doar"),
            Text("hola soy doar")
          ],
        )
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(
              color: Colors.white,
            ),
          )
        ),
        child: NavigationBar(
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined, color: Colors.white,),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.add_circle_outline),
              icon: Icon(Icons.add_circle_outline, color: Colors.white),
              label: 'Upload',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.book, ),
              icon: Icon(Icons.book_outlined, color: Colors.white),
              label: 'Library',
            ),
          ],
          selectedIndex: _pageIndex,
          backgroundColor: Colors.black,
          onDestinationSelected: (int index) {
            if (_pageIndex == index) { return; }

            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                (index == 0) ? FeedPage() : ((index == 1) ? UploadPage() : LibraryPage()),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          },
        ),
      )
    );
  }
}
