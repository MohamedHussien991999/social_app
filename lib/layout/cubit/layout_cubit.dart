// ignore_for_file: avoid_print

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layout/cubit/states_layout.dart';
import 'package:social_app/models/post_model.dart';
import '../../models/message_model.dart';
import '../../models/user_model.dart';
import '../../modules/chats/chat_screen.dart';
import '../../modules/feeds/feeds_screen.dart';
import '../../modules/new_posts/new_posts_screen.dart';
import '../../modules/settings/settings_screen.dart';
import '../../shared/components/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class LayoutCubit extends Cubit<LayoutStates> {
  LayoutCubit() : super(LayoutInitialState());

  static LayoutCubit get(context) => BlocProvider.of(context);
  String commentTransfer = "";
  int currentIndex = 0;

  List<Widget> screens = [
    const FeedsScreen(),
    const ChatScreen(),
    NewPostsScreen(),
    const SettingsScreen(),
  ];

  List<String> titles = [
    'Home',
    'Chats',
    'Post',
    'Settings',
  ];
  void changeBottomNavBar(int index) {
    if (index == 0) {
      getPosts();
      currentIndex = index;
      emit(ChangeBottomNavBarState());
    }
    if (index == 1) {
      currentIndex = index;
      getUsers();
      emit(ChangeBottomNavBarState());
    } else if (index == 2) {
      emit(NewPostState());
    } else {
      currentIndex = index;
      getUserData();
      emit(ChangeBottomNavBarState());
    }
  }

  UserModel? userModel;
  void getUserData() {
    emit(GetUserLoadingState());
    FirebaseFirestore.instance.collection('Users').doc(uId).get().then((value) {
      userModel = UserModel.fromJson(value.data()!);
      emit(GetUserSuccessState());
    }).catchError((error) {
      emit(GetUserErrorState(error.toString()));
    });
  }

  File? profileImage;

  ImagePicker picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(ProfileImagePickedSuccessState());
    } else {
      emit(ProfileImagePickedErrorState());
    }
  }

  File? coverImage;

  void getCoverImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(CoverImagePickedSuccessState());
    } else {
      emit(CoverImagePickedErrorState(pickedFile.toString()));
    }
  }

  String? urlProfileImage;

  Future<void> uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
  }) async {
    emit(UserUpdateLoadingState());
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('Users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) async {
        urlProfileImage = value;
        await updateUserData(name: name, phone: phone, bio: bio, image: value);

        print("URL PROFILE IMAGE $urlProfileImage");
        emit(UploadProfileImageSuccessState());
      }).catchError((error) {
        emit(UploadProfileImageErrorState(error.toString()));
      });
    }).catchError((error) {
      print("ERROR AT UPLOAD PROFILE IMAGE ${error.toString()}");
      emit(UploadProfileImageErrorState(error.toString()));
    });
  }

  String? urlCoverImage;
  Future<void> uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
  }) async {
    emit(UserUpdateLoadingState());
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('Users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) async {
        urlCoverImage = value;
        await updateUserData(name: name, phone: phone, bio: bio, cover: value);
        print("URL COVER IMAGE $urlCoverImage");
        emit(UploadCoverImageSuccessState());
      }).catchError((error) {
        emit(UploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(UploadCoverImageErrorState());
    });
  }

  Future<void> updateUserData({
    required String name,
    required String phone,
    required String bio,
    String? cover,
    String? image,
  }) async {
    emit(UserUpdateLoadingState());

    UserModel modelUpdate = UserModel(
      name: name,
      phone: phone,
      bio: bio,
      email: userModel!.email,
      uId: userModel!.uId,
      isEmailVerified: false,
      cover: cover ?? userModel!.cover,
      image: image ?? userModel!.image,
    );

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(uId)
        .update(modelUpdate.toMap())
        .then((value) {
      print("UPDATE USER DATA SUCCESS");
      getUserData();
      emit(UserUpdateSuccessState());
    }).catchError((error) {
      emit(UserUpdateErrorState(error.toString()));
    });
  }

  File? postImage;

  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(PostImagePickedSuccessState());
    } else {
      emit(PostImagePickedErrorState(pickedFile.toString()));
    }
  }

  List<TextEditingController> commentControllers = [];
  List<Color> sendIconColors = [];
  void changeTextField() {
    emit(ChangeTextFieldState());
  }

  void createPost({
    required String dateTime,
    required String text,
    String? postImage,
  }) {
    emit(CreatePostLoadingState());

    PostModel model = PostModel(
      name: userModel!.name,
      image: userModel!.image,
      uId: userModel!.uId,
      dateTime: dateTime,
      text: text,
      postImage: postImage ?? '',
    );

    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      emit(CreatePostSuccessState());
    }).catchError((error) {
      emit(CreatePostErrorState());
    });
  }

  void uploadPostImage({
    required String dateTime,
    required String text,
  }) {
    emit(CreatePostLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        createPost(
          text: text,
          dateTime: dateTime,
          postImage: value,
        );
      }).catchError((error) {
        emit(CreatePostErrorState());
        print("-------------------");
        print(error.toString());
        print("-------------------");
      });
    }).catchError((error) {
      emit(CreatePostErrorState());
      print("-------------------");
      print(error.toString());
      print("-------------------");
    });
  }

  void removePostImage() {
    postImage = null;
    emit(RemovePostImageState());
  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];
  List<int> comments = [];
  Future<void> getPosts() async {
    emit(GetPostsLoadingState());
    posts = [];
    postsId = [];
    likes = [];
    comments = [];
    commentControllers = [];
    sendIconColors = [];

    final postsQuery = await FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime',
            descending: true) // Order by 'timestamp' in descending order
        .get();

    final futures = <Future>[];

    for (var element in postsQuery.docs) {
      final likesFuture = element.reference.collection('Likes').get();
      final commentsFuture = element.reference.collection('Comments').get();

      futures.add(likesFuture);
      futures.add(commentsFuture);

      postsId.add(element.id);
      PostModel post = PostModel.fromJson(element.data());
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(post.uId)
          .get()
          .then((value) {
        post.name = value.data()!['name'];
        post.image = value.data()!['image'];
        posts.add(post);
      });
    }

    final results = await Future.wait(futures);

    for (var i = 0; i < results.length; i += 2) {
      final likesResult = results[i] as QuerySnapshot<Map<String, dynamic>>;
      final commentsResult =
          results[i + 1] as QuerySnapshot<Map<String, dynamic>>;

      likes.add(likesResult.docs.length);
      comments.add(commentsResult.docs.length);
    }

    emit(GetPostsSuccessState());
  }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("Likes")
        .doc(userModel!.uId)
        .set({'like': true}).then((value) {
      getPosts();
      emit(LikePostSuccessState());
    }).catchError((error) {
      emit(LikePostErrorState(error.toString()));
    });
  }

  void commentButtonChanged() {
    emit(CommentButtonChangedState());
  }

  void commentPost({required String comment, required String postId}) {
    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("Comments")
        .doc(userModel!.uId)
        .set({'comment': comment}).then((value) {
      commentTransfer = " Write Comment ... ";
      emit(CommentPostSuccessState());
    }).catchError((error) {
      emit(CommentPostErrorState(error.toString()));
    });
  }

  List<UserModel> users = [];

  void getUsers() {
    users = [];
    if (users.isEmpty) {
      FirebaseFirestore.instance.collection('Users').get().then((value) {
        for (var element in value.docs) {
          if (element.data()['uId'] != userModel?.uId) {
            print("${element.data()['uId']}");
            print("${userModel?.uId}");
            users.add(UserModel.fromJson(element.data()));
          }
        }
        emit(GetAllUsersSuccessState());
      }).catchError((error) {
        emit(GetAllUsersErrorState(error.toString()));
      });
    }
  }

  Future<int> getMessageCount(String receiverId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("Users")
        .doc(userModel!.uId)
        .collection("Chats")
        .doc(receiverId)
        .collection("messages")
        .get();

    int messageCount = querySnapshot.size;
    return messageCount;
  }

  Future<void> sendMessage({
    required String receiverId,
    required String dateTime,
    required String text,
    String? imageUrl,
  }) async {
    int messageLength = await getMessageCount(receiverId);
    MessageModel modelMessage = MessageModel(
      senderId: userModel!.uId,
      receiverId: receiverId,
      dateTime: dateTime,
      imageUrl: imageUrl ?? "",
      text: text,
      arrange: (messageLength + 1),
    );
    //set my chats
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(userModel!.uId)
        .collection("Chats")
        .doc(receiverId)
        .collection("messages")
        .add(modelMessage.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      print(" ERROR At Me  ${error.toString()}");
      emit(SendMessageErrorState());
    });

    //set receiver chats

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(receiverId)
        .collection("Chats")
        .doc(userModel!.uId)
        .collection("messages")
        .add(modelMessage.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      print(" ERROR At Receiver  ${error.toString()}");
      emit(SendMessageErrorState());
    });
  }

  List<MessageModel> messages = [];
  void getMessages({
    required String? receiverId,
  }) {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(userModel!.uId)
        .collection("Chats")
        .doc(receiverId)
        .collection("messages")
        .orderBy("arrange", descending: false)
        .snapshots()
        .listen((event) {
      messages = [];
      for (var element in event.docs) {
        messages.add(MessageModel.fromJson(element.data()));
      }
      emit(GetMessageSuccessState());
    });
  }

  void uploadImageMessage({
    required String receiverId,
    required String dateTime,
    required String text,
  }) {
    emit(UserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'messagesImages/${Uri.file(chatImage!.path).pathSegments.last}')
        .putFile(chatImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        sendMessage(
          text: text,
          dateTime: dateTime,
          receiverId: receiverId,
          imageUrl: value,
        );
      }).catchError((error) {
        emit(UploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(UploadCoverImageErrorState());
    });
  }

  File? chatImage;

  Future<void> getChatImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      chatImage = File(pickedFile.path);
      emit(ChatImagePickedSuccessState());
    } else {
      emit(ChatImagePickedErrorState());
    }
  }

  void removeChatImage() {
    chatImage = null;
    emit(RemoveChatImageState());
  }
}
