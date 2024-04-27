import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class PopupManager {
  OverlayEntry? _overlayEntry;

  void showConnectivityPopup(BuildContext context) {
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
        builder: (BuildContext context) => Stack(
          children: [
            BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Container(
                constraints: const BoxConstraints.expand(),
                color: const Color(0xFF437AE5).withOpacity(0.5),
              ),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Text(
                  'Connection Lost\nPlease Reconnect to WiFi or Cellular Data',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
      Overlay.of(context)!.insert(_overlayEntry!);
    }
  }

  void dismissConnectivityPopup() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }
}
