import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agora_uikit/agora_uikit.dart';
import '../../../../config/agora_config.dart';
import '../../../domain/controllers/call_controller.dart';
import '../../../domain/models/call.dart';


class CallScreen extends ConsumerStatefulWidget {
  final String channelId;
  final Call call;
  const CallScreen({
    super.key,
    required this.channelId,
    required this.call,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  AgoraClient? client;
  String baseUrl = 'http://127.0.0.1:8080/';

  @override
  void initState() {
    super.initState();
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: AgoraConfig.appId,
        channelName: widget.channelId,
        tokenUrl: baseUrl,
      ),
    );
    initAgora();
  }

  void initAgora() async {
    await client!.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      client == null
          ? const CircularProgressIndicator()
          : 
        SafeArea(
              child: Stack(
                children: [
                  AgoraVideoViewer(client: client!),
                  AgoraVideoButtons(
                    client: client!,
                    disconnectButtonChild: IconButton(
                      onPressed: () async {
                        await client!.engine.leaveChannel();
                        ref.read(callControllerProvider).endCall(
                              widget.call.callerId,
                              widget.call.receiverId,
                              context,
                            );
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.call_end),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}