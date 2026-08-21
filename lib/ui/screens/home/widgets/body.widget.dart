import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/ui/shared/constants/app_assets.dart';
import 'package:tvapp/ui/screens/home/widgets/categories.widget.dart';
import 'package:tvapp/ui/screens/home/widgets/notification_button.widget.dart';
import 'package:tvapp/ui/screens/home/widgets/top_channels.widget.dart';
import 'package:tvapp/ui/screens/home/widgets/welcome_slider.widget.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';

class BodyHome extends StatelessWidget {
  const BodyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        title: InkWell(
          onDoubleTap: Environment.easterEggMode ?  () {
            showTokensList(context);
          }: null,
          splashColor: Colors.transparent,
          child: SvgPicture.asset(
            AppAssets.logoOneplay,
            width: MediaQuery.of(context).size.width * (Environment.splashWidth),
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          if(Environment.notificationsEnabled)
            const NotificationButton()
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WelcomeSlider(),
            SizedBox(height: 16),
            TopChannels(),
            SizedBox(height: 16),
            CategoriesGrid(),
          ],
        ),
      ),
    );
  }

  Future<void> showTokensList(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? tokens = prefs.getStringList('tokens');
    //mostrar alerta con lostokens
    if (tokens != null) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Tokens'),
            content: SizedBox(
              width: 400,
              height: 300,
              child: ListView.separated(
                itemCount: tokens.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(tokens[index], style: const TextStyle(fontSize: 10)),
                  );
                }, separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
              },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cerrar', style: TextStyle(color: Colors.red)),
              ),
            ],
          );
        },
      );
    }
  }
}
