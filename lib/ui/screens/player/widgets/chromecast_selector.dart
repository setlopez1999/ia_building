import 'package:flutter/material.dart';
import 'package:flutter_chrome_cast/flutter_chrome_cast.dart';

class ChromecastSelector extends StatelessWidget {
  const ChromecastSelector({
    super.key,
    required this.onClosed,
    required this.onSelect
  });

  final VoidCallback onClosed;
  final Function(GoogleCastDevice device) onSelect;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: InkWell(
          onTap: () {
            GoogleCastDiscoveryManager.instance.stopDiscovery();
            onClosed();
          },
          child: SafeArea(
            top: false,
            right: false,
            left: false,
            bottom: false,
            child: Center(
              child: SizedBox(
                height: 250,
                width: 300,
                child: StreamBuilder<List<GoogleCastDevice>>(
                  stream: GoogleCastDiscoveryManager.instance.devicesStream,
                  builder: (context, snapshot) {
                    final devices = snapshot.data ?? [];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        color: Colors.black,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  TextButton(onPressed: (){}, child: const Text('Selecciona un dispositivo', style: TextStyle(color: Colors.white))),
                                ],
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ListView(
                                        children: [
                                          ...devices.map((device) {
                                            return ListTile(
                                              title: Text(device.friendlyName, style: const TextStyle(color: Colors.white)),
                                              subtitle: Text(device.modelName ?? '', style: const TextStyle(color: Colors.white)),
                                              onTap: () => onSelect(device),
                                            );
                                          }),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(onPressed: (){
                                    GoogleCastDiscoveryManager.instance.stopDiscovery();
                                    onClosed();
                                  }, child: const Text('Cerrar', style: TextStyle(color: Colors.white))),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
