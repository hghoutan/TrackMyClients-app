import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trackmyclients_app/src/domain/controllers/auth_controller.dart';
import 'package:trackmyclients_app/src/domain/controllers/client_controller.dart';
import 'package:trackmyclients_app/src/domain/models/client.dart';
import 'package:trackmyclients_app/src/domain/models/user.dart';

import '../../../../info.dart';
import '../../widgets/features/chat/chat_list.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final ClientData? client;
  const ChatScreen({
    this.client,
    super.key
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();
  // FlutterSoundRecorder? _soundRecorder;
  bool isRecorderInit = false;
  bool isShowEmojiContainer = false;
  bool isRecording = false;
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    // _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  void openAudio() async {
    // final status = await Permission.microphone.request();
    // if (status != PermissionStatus.granted) {
    //   throw RecordingPermissionException('Mic permission not allowed!');
    // }
    // await _soundRecorder!.openRecorder();
    // isRecorderInit = true;
  }

  void sendTextMessage() async {
    // if (isShowSendButton) {
    //   ref.read(chatControllerProvider).sendTextMessage(
    //         context,
    //         _messageController.text.trim(),
    //         widget.recieverUserId,
    //         widget.isGroupChat,
    //       );
    //   setState(() {
    //     _messageController.text = '';
    //   });
    // } else {
    //   var tempDir = await getTemporaryDirectory();
    //   var path = '${tempDir.path}/flutter_sound.aac';
    //   if (!isRecorderInit) {
    //     return;
    //   }
    //   if (isRecording) {
    //     await _soundRecorder!.stopRecorder();
    //     sendFileMessage(File(path), MessageEnum.audio);
    //   } else {
    //     await _soundRecorder!.startRecorder(
    //       toFile: path,
    //     );
    //   }

    //   setState(() {
    //     isRecording = !isRecording;
    //   });
    // }
  }

  void sendFileMessage(
      // File file,
      // MessageEnum messageEnum,
      ) {
    // ref.read(chatControllerProvider).sendFileMessage(
    //       context,
    //       file,
    //       widget.recieverUserId,
    //       messageEnum,
    //       widget.isGroupChat,
    //     );
  }

  void selectImage() async {
    // File? image = await pickImageFromGallery(context);
    // if (image != null) {
    //   sendFileMessage(image, MessageEnum.image);
    // }
  }

  void selectVideo() async {
    // File? video = await pickVideoFromGallery(context);
    // if (video != null) {
    //   sendFileMessage(video, MessageEnum.video);
    // }
  }

  void selectGIF() async {
    // final gif = await pickGIF(context);
    // if (gif != null) {
    //   ref.read(chatControllerProvider).sendGIFMessage(
    //         context,
    //         gif.url,
    //         widget.recieverUserId,
    //         widget.isGroupChat,
    //       );
    // }
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
    // _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: StreamBuilder<ClientData>(
          stream: ref.read(clientControllerProvider).clientDataById(widget.client!.id!),
          builder: (context, snapshot) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.network(
                    snapshot.data?.profilePic! ?? info[0]['profilePic'].toString(),
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data?.name! ?? info[0]['name'].toString(),
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                     snapshot.data?.isOnline! == null ? Row(
                        children: [
                          SizedBox(
                            height: 9,
                            width: 9,
                            child: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.tertiary,
                              radius: 33,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Online',
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                        ],
                      ) : 
                      snapshot.data!.isOnline! ?  Row(
                        children: [
                          SizedBox(
                            height: 9,
                            width: 9,
                            child: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.tertiary,
                              radius: 33,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Online',
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                        ],
                      ) : 
                      Text(
                        'last time check in 16 apr',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const FaIcon(FontAwesomeIcons.video),
          ),
          IconButton(
            onPressed: () {},
            icon: const FaIcon(FontAwesomeIcons.phone),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          const Expanded(
            child: ChatList(),
          ),
          Column(
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
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        radius: 25,
                        child: GestureDetector(
                          onTap: sendTextMessage,
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
          ),
        ],
      ),
    );
  }
}
