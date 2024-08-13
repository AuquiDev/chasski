import 'package:chasski/page/runner/navbar/profile/profile_runner_footer.dart';
import 'package:chasski/page/runner/navbar/profile/profile_runner_header.dart';
import 'package:flutter/material.dart';

class RunnerProfile extends StatelessWidget {
  const RunnerProfile({
    super.key,
  });

  @override 
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final heightBotton = size.height * .70;
    return Scaffold(
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [
            HeaderProfile(size: size), //30% de la pantalla
            TabBarBottom(heightBotton: heightBotton *.9)
          ],
        ),
      ),
    );
  }
}
