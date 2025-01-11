import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_loop/pages/feed.dart';
import 'package:learn_loop/pages/library.dart';

int _pageIndex = 1;

class UploadPage extends ConsumerStatefulWidget {
  const UploadPage({super.key});

  @override
  ConsumerState<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends ConsumerState<UploadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50, bottom: 30),
              child: Text(
                  "Upload a document",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)
              ),
            ),
            ElevatedButton(
              onPressed: (){},
              child: Text("Upload", style: TextStyle(color: Colors.white))
            )
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
