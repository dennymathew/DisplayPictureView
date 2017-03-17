//
//  DMDisplayPictureViewController.swift
//  DisplayPictureView
//
//  Created by Denny Mathew on 18/03/17.
//  Copyright © 2017 Denny Mathew. All rights reserved.
//

import UIKit

class DMDisplayPictureViewController: UIViewController {
    
    @IBOutlet weak var profileView: DMProfileView!
    @IBOutlet weak var switchShape: UISwitch!
    @IBOutlet weak var switchChannel: UISwitch!
    @IBOutlet weak var swictchBadge: UISwitch!
    @IBOutlet weak var switchProfileType: UISwitch!
    @IBOutlet weak var switchChannelPosition: UISwitch!
    @IBOutlet weak var switchBadgePosition: UISwitch!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var btnBorderColor: UIButton!
    @IBOutlet weak var btnBackgroundColor: UIButton!
    
    var profiles = [TestProfile]()
    var currentProfile: TestProfile?
    var colors: [UIColor] = [.red, .orange, .yellow, .blue, .green, .darkGray, .white, .brown, .cyan, .lightGray]
    var profileIndex = 0
    var borderColorIndex = 0
    var backgroundColorIndex = 5
    
    var isChannelEnabled = false
    var isBadgeEnabled = false
    var shape: ViewShape = .square
    var channelPosition: ChannelPosition = .bottomRight
    var badgePosition: BadgePosition = .topRight
    var showImage: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Test Profile Data
        profiles = TestProfile.profiles()
        
        //Initial Status
        isChannelEnabled = switchChannel.isOn
        isBadgeEnabled = swictchBadge.isOn
        shape = switchShape.isOn ? .circle : .square
        channelPosition = switchChannelPosition.isOn ? .bottomRight : .bottomLeft
        badgePosition = switchBadgePosition.isOn ? .topRight : .topLeft
        showImage = switchProfileType.isOn
        
        switchChannelPosition.isUserInteractionEnabled = false
        switchChannelPosition.alpha = 0.2
        switchBadgePosition.isUserInteractionEnabled = false
        switchBadgePosition.alpha = 0.2
        btnBorderColor.isEnabled = false
        btnBorderColor.alpha = 0.2
        
        switchProfile()
    }
    
    func switchProfile() {
        
        if showImage {
            guard let image = UIImage(named:profiles[profileIndex].image) else {
                fatalError("Check Your Image Resource!")
            }
            
            profileView.setProfileImage(image)
        }
            
        else {
            profileView.setProfileName(profiles[profileIndex].name)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Events
    @IBAction func actSwitchProfiles(_ sender: UIButton) {
        
        if profileIndex < 5 { profileIndex = profileIndex + 1 }
        else { profileIndex = 0 }
        
        switchProfile()
    }
    
    @IBAction func actSwitchProfileImage(_ sender: UISwitch) {
        showImage = sender.isOn
        switchProfile()
    }
    
    @IBAction func actSwitchShape(_ sender: UISwitch) {
        
        shape = sender.isOn ? .circle : .square
        profileView.setProfileShape(shape)
        profileView.setChannelShape(shape)
        profileView.setBadgeShape(shape)
    }
    
    @IBAction func actBorderColor(_ sender: UIButton) {
        
        if borderColorIndex < 9 { borderColorIndex = borderColorIndex + 1 }
        else { borderColorIndex = 0 }
        
        profileView.setBorder(with: CGFloat(slider.value), and: colors[borderColorIndex])
        profileView.setBadgeBorder(with: CGFloat(slider.value), and: colors[borderColorIndex])
        profileView.setChannelBorder(with: CGFloat(slider.value), and: colors[borderColorIndex])
    }
    
    @IBAction func actBackgroundColor(_ sender: UIButton) {
        
        if backgroundColorIndex < 9 { backgroundColorIndex = backgroundColorIndex + 1 }
        else { backgroundColorIndex = 0 }
        
        let index1: Int = Int(arc4random_uniform(9))
        let index2: Int = Int(arc4random_uniform(9))
        
        profileView.setBackground(with: [colors[index1], colors[index2]])
        profileView.setBadgeBackground(with: [colors[backgroundColorIndex]])
    }
    
    @IBAction func actBorderWidthSlider(_ sender: UISlider) {
        
        if sender.value > 0 {
            btnBorderColor.isEnabled = true
            btnBorderColor.alpha = 1.0
        }
            
        else {
            btnBorderColor.isEnabled = false
            btnBorderColor.alpha = 0.2
        }
        
        profileView.setBorder(with:CGFloat(sender.value), and: colors[borderColorIndex])
        profileView.setChannelBorder(with:CGFloat(sender.value), and: colors[borderColorIndex])
        profileView.setBadgeBorder(with:CGFloat(sender.value), and: colors[borderColorIndex])
    }
    
    @IBAction func actEnableChannel(_ sender: UISwitch) {
        
        if sender.isOn {
            isChannelEnabled = true
            switchChannelPosition.isUserInteractionEnabled = true
            switchChannelPosition.alpha = 1.0
            profileView.addChannelView(at: channelPosition, image: UIImage(named: profiles[profileIndex].channel)!)
            profileView.setChannelShape(shape)
            profileView.setChannelBorder(with: CGFloat(slider.value), and: colors[borderColorIndex])
        }
            
        else {
            
            switchChannelPosition.isUserInteractionEnabled = false
            switchChannelPosition.alpha = 0.2
            isChannelEnabled = false
            profileView.removeChannelView()
        }
    }
    
    @IBAction func actEnableBadge(_ sender: UISwitch) {
        
        if sender.isOn {
            
            isBadgeEnabled = true
            switchBadgePosition.isUserInteractionEnabled = true
            switchBadgePosition.alpha = 1.0
            profileView.addBadgeView(at: badgePosition, initialCount: 0)
            profileView.setBadgeShape(shape)
            profileView.setBadgeBorder(with: CGFloat(slider.value), and: colors[borderColorIndex])
            profileView.setBadgeBackground(with: [colors[backgroundColorIndex]])
        }
            
        else {
            isBadgeEnabled = false
            switchBadgePosition.isUserInteractionEnabled = false
            switchBadgePosition.alpha = 0.2
            profileView.removeBadgeView()
        }
    }
    
    @IBAction func actChannelPosition(_ sender: UISwitch) {
        
        channelPosition = sender.isOn ? .bottomRight : .bottomLeft
        profileView.setChannelPosition(channelPosition)
    }
    
    @IBAction func actBadgePosition(_ sender: UISwitch) {
        
        badgePosition = sender.isOn ? .topRight : .topLeft
        profileView.setBadgePosition(badgePosition)
    }
}

struct TestProfile {
    
    let name: String
    let image: String
    let channel: String
    
    static func profiles() -> [TestProfile] {
        
        var profiles = [TestProfile]()
        
        profiles.append(TestProfile(name: "Monica Geller", image: "monica", channel: "linkedin"))
        profiles.append(TestProfile(name: "Chandler Bing", image: "chandler", channel: "facebook"))
        profiles.append(TestProfile(name: "Rachel Green", image: "rachel", channel: "instagram"))
        profiles.append(TestProfile(name: "Ross Geller", image: "ross", channel: "twitter"))
        profiles.append(TestProfile(name: "Phoebe Buffay", image: "phoebe", channel: "soundcloud"))
        profiles.append(TestProfile(name: "Joey Tribbiani", image: "joey", channel: "twitter"))
        
        return profiles
    }
}
