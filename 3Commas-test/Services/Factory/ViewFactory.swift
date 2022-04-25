import UIKit

enum ViewFactory {
    static func makePostView(post: Photo) -> IPostView {
        return PostView(
            heightOfphoto: post.heightM,
            widtOfphoto: post.widthM,
            title: post.title
        )
    }
}
