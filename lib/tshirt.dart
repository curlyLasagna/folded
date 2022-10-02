import 'dart:math' as math;
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class TShirt extends StatefulWidget {
  const TShirt({super.key});

  @override
  _TshirtState createState() => _TshirtState();
}

class _TshirtState extends State<TShirt> {
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
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        child: ARKitSceneView(
          showFeaturePoints: true,
          planeDetection: ARPlaneDetection.horizontal,
          onARKitViewCreated: onARKitViewCreated,
          environmentTexturing:
              ARWorldTrackingConfigurationEnvironmentTexturing.automatic,
        ),
      ));

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    this.arkitController.add(_createText());
    this.arkitController.add(_createLine());
  }

  ARKitNode _createLine() => ARKitNode(
      geometry: ARKitCylinder(
          materials: _createRandomColorMaterial(), radius: 0.03, height: 0.09),
      rotation: vector.Vector4(0.04, 0.1, 0.4, -0.5),
      position: vector.Vector3(-0.1, -0.1, -0.5));

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

  ARKitNode _createText() {
    final text = ARKitText(
      text: 'Fold here',
      extrusionDepth: 1,
      materials: [
        ARKitMaterial(
          diffuse: ARKitMaterialProperty.color(Colors.blue),
        )
      ],
    );
    return ARKitNode(
      geometry: text,
      position: vector.Vector3(-0.3, 0.3, -1.4),
      scale: vector.Vector3(0.02, 0.02, 0.02),
    );
  }

  final _rnd = math.Random();
  List<ARKitMaterial> _createRandomColorMaterial() {
    return [
      ARKitMaterial(
        lightingModelName: ARKitLightingModel.physicallyBased,
        metalness: ARKitMaterialProperty.value(10),
        roughness: ARKitMaterialProperty.value(_rnd.nextDouble()),
        diffuse: ARKitMaterialProperty.color(
          Color((0xFFFFFF).toInt() << 0).withOpacity(1.0),
        ),
      )
    ];
  }

  void _handleAddAnchor(ARKitAnchor anchor) {
    if (!(anchor is ARKitPlaneAnchor)) {
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
      geometry: plane,
      position: vector.Vector3(anchor.center.x, 0, anchor.center.z),
      rotation: vector.Vector4(1, 0, 0, -math.pi / 2),
    );
    controller.add(node!, parentNodeName: anchor.nodeName);
  }
}