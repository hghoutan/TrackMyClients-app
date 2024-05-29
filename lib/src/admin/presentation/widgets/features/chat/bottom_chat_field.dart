import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trackmyclients_app/src/client/domain/controllers/client_chat_controller.dart';
import 'package:trackmyclients_app/src/utils/utils.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';

import '../../../../../utils/enums/message_enum.dart';
import '../../../../domain/controllers/chat_controller.dart';
import '../../../../domain/repositories/firebase_notification_repository.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String recieverUserId;
  final bool isFromClientSide;
  const BottomChatField(
      {super.key, required this.recieverUserId, this.isFromClientSide = false});

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  final TextEditingController _messageController = TextEditingController();
  final notificationsService = NotificationsService();

  bool isShowSendButton = false;

  Codec _codec = Codec.aacMP4;
  String _mPath = '';
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mRecorderIsInited = false;
  bool isRecording = false;

  bool isShowEmojiContainer = false;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    requestRecordingPermissions();
    openTheRecorder().then((value) {
      setState(() {
        _mRecorderIsInited = true;
      });
    });
    notificationsService.getReceiverToken(widget.recieverUserId,
        isClientSide: widget.isFromClientSide);
  }

  Future<void> openTheRecorder() async {
    await _mRecorder!.openRecorder();
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
    _mRecorderIsInited = true;
  }

  void record(String path) {
    _mRecorder!
        .startRecorder(
      toFile: path,
      codec: _codec,
      audioSource: AudioSource.microphone,
    )
        .then((value) {
      setState(() {});
    });
  }

  void stopRecorder(String path) async {
    await _mRecorder!.stopRecorder();
    sendFileMessage(File(path), MessageEnum.audio);
  }

  Future<bool> requestRecordingPermissions() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission not allowed!');
    }
    return true;
  }

  void sendTextMessage() async {
    if (isShowSendButton && _messageController.text.isNotEmpty) {
      if (widget.isFromClientSide) {
        ref.read(clientChatControllerProvider).sendTextMessage(
              context,
              _messageController.text.trim(),
              widget.recieverUserId,
            );
      } else {
        ref.read(chatControllerProvider).sendTextMessage(
              context,
              _messageController.text.trim(),
              widget.recieverUserId,
            );
      }

      await notificationsService.sendNotification(
        body: _messageController.text.trim(),
      );
      setState(() {
        _messageController.text = '';
      });
    } else {
      if (!_mRecorderIsInited) {
        return;
      }
      var tempDir = await getTemporaryDirectory();
      _mPath = '${tempDir.path}/Track_my_clients.mp4';
      if (_mRecorder!.isStopped) {
        record(_mPath);
      } else {
        stopRecorder(_mPath);
      }
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void sendFileMessage(
    File file,
    MessageEnum messageEnum,
  ) {
    if (widget.isFromClientSide) {
      ref.read(clientChatControllerProvider).sendFileMessage(
            context,
            file,
            widget.recieverUserId,
            messageEnum,
          );
    } else {
      ref.read(chatControllerProvider).sendFileMessage(
            context,
            file,
            widget.recieverUserId,
            messageEnum,
          );
    }
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();

    _mRecorder!.closeRecorder();
    _mRecorder = null;
    // _soundRecorder!.closeRecorder();
    // isRecorderInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 20.0),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  focusNode: focusNode,
                  controller: _messageController,
                  onChanged: (val) {
                    if (val.isNotEmpty) {
                      setState(() {
                        isShowSendButton = true;
                      });
                    } else {
                      setState(() {
                        isShowSendButton = false;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(
                        left: 12.0,
                      ),
                      child: SizedBox(
                        child: IconButton(
                            onPressed: toggleEmojiKeyboardContainer,
                            icon: const FaIcon(
                              FontAwesomeIcons.solidFaceSmile,
                            )),
                      ),
                    ),
                    suffixIcon: SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: selectImage,
                              icon: const FaIcon(
                                FontAwesomeIcons.camera,
                              )),
                          IconButton(
                              onPressed: selectVideo,
                              icon: const FaIcon(
                                FontAwesomeIcons.paperclip,
                              )),
                        ],
                      ),
                    ),
                    hintText: 'Type a message!',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 8,
                  right: 2,
                  left: 2,
                ),
                child: GestureDetector(
                  onTap: sendTextMessage,
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    radius: 25,
                    child: Icon(
                      isShowSendButton
                          ? FontAwesomeIcons.paperPlane
                          : isRecording
                              ? FontAwesomeIcons.xmark
                              : FontAwesomeIcons.microphone,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        isShowEmojiContainer
            ? SizedBox(
                height: 310,
                child: EmojiPicker(
                  onEmojiSelected: ((category, emoji) {
                    setState(() {
                      _messageController.text =
                          _messageController.text + emoji.emoji;
                    });
                    if (!isShowSendButton) {
                      setState(() {
                        isShowSendButton = true;
                      });
                    }
                  }),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
