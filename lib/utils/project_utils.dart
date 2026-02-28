class ProjectUtils {
  final String image;
  final String title;
  final String subtitle;
  final String? androidLink;
  final String? iosLink;
  final String? webLink;

  ProjectUtils({
    required this.image,
    required this.title,
    required this.subtitle,
    this.androidLink,
    this.iosLink,
    this.webLink,
  });
}

List<ProjectUtils> hobbyProjectUtils = [
  ProjectUtils(
    image: 'assets/project/Insta.png',
    title: 'Instagram Lite',
    subtitle:
        'This is an social media app , basically it is lite version of Instagram you can explore all your insta feed easily with less phone storage and less usage of ram',
    androidLink:
        'https://play.google.com/store/apps/details?id=com.instagram.lite&hl=en',
    iosLink: 'https://apps.apple.com/us/app/instagram/id389801252',
    webLink: 'https://www.instagram.com/',
  ),

  ProjectUtils(
    image: 'assets/project/Likee.png',
    title: 'Likee',
    subtitle:
        'This is an social media app, the use of this app is for short video and live stram for gaining gifts',
    androidLink:
        'https://play.google.com/store/apps/details?id=video.like&hl=en',
    iosLink: 'https://apps.apple.com/us/app/likee-video-live-chat/id1251790681',
  ),
  ProjectUtils(
    image: 'assets/project/wallet.png',
    title: 'Wallet',
    subtitle:
        'Google Wallet gives you fast, secure access to your everyday essentials. Tap to pay everywhere Google Pay is accepted, board a flight, go to a movie, and more all with just your phone. Keep everything protected in one place, no matter where you go.',
    androidLink:
        'https://play.google.com/store/apps/details?id=com.google.android.apps.walletnfcrel&hl=en',
  ),
];

List<ProjectUtils> workProjects = [
  ProjectUtils(
    image: 'assets/project/Insta.png',
    title: 'Instagram Lite',
    subtitle:
        'This is an social media app , basically it is lite version of Instagram you can explore all your insta feed easily with less phone storage and less usage of ram',
    androidLink:
        'https://play.google.com/store/apps/details?id=com.instagram.lite&hl=en',
    iosLink: 'https://apps.apple.com/us/app/instagram/id389801252',
    webLink: 'https://www.instagram.com/',
  ),

  ProjectUtils(
    image: 'assets/project/Likee.png',
    title: 'Likee',
    subtitle:
        'This is an social media app, the use of this app is for short video and live stram for gaining gifts',
    androidLink:
        'https://play.google.com/store/apps/details?id=video.like&hl=en',
    iosLink: 'https://apps.apple.com/us/app/likee-video-live-chat/id1251790681',
  ),
  ProjectUtils(
    image: 'assets/project/wallet.png',
    title: 'Wallet',
    subtitle:
        'Google Wallet gives you fast, secure access to your everyday essentials. Tap to pay everywhere Google Pay is accepted, board a flight, go to a movie, and more all with just your phone. Keep everything protected in one place, no matter where you go.',
    androidLink:
        'https://play.google.com/store/apps/details?id=com.google.android.apps.walletnfcrel&hl=en',
  ),
];
