//
//  BaseViewController.swift
//  SnapFit
//
//  Created by Stephen on 8/17/15.
//  Copyright (c) 2015 SNAPFIT INC. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var keyboardSize: CGRect!
    
    var leftButton: UIButton!
    var rightButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.whiteColor()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getReadyDisplay() {
        let backImage = UIImageView(frame: CGRectMake(0, 0, Device.portraitWidth, Device.portraitHeight))
        backImage.image = UIImage(named: LS("backImage", inTable: "MainFunction"))
        self.view.addSubview(backImage)
    }
    
    func setUpButton() {
        leftButton = UIButton(frame: CGRectMake(0, 37-10, 56, 56))
        self.view.addSubview(leftButton)
        rightButton = UIButton(frame: CGRectMake(Device.portraitWidth - 56, 37-10, 56, 56))
        self.view.addSubview(rightButton)
    }
    
    func showBackButton() {
        self.rightButton.hidden = true
        self.leftButton.hidden = false
        self.leftButton.setImage(UIImage(named: "nav_back"), forState: .Normal)
        self.leftButton.addTarget(self, action: "backToPervise:", forControlEvents: .TouchUpInside)
    }
    
    func showShareButton() {
        self.leftButton.hidden = true
        self.rightButton.hidden = false
        self.rightButton.setImage(UIImage(named: "nav_share"), forState: .Normal)
        self.rightButton.addTarget(self, action: "share:", forControlEvents: .TouchUpInside)
    }
    
    func showBothSide() {
        self.leftButton.hidden = false
        self.rightButton.hidden = false
        self.leftButton.setImage(UIImage(named: "nav_backtohome"), forState: .Normal)
        self.leftButton.addTarget(self, action: "backToPervise:", forControlEvents: .TouchUpInside)
        
        self.rightButton.setImage(UIImage(named: "nav_about"), forState: .Normal)
        self.rightButton.addTarget(self, action: "showAbout:", forControlEvents: .TouchUpInside)
    }
    
    func showWithShare() {
        self.leftButton.hidden = false
        self.rightButton.hidden = false
        self.leftButton.setImage(UIImage(named: "nav_back"), forState: .Normal)
        self.leftButton.addTarget(self, action: "backToPervise:", forControlEvents: .TouchUpInside)
        
        self.rightButton.setImage(UIImage(named: "nav_share"), forState: .Normal)
        self.rightButton.addTarget(self, action: "share:", forControlEvents: .TouchUpInside)
    }
    
    func setLineTitle(title: String) {
        let lineTitleLabel = UILabel(frame: CGRectZero)
        lineTitleLabel.font = Palette.Font.chineseFont
        lineTitleLabel.textColor = Palette.Color.selectGraduation
        lineTitleLabel.text = title
        lineTitleLabel.sizeToFit()
        lineTitleLabel.frame = CGRectMake(Device.portraitWidth/2-lineTitleLabel.frame.width/2, 54-10, lineTitleLabel.frame.width, lineTitleLabel.frame.height)
        self.view.addSubview(lineTitleLabel)
        
        let leftLine = UIView(frame: CGRectMake(lineTitleLabel.frame.origin.x-48, lineTitleLabel.frame.origin.y+lineTitleLabel.frame.height/2-0.5, 24, 1))
        leftLine.backgroundColor = Palette.Color.barColor
        self.view.addSubview(leftLine)
        
        let leftSquare = UIView(frame: CGRectMake(lineTitleLabel.frame.origin.x-14, lineTitleLabel.frame.origin.y+lineTitleLabel.frame.height/2-2, 4, 4))
        leftSquare.backgroundColor = Palette.Color.squareColor
        leftSquare.transform = CGAffineTransformMakeRotation(CGFloat(M_PI/4))
        self.view.addSubview(leftSquare)
        
        let rightSquare = UIView(frame: CGRectMake(lineTitleLabel.frame.origin.x+10+lineTitleLabel.frame.width, lineTitleLabel.frame.origin.y+lineTitleLabel.frame.height/2-2, 4, 4))
        rightSquare.backgroundColor = Palette.Color.squareColor
        rightSquare.transform = CGAffineTransformMakeRotation(CGFloat(M_PI/4))
        self.view.addSubview(rightSquare)
        
        let rightLine = UIView(frame: CGRectMake(lineTitleLabel.frame.origin.x+24+lineTitleLabel.frame.width, lineTitleLabel.frame.origin.y+lineTitleLabel.frame.height/2-0.5, 24, 1))
        rightLine.backgroundColor = Palette.Color.barColor
        self.view.addSubview(rightLine)
        
    }
    
    func setTitle(title: String, rightButton: UIBarButtonItem?, leftButton: UIBarButtonItem?) {
        self.title = title
        if (rightButton != nil) {
            self.navigationItem.rightBarButtonItem = rightButton
        }
        if (leftButton != nil) {
            self.navigationItem.leftBarButtonItem = leftButton
        }
    }
    
    func hiddeNavigationBar() {
        self.navigationController?.navigationBarHidden = true
    }
    
    func showNavigationBar() {
        self.navigationController?.navigationBarHidden = false
    }
    
    func hiddeStatusBar(animation: Bool) {
        if animation == true {
            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)
        } else {
            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
        }
    }
    
    func showStatusBar(animation: Bool) {
        if animation == true {
            UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
        } else {
            UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
        }
    }
    
    func changeStatusBarStyle(style: UIStatusBarStyle) {
        UIApplication.sharedApplication().setStatusBarStyle(style, animated: true)
    }
    
    func changeShadowImageToDefault() {
        navigationController?.navigationBar.shadowImage = UIImage(named: "nav_line_bottom")
    }
    
    func changeShadowImageToWrong() {
        navigationController?.navigationBar.shadowImage = UIImage(named: "nav_line_erro")
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func showAlterViewWithMessage(message: String) {
//        UIAlertView(title: "Error", message: message, delegate: nil, cancelButtonTitle: "OK")
        let alter = UIAlertView(title: "Error", message: message, delegate: nil, cancelButtonTitle: "OK")
//        self.presentViewController(alter, animated: true) { () -> Void in
//            
//        }
        alter.show()
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

extension BaseViewController {
    
    func setUpKeyboardNotification() {
        keyboardSize = CGRectZero
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func resignKeyboardNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func didShow(notification: NSNotification) {
        
    }
    
    func didHide(notification: NSNotification) {
        
    }
}


extension BaseViewController {
    func backToPervise(button: UIButton?) {
        print("dismiss")
        if self.navigationController == nil {
            self.dismissViewControllerAnimated(true) { () -> Void in
                
            }
        } else {
            if self.navigationController?.viewControllers.count > 1 {
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                self.dismissViewControllerAnimated(true) { () -> Void in
                    
                }
            }
        }
    }
    
//    func backToHome(button: UIButton) {
//        print("back to home")
//        if self.navigationController == nil {
//            self.dismissViewControllerAnimated(true) { () -> Void in
//                
//            }
//        } else {
//            if self.navigationController?.viewControllers.count > 1 {
//                self.navigationController?.popViewControllerAnimated(true)
//            } else {
//                self.dismissViewControllerAnimated(true) { () -> Void in
//                    
//                }
//            }
//        }
//    }
    
    func showAbout(button: UIButton?) {
        print("show about")
        let controller = AboutViewController()
        if self.navigationController == nil {
            let n = UINavigationController(rootViewController: controller)
            self.presentViewController(n, animated: false, completion: { () -> Void in
                
            })
        } else {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func share(button: UIButton?) {
        print("show share view")
        
        let shareView = ShareView(frame: self.view.frame)
        if button == nil {
            shareView.shareButton.hidden = true
        }
        
        self.view.addSubview(shareView)
    }
}
