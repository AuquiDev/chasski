
import 'package:url_launcher/url_launcher.dart';

Future<void> launchURL(String url) async {
  print(url);
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<void> launchServerURL(
    {String? file, String? collectionId, String? id}) async {
  final url =
      'https://andes-race-challenge.pockethost.io/api/files/${collectionId}/${id}/${file}';
  print(url);
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
