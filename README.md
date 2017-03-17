# DMProfileView
> A Custom View Object to Show Social Media Profile Image.

DMProfileView is a custom view to present the profile image gathered from the any of the social media channels of the user with provisions to show the following elements:
  - The user's profile image
  - Logo of the social media channel from which the image is taken
  - Badge to show notification count

Profile image and channel logo should be set as UIImage. If profile image is not available, the profile name can be input which will be used to make thumbnail instead. Badge and channel views are optional which can be set and configured if needed. The display mode can be either square shaped or circular which can be set separately profile, channel and badge views.

# Symbols
* Initializers
  - init(frame: CGRect)

* Create and Customize View
    - setProfileName(_ name: String)
    - setProfileImage(_ image: UIImage)
    - setBorder(with width: CGFloat, and color: UIColor)
    - setProfileShape(_ shape: ViewShape)
    - setBackground(with colors: [UIColor])
    - addBadgeView(at position: BadgePosition, initialCount: Int)
    - removeBadgeView()
    - setBadgeBackground(with colors: [UIColor])
    - setBadgeBorder(with width: CGFloat, and color: UIColor)
    - setBadgeShape(_ shape: ViewShape)
    - setBadgeCount(_ count: Int)
    - addChannelView(at position: ChannelPosition, image: UIImage)
    - removeChannelView()
    - setChannelImage(_ image: UIImage)
    - setChannelBorder(with width: CGFloat, and color: UIColor)
    - setChannelShape(_ shape: ViewShape)
    - setChannelPosition(_ position: ChannelPosition)

* View Attributes
    - badgeSizeScale: CGFloat (size proportion of badge to the main view, default = 0.25)
    - channelSizeScale: CGFloat (size proportion of channel to the main view, default = 0.25)   
    - profileFont: UIFont?
    - profileFontColor: UIColor? (default = UIColor.black)
    - badgeFont: UIFont?
    - badgeFontColor: UIColor? (default = UIColor.black)

* Enums
    - ViewShape { .square, .circle }
    - BadgePosition { .topLeft, .topRight }
    - ChannelPosition { .bottomLeft, .bottomRight }
    - SubViewType { .badge, .channel }
    - 
