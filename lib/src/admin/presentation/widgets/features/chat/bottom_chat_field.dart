import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trackmyclients_app/src/client/domain/controllers/client_chat_controller.dart';
import 'package:trackmyclients_app/src/utils/utils.dart';

import '../../../../../utils/enums/message_enum.dart';
import '../../../../domain/controllers/chat_controller.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String recieverUserId;
  final bool isFromClientSide;
  const BottomChatField(
      {super.key, required this.recieverUserId, this.isFromClientSide = false
      });

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();
  FlutterSoundRecorder? _soundRecorder;
  bool isRecorderInit = false;
  bool isShowEmojiContainer = false;
  bool isRecording = false;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission not allowed!');
    }
    await _soundRecorder!.openRecorder();
    isRecorderInit = true;
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

      setState(() {
        _messageController.text = '';
      });
    }
    else {
      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/flutter_sound.aac';
      if (!isRecorderInit) {
        return;
      }
      if (isRecording) {
        await _soundRecorder!.stopRecorder();
        sendFileMessage(File(path), MessageEnum.audio);
      } else {
        await _soundRecorder!.startRecorder(
          toFile: path,
        );
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
    }
    else{
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
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
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
