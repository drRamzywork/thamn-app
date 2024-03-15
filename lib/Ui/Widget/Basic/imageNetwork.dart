part of widget;

class ImageNetworkX extends StatelessWidget {
  const ImageNetworkX({
    super.key,
    required this.imageUrl,
    this.color,
    this.height,
    this.width,
    this.isFile = false,
    this.fit = BoxFit.cover,
  });
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final bool isFile;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    if(imageUrl.isEmpty){
      return  SizedBox(
        width: width,
        height: height,
        child: Padding(padding: const EdgeInsets.all(22),child: Image(image: AssetImage(context.isDarkMode?ImageX.logoWhite:ImageX.logoColor),opacity: const AlwaysStoppedAnimation(.8),)),
      );
    }else if (isFile) {
      return Image.file(
            File(imageUrl),
            height: height,
            width: width,
            fit: fit,color: color,
            errorBuilder: (context, error, stackTrace) =>
                SizedBox(
                    width: width,
                    height: height,
                    child: Padding(padding: const EdgeInsets.all(22),child: Image(image: AssetImage(context.isDarkMode?ImageX.logoWhite:ImageX.logoColor),opacity: const AlwaysStoppedAnimation(.8),)),
                ),
          );
    } else {
      return Image.network(
            imageUrl,
            height: height,
            width: width,
            fit: fit,
            color:color,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            width: width,
            height: height,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            ),
          );
        },
            errorBuilder: (context, error, stackTrace) =>
                SizedBox(
                    width: width,
                    height: height,
                    child: Padding(padding: const EdgeInsets.all(22),child: Image(image: AssetImage(context.isDarkMode?ImageX.logoWhite:ImageX.logoColor),opacity: const AlwaysStoppedAnimation(.8),)),
                ),
          );
    }
  }
}
