import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sse/themes/colors.dart';

class PendingAction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ModalBarrier(dismissible: false, color: white.withOpacity(0.5)
            // black.withOpacity(0.3),
            ),
        Align(alignment: Alignment.center,
            child: Stack(
              children: [
                CircularProgressIndicator(
              backgroundColor: Colors.grey.withOpacity(0.9),
              valueColor: new AlwaysStoppedAnimation<Color>(
                // Colors.pinkAccent
                  blue),
              strokeWidth: 3,
            ),
            Positioned(
              top: 5,
              left: 5,
              right: 5,
              bottom: 5,
              child: CircleAvatar(
                radius: 14.0,
                backgroundColor: Colors.transparent,
                child: Center(
                  child: Icon(
                    MdiIcons.mapMarkerRadius,
                    color: subColor,
                  ),
                ),
              ),
            )
          ],
        )),
      ],
    );
  }
}
