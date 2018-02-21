//
//  ViewController.swift
//  ProgramaticConstraintsWithAnimations
//
//  Created by Christopher Thiebaut on 2/21/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let topLeftButton = UIButton()
    let topRightButton = UIButton()
    let bottomLeftButton = UIButton()
    let bottomRightButton = UIButton()
    
    var buttons: [UIButton] = []
    let colors: [UIColor] = [.red, .blue, .yellow, .green]
    var colorOffset = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setUpButtons()
        
        setUpConstraints()
    }
    
    func setUpButtons(){
        topLeftButton.backgroundColor = colors[0]
        topRightButton.backgroundColor = colors[1]
        bottomLeftButton.backgroundColor = colors[2]
        bottomRightButton.backgroundColor = colors[3]
        
        buttons = [topLeftButton, topRightButton, bottomLeftButton, bottomRightButton]
        
        topLeftButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        topRightButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        bottomRightButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        bottomLeftButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        topLeftButton.addTarget(self, action: #selector(buttonExited(_:)), for: .touchDragExit)
        topRightButton.addTarget(self, action: #selector(buttonExited(_:)), for: .touchDragExit)
        bottomRightButton.addTarget(self, action: #selector(buttonExited(_:)), for: .touchDragExit)
        bottomLeftButton.addTarget(self, action: #selector(buttonExited(_:)), for: .touchDragExit)
        
        view.addSubview(topLeftButton)
        view.addSubview(topRightButton)
        view.addSubview(bottomLeftButton)
        view.addSubview(bottomRightButton)
        
    }
    
    func setUpConstraints(){
        topLeftButton.translatesAutoresizingMaskIntoConstraints = false
        topRightButton.translatesAutoresizingMaskIntoConstraints = false
        bottomLeftButton.translatesAutoresizingMaskIntoConstraints = false
        bottomRightButton.translatesAutoresizingMaskIntoConstraints = false
        
        //Height and width constraints
        //Set the width of buttons consistent for each row
        let topButtonWidths = NSLayoutConstraint(item: topLeftButton, attribute: .width, relatedBy: .equal, toItem: topRightButton, attribute: .width, multiplier: 1, constant: 0)
        let bottomButtonWidths = NSLayoutConstraint(item: bottomLeftButton, attribute: .width, relatedBy: .equal, toItem: bottomRightButton, attribute: .width, multiplier: 1, constant: 0)
        
        //make the height of buttons consistent for each column
        let leftButtonHeights = NSLayoutConstraint(item: topLeftButton, attribute: .height, relatedBy: .equal, toItem: bottomLeftButton, attribute: .height, multiplier: 1, constant: 0)
        let rightButtonHeights = NSLayoutConstraint(item: topRightButton, attribute: .height, relatedBy: .equal, toItem: bottomRightButton, attribute: .height, multiplier: 1, constant: 0)
        
        //Set up constraints so all buttons will be sized relative to the top left button
        let topWidthsEqualBottomWidths = NSLayoutConstraint(item: topLeftButton, attribute: .width, relatedBy: .equal, toItem: bottomLeftButton, attribute: .width, multiplier: 1, constant: 0)
        let rightHeightsEqualLeftHeights = NSLayoutConstraint(item: topLeftButton, attribute: .height, relatedBy: .equal, toItem: topRightButton, attribute: .height, multiplier: 1, constant: 0)
        
        //Size the top left item
        let topLeftHeight = NSLayoutConstraint(item: topLeftButton, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.5, constant: 0)
        let topLeftWidth = NSLayoutConstraint(item: topLeftButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.5, constant: 0)
        
        //Position the top left item
        let topLeftLeadingConstraint = NSLayoutConstraint(item: topLeftButton, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0)
        let topLeftTopConstraint = NSLayoutConstraint(item: topLeftButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        
        //Position the top right item
        let topRightLeft = NSLayoutConstraint(item: topRightButton, attribute: .left, relatedBy: .equal, toItem: topLeftButton, attribute: .right, multiplier: 1, constant: 0)
        let topRightTop = NSLayoutConstraint(item: topRightButton, attribute: .top, relatedBy: .equal, toItem: topLeftButton, attribute: .top, multiplier: 1, constant: 0)
        
        //Position the bottom left item
        let bottomLeftLeft = NSLayoutConstraint(item: bottomLeftButton, attribute: .left, relatedBy: .equal, toItem: topLeftButton, attribute: .left, multiplier: 1, constant: 0)
        let bottomLeftTop = NSLayoutConstraint(item: bottomLeftButton, attribute: .top, relatedBy: .equal, toItem: topLeftButton, attribute: .bottom, multiplier: 1, constant: 0)
        
        //Position the bottom right item
        let bottomRightLeft = NSLayoutConstraint(item: bottomRightButton, attribute: .left, relatedBy: .equal, toItem: bottomLeftButton, attribute: .right, multiplier: 1, constant: 0)
        let bottomRightTop = NSLayoutConstraint(item: bottomRightButton, attribute: .top, relatedBy: .equal, toItem: bottomLeftButton, attribute: .top, multiplier: 1, constant: 0)
        
        //Add the constraints
        view.addConstraints([topButtonWidths, bottomButtonWidths, leftButtonHeights, rightButtonHeights, topWidthsEqualBottomWidths, rightHeightsEqualLeftHeights, topLeftWidth, topLeftHeight, topLeftLeadingConstraint, topLeftTopConstraint, topRightLeft, topRightTop, bottomLeftTop, bottomLeftLeft, bottomRightLeft, bottomRightTop])
    }
    
    @objc func buttonTapped(){
        UIView.animate(withDuration: 1) {
            self.colorOffset += 1
            for index in 0..<self.buttons.count {
                self.buttons[index].backgroundColor = self.colors[(index + self.colorOffset) % self.buttons.count]
            }
        }
    }
    
    @objc func buttonExited(_ sender: UIButton){
        view.bringSubview(toFront: sender)
        
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [sender.frame.origin.x + sender.frame.width/2,
                            sender.frame.origin.x + sender.frame.width/2 - 15,
                            sender.frame.origin.x + sender.frame.width/2 + 15,
                            sender.frame.origin.x + sender.frame.width/2]
        animation.keyTimes = [0, 0.25, 0.5, 0.75, 1]
        animation.duration = 0.5
        animation.repeatCount = 5
        sender.layer.add(animation, forKey: "shake")
    }

}


extension UIColor {
    static let customColor = #colorLiteral(red: 0, green: 0.7824953198, blue: 0.4556441307, alpha: 1)
}

