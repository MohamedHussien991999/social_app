abstract class LayoutStates {}

class LayoutInitialState extends LayoutStates {}

//GetUser
class GetUserSuccessState extends LayoutStates {}

class GetUserLoadingState extends LayoutStates {}

class GetUserErrorState extends LayoutStates {
  final String error;

  GetUserErrorState(this.error);
}

//GetAllUser
class GetAllUsersSuccessState extends LayoutStates {}

class GetAllUsersLoadingState extends LayoutStates {}

class GetAllUsersErrorState extends LayoutStates {
  final String error;

  GetAllUsersErrorState(this.error);
}

class ChangeBottomNavBarState extends LayoutStates {}

class NewPostState extends LayoutStates {}

//pick Profile Image
class ProfileImagePickedSuccessState extends LayoutStates {}

class ProfileImagePickedErrorState extends LayoutStates {}

//pick Cover Image
class CoverImagePickedSuccessState extends LayoutStates {}

class CoverImagePickedErrorState extends LayoutStates {
  final String error;

  CoverImagePickedErrorState(this.error);
}

//Upload Profile Image

class UploadProfileImageSuccessState extends LayoutStates {}

class UploadProfileImageErrorState extends LayoutStates {
  final String error;

  UploadProfileImageErrorState(this.error);
}

//Upload Profile Image

class UploadCoverImageSuccessState extends LayoutStates {}

class UploadCoverImageErrorState extends LayoutStates {}

//Update User Data

class UserUpdateLoadingState extends LayoutStates {}

class UserUpdateSuccessState extends LayoutStates {}

class UserUpdateErrorState extends LayoutStates {
  final String error;

  UserUpdateErrorState(this.error);
}
//change text field

class ChangeTextFieldState extends LayoutStates {}
// PostImage

class PostImagePickedSuccessState extends LayoutStates {}

class PostImagePickedErrorState extends LayoutStates {
  final String error;

  PostImagePickedErrorState(this.error);
}

class RemovePostImageState extends LayoutStates {}

//create Post

class CreatePostLoadingState extends LayoutStates {}

class CreatePostSuccessState extends LayoutStates {}

class CreatePostErrorState extends LayoutStates {}

//get Posts
class GetPostsLoadingState extends LayoutStates {}

class GetPostsSuccessState extends LayoutStates {}

class GetPostsErrorState extends LayoutStates {
  final String error;

  GetPostsErrorState(this.error);
}

//get Likes
class GetPostsLikesSuccessState extends LayoutStates {}

class GetPostsLikesErrorState extends LayoutStates {
  final String error;

  GetPostsLikesErrorState(this.error);
}

//get Comments
class GetPostsCommentsSuccessState extends LayoutStates {}

class GetPostsCommentsErrorState extends LayoutStates {
  final String error;

  GetPostsCommentsErrorState(this.error);
}

//like Post
class LikePostSuccessState extends LayoutStates {}

class LikePostErrorState extends LayoutStates {
  final String error;

  LikePostErrorState(this.error);
}

class CommentButtonChangedState extends LayoutStates {}

//Comment Post
class CommentPostSuccessState extends LayoutStates {}

class CommentPostErrorState extends LayoutStates {
  final String error;

  CommentPostErrorState(this.error);
}
//Send Message

class SendMessageSuccessState extends LayoutStates {}

class SendMessageErrorState extends LayoutStates {}
//Get Message

class GetMessageSuccessState extends LayoutStates {}

class GetMessageErrorState extends LayoutStates {}

//Get Chat Image

class ChatImagePickedSuccessState extends LayoutStates {}

class ChatImagePickedErrorState extends LayoutStates {}

class RemoveChatImageState extends LayoutStates {}
