//
//  DMProfileView.swift
//  DisplayPictureView
//
//  Created by Denny Mathew on 18/03/17.
//  Copyright © 2017 Denny Mathew. All rights reserved.
//

import Foundation
import UIKit

//MARK:- Enums

enum ViewShape {
    case square
    case circle
}

enum ChannelPosition {
    case bottomLeft
    case bottomRight
}

enum BadgePosition {
    case topLeft
    case topRight
}

internal enum SubViewType {
    case badge
    case channel
}

//MARK:- Class: Base View

class DMBaseView: UIView {
    
    /* Set View Shape */
    func setShape(_ shape: ViewShape) {
        if shape == .circle {
            layer.cornerRadius = min(frame.size.width / 2.0, frame.size.height / 2.0)
        }
            
        else {
            layer.cornerRadius = 0.0
        }
    }
    
    /* Add Border */
    func setBorder(with width: CGFloat, color: UIColor) {
        
        if width > 0 {
            layer.borderWidth = width
            layer.borderColor = color.cgColor
        }
    }
    
    func setBackground(with colors:[UIColor]){
        
        let bgColors: [CGColor] = colors.map { return $0.cgColor }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = bgColors
        layer.addSublayer(gradientLayer)
    }
}

//MARK:- Class: Base ImageView

fileprivate class DMImageView: DMBaseView {
    
    private var imageView: UIImageView!
    var image: UIImage? = nil {
        didSet {
            if let imageView = self.imageView {
                imageView.image = image
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        imageView = UIImageView(frame: self.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.image = image != nil ? image : nil
        addSubview(imageView)
    }
    
    func setImage(with image: UIImage) {
        imageView.image = image
    }
    
    func setThumbNail(for name: String, frame: CGRect, font: UIFont?, textColor: UIColor?, backgroundColors: [UIColor]?) {
        
        /* Create Label With Text */
        let label = UILabel(frame: frame)
        label.text = self.getInitials(from: name)
        label.textAlignment = .center
        label.font = label.font.withSize(200.0)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byWordWrapping
        let maximumLabelSize = CGSize(width: label.frame.size.width * 0.8, height: CGFloat.greatestFiniteMagnitude)
        let expectSize = label.sizeThatFits(maximumLabelSize)
        label.frame = CGRect(origin: CGPoint(x: label.frame.midX, y: label.frame.midY), size: CGSize(width: expectSize.width * 1.5, height: expectSize.height * 1.5))
        
        if font != nil {
            label.font = font
        }
        
        if textColor != nil {
            label.textColor = textColor
        }
        
        // Create a uiview and add the label as subview. Adding sublayer to label hides it's text
        let backgroundView = DMBaseView(frame: label.frame)
        backgroundView.backgroundColor = UIColor.white
        if backgroundColors != nil {
            
            if backgroundColors?.count == 1{
                backgroundView.backgroundColor = backgroundColors?.first
            }
                
            else {
                backgroundView.setBackground(with: backgroundColors!)
            }
        }
        
        backgroundView.addSubview(label)
        label.frame = backgroundView.bounds
        
        /* Create Image with Label */
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
        backgroundView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        imageView.image = image
    }
    
    /* Create Initials from Full Name */
    internal func getInitials(from name: String) -> String {
        
        var profileNameArr = name.components(separatedBy: " ")
        var initials = ""
        
        if profileNameArr.count > 1 {
            profileNameArr = [profileNameArr.first!, profileNameArr.last!]
        }
        
        for name in profileNameArr {
            initials = initials + String(name.characters.first!)
        }
        
        return initials
    }
}

//MARK:- Class: Sub Views

fileprivate class DMSubView: DMBaseView {
    
    //MARK:- Properties
    
    /* Common for Both the Types*/
    var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    var shape: ViewShape = .square {
        didSet {
            setShape(shape)
        }
    }
    
    /* Sub View Type - Badge */
    private var countLabel: UILabel!
    
    var count: Int = 0 {
        didSet {
            countLabel.text = String(count)
        }
    }
    
    var font: UIFont? {
        didSet {
            countLabel.font = font
        }
    }
    
    var textColor: UIColor = .black {
        didSet {
            countLabel.textColor = textColor
        }
    }
    
    var backgroundColors: [UIColor] = [.white] {
        didSet {
            setBackground(with: backgroundColors)
        }
    }
    
    /* Sub View Type - Channel */
    var imageView: UIImageView!
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    //MARK:- Inits
    
    convenience init() {
        self.init()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK:- Internal Methods
    
    private func setupBadgeView() {
        
        /* Setup View */
        contentMode = .scaleAspectFill
        clipsToBounds = true
        contentMode = .scaleAspectFill
        setBorder(with: borderWidth, color: borderColor)
        setShape(shape)
        setBackground(with: backgroundColors)
        
        /* Setup Count Label */
        if countLabel != nil {
            countLabel.removeFromSuperview()
        }
        
        countLabel = UILabel(frame: bounds)
        countLabel.text = String(count)
        countLabel.textColor = textColor
        countLabel.adjustsFontSizeToFitWidth = true
        countLabel.numberOfLines = 1
        countLabel.lineBreakMode = .byWordWrapping
        countLabel.textAlignment = .center
        
        if font != nil {
            countLabel.font = font
        }
            
        else {
            countLabel.font = countLabel.font.withSize(frame.width * 0.8)
        }
        
        addSubview(countLabel)
    }
    
    private func setupChannelView() {
        
        /* Setup View */
        contentMode = .scaleAspectFill
        clipsToBounds = true
        contentMode = .scaleAspectFill
        backgroundColor = .white
        
        /* Setup Image View */
        imageView = UIImageView(frame: bounds)
        imageView.contentMode = .scaleAspectFill
        setBorder(with: borderWidth, color: borderColor)
        setShape(shape)
        
        if let image = self.image {
            imageView.image = image
        }
        
        addSubview(imageView!)
    }
    
    //MARK:- Public Methods
    func type(_ type: SubViewType) {
        
        subviews.forEach({ $0.removeFromSuperview() })
        
        if type == .badge {
            setupBadgeView()
        }
            
        else {
            setupChannelView()
        }
    }
}

//MARK:- Main View

class DMProfileView: DMBaseView {
    
    //MARK:- Properties
    
    /* Outlets */
    private var imageView: DMImageView!
    private var badgeView: DMSubView!
    private var channelView: DMSubView!
    
    /* Customize View */
    private var profileName: String = ""
    private var profileImage: UIImage? = nil
    private var borderWidth: CGFloat = 0
    private var borderColor: UIColor = .clear
    private var profileBackgroundColors: [UIColor] = [.white]
    
    var badgeSizeScale: CGFloat = 0.25
    var channelSizeScale: CGFloat = 0.25
    
    var profileFont: UIFont? = nil
    var profileFontColor: UIColor? = nil
    var badgeFont: UIFont? = nil
    var badgeFontColor: UIColor? = nil
    
    //MARK:- Inits
    private func setupView () {
        
        /* Setup View */
        backgroundColor = .clear
        
        /* Setup Profile View */
        imageView = DMImageView(frame: bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        addSubview(imageView)
        
        /* Bring Badge and CHannel Views to Front */
        if badgeView != nil {
            bringSubview(toFront: badgeView)
        }
        
        if channelView != nil {
            bringSubview(toFront: channelView)
        }
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    //MARK:- Internal Methods
    
    private func getBadgeFrame(for position: BadgePosition) -> CGRect {
        
        //Set Bounds
        let width = frame.size.width * badgeSizeScale
        let xLeft = bounds.minX
        let xRight = bounds.maxX
        let yTop = bounds.minY
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        
        switch position {
        case .topLeft:
            x = xLeft
            y = yTop
            
        case .topRight:
            x = xRight - width
            y = yTop
        }
        
        return CGRect(x: x, y: y, width: width, height: width)
    }
    
    private func getChannelFrame(for position: ChannelPosition) -> CGRect {
        
        //Set Bound
        let width = frame.size.width * channelSizeScale
        let xLeft = bounds.minX
        let xRight = bounds.maxX
        let yBottom = bounds.maxY
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        
        switch position {
        case .bottomLeft:
            x = xLeft
            y = yBottom - width
            
        case .bottomRight:
            x = xRight - width
            y = yBottom - width
        }
        
        return CGRect(x: x, y: y, width: width, height: width)
    }
    
    //MARK:- Public Methods
    
    /* Public Methods for Profile View */
    func setProfileName(_ name: String) {
        profileImage = nil
        profileName = name
        imageView.setThumbNail(for: name, frame: imageView.bounds, font: profileFont, textColor: profileFontColor, backgroundColors: profileBackgroundColors)
    }
    
    func setProfileImage(_ image: UIImage) {
        profileImage = image
        imageView.image = image
    }
    
    func setBorder(with width: CGFloat, and color: UIColor) {
        self.borderWidth = width
        self.borderColor = color
        imageView.setBorder(with: borderWidth, color: borderColor)
    }
    
    func setProfileShape(_ shape: ViewShape) {
        imageView.setShape(shape)
    }
    
    override func setBackground(with colors: [UIColor]) {
        profileBackgroundColors = colors
        
        guard profileName != "", profileImage == nil else {
            return
        }
        
        setProfileName(profileName)
    }
    
    /* Public Methods for Badge View */
    func addBadgeView(at position: BadgePosition, initialCount: Int) {
        
        /* Create Badge View */
        badgeView = DMSubView(frame: getBadgeFrame(for: position))
        badgeView.type(.badge)
        badgeView.count = initialCount
        
        addSubview(badgeView)
    }
    
    func removeBadgeView() {
        if badgeView != nil {
            badgeView.removeFromSuperview()
            badgeView = nil
        }
    }
    
    func setBadgeBackground(with colors: [UIColor]) {
        
        if badgeView != nil{
            if colors.count == 1 {
                badgeView.backgroundColor = colors.first
            }
                
            else {
                badgeView.setBackground(with: colors)
            }
        }
    }
    
    func setBadgeBorder(with width: CGFloat, and color: UIColor) {
        
        if badgeView != nil {
            badgeView.borderWidth = width
            badgeView.borderColor = color
        }
    }
    
    func setBadgeShape(_ shape: ViewShape) {
        if badgeView != nil {
            badgeView.shape = shape
        }
    }
    
    func setBadgePosition(_ position: BadgePosition) {
        if badgeView != nil {
            badgeView.frame = getBadgeFrame(for: position)
            
        }
    }
    
    func setBadgeCount(_ count: Int) {
        
        if badgeView != nil {
            badgeView.count = count
        }
    }
    
    /* Public Methods for Channel View */
    func addChannelView(at position: ChannelPosition, image: UIImage) {
        channelView = DMSubView(frame: getChannelFrame(for: position))
        channelView.type(.channel)
        channelView.image = image
        addSubview(channelView)
    }
    
    func removeChannelView() {
        if channelView != nil {
            channelView.removeFromSuperview()
            channelView = nil
        }
    }
    
    func setChannelImage(_ image: UIImage) {
        channelView.image = image
    }
    
    func setChannelBorder(with width: CGFloat, and color: UIColor) {
        if channelView != nil {
            channelView.borderWidth = width
            channelView.borderColor = color
        }
    }
    
    func setChannelShape(_ shape: ViewShape) {
        if channelView != nil {
            channelView.shape = shape
        }
    }
    
    func setChannelPosition(_ position: ChannelPosition) {
        if channelView != nil {
            channelView.frame = getChannelFrame(for: position)
        }
    }
}
