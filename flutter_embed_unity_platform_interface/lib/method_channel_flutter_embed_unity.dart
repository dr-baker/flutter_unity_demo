
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_embed_unity_platform_interface/flutter_embed_constants.dart';

import 'flutter_embed_unity_platform_interface.dart';

const MethodChannel _channel = MethodChannel(FlutterEmbedConstants.uniqueIdentifier);

/// An implementation of [FlutterEmbedUnityPlatform] that uses method channels.
class MethodChannelFlutterEmbedUnity extends FlutterEmbedUnityPlatform {

  List<Function(String)> _listeners = [];

  MethodChannelFlutterEmbedUnity() {
    _channel.setMethodCallHandler(_methodCallHandler);
  }

  @override
  void sendToUnity(String gameObjectName, String methodName, String data) {
    _channel.invokeMethod(
      FlutterEmbedConstants.methodNameSendToUnity,
      [gameObjectName, methodName, data],
    );
  }

  @override
  void orientationChanged() {
    _channel.invokeMethod(
      FlutterEmbedConstants.methodNameOrientationChanged,
    );
  }

  @override
  void addUnityMessageListener(Function(String) listener) {
    _listeners.add(listener);
  }

  @override
  void removeUnityMessageListener(Function(String) listener) {
    _listeners.remove(listener);
  }

  Future<dynamic> _methodCallHandler(MethodCall call) async {
    switch(call.method) {
      case FlutterEmbedConstants.methodNameSendToFlutter: {
        for(var listener in _listeners) {
          listener(call.arguments.toString());
        }
      }
      default: {
        throw UnimplementedError();
      }
    }
  }
}
