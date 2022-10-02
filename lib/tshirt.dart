import 'dart:math' as math;
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class TShirtPage extends StatefulWidget {
  const TShirtPage({super.key});

  @override
  _TshirtState createState() => _TshirtState();
}

class _TshirtState extends State<TShirtPage> {
  late ARKitController arkitController;
  ARKitPlane? plane;
  ARKitNode? node;
  String? anchorId;

  @override
  void dispose() {
    arkitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 100,
        leading: ElevatedButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_left_sharp),
          label: const Text('Back'),
          style: ElevatedButton.styleFrom(elevation: 0),
        ),
      ),
      body: ARKitSceneView(
        // showFeaturePoints: true,
        planeDetection: ARPlaneDetection.horizontal,
        onARKitViewCreated: onARKitViewCreated,
        environmentTexturing:
            ARWorldTrackingConfigurationEnvironmentTexturing.automatic,
      ));

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    // arkitController.addCoachingOverlay(CoachingOverlayGoal.horizontalPlane);
    // arkitController.onAddNodeForAnchor = _handleAddAnchor;
    this.arkitController.onAddNodeForAnchor = _handleAddAnchor;
    this.arkitController.onUpdateNodeForAnchor = _handleUpdateAnchor;
  }

  ARKitNode _createPlane() {
    final plane = ARKitPlane(
      width: 1,
      height: 1,
      materials: [
        ARKitMaterial(
          transparency: 0.5,
          diffuse: ARKitMaterialProperty.color(Colors.white),
        )
      ],
    );
    return ARKitNode(
      geometry: plane,
      position: vector.Vector3(0, 0, -1.5),
    );
  }

  void _handleAddAnchor(ARKitAnchor anchor) {
    if (anchor is! ARKitPlaneAnchor) {
      return;
    }
    _addPlane(arkitController, anchor);
  }

  void _handleUpdateAnchor(ARKitAnchor anchor) {
    if (anchor.identifier != anchorId || anchor is! ARKitPlaneAnchor) {
      return;
    }
    node?.position = vector.Vector3(anchor.center.x, 0, anchor.center.z);
    plane?.width.value = anchor.extent.x;
    plane?.height.value = anchor.extent.z;
  }

  void _addPlane(ARKitController controller, ARKitPlaneAnchor anchor) {
    anchorId = anchor.identifier;
    plane = ARKitPlane(
      width: anchor.extent.x,
      height: anchor.extent.z,
      materials: [
        ARKitMaterial(
          transparency: 0.5,
          diffuse: ARKitMaterialProperty.color(Colors.white),
        )
      ],
    );

    node = ARKitNode(
      geometry: ARKitPlane(
        width: 0.01,
        height: 0.5,
        materials: [
          ARKitMaterial(
            transparency: 1.0,
            diffuse: ARKitMaterialProperty.color(Colors.white),
          )
        ],
      ),
      position: vector.Vector3(anchor.center.x, 0, anchor.center.z),
      rotation: vector.Vector4(1, 0, 0, -math.pi / 2),
    );
    controller.add(node!, parentNodeName: anchor.nodeName);
  }
}
