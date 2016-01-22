//
//  App.swift
//  CrazyFans
//
//  Created by z on 1/9/15.
//  Copyright (c) 2015 z. All rights reserved.
//

import UIKit


var gtestWindow: UIWindow!

extension BaseApp {
    enum AppState {
        case None
        case FirstRun
        case NoUser // not logged in
        case LoggedIn() // user existed need parametar user
//        case LoggedOut([SFUser])
        case Test
    }
    
    struct Notification {
        static let imageDownloaded = "ntf.0"
    }
    
    struct UserDefaults {
        static let HasLaunchedOnceKey = "HasLaunchedOnceKey" // nokey/false -> false
        static let LoggedInUserIDKey = "LoggedInUserIDKey"
//        static let LoggedOutUserIDKey = "LoggedOutUserIDKey"
//        static let OwnerTokenKey = "OwnerTokenKey"
    }
}

class BaseApp: NSObject {
    
    
    static var dbSetup: (()->Void)?
    static var appEnvSetup: (()->Void)?

    var owner: User!
    
    let delegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var window: UIWindow!
    var testWindow: UIWindow!
    
    func realWindow() -> UIWindow {
        return testWindow ?? window
    }
    
    var state: AppState = AppState.None {
        didSet {
            switch oldValue {
            case .None, .Test, .NoUser, .LoggedIn():
                switch state {
                case .FirstRun:
                    showFirstRunPage()
                case .NoUser:
                    showStartPage()
                case .LoggedIn():
//                    App.owner = u
                    showHomePage()
                case .Test:
                    showTestPage()
                default:
                    break
                }
            default:
                break
            }
        }
    }
    
    func endTest() {
        testWindow.hidden = true
    }

    func runState() {
        state = calculateState()
        
//<<<<<<< Updated upstream
//        setupTestCaseOnce()
//        
//        let localNotification = UILocalNotification()
//        localNotification.fireDate = NSDate(timeIntervalSinceNow: 5)
//        localNotification.alertBody = "new Blog Posted at iOScreator.com"
//        localNotification.soundName = UILocalNotificationDefaultSoundName
////        localNotification.timeZone = NSTimeZone.defaultTimeZone()
////        localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
//        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
//        
//=======
//>>>>>>> Stashed changes
        
    }
    
    func calculateState() -> AppState {
        var t = AppState.None
        if isFirstRun() { // first run
            t = .FirstRun
        } else {
            if let u = loggedInUser() { // user logged in
                t = .LoggedIn()
            } else { // user logged out / no user
                t = .NoUser
            }
        }
        return t
    }
    
    func loggedInUser() -> User? {
//        if let uid = NSUserDefaults.standardUserDefaults().objectForKey(UserDefaults.LoggedInUserIDKey) as? String
//        {
//            BaseApp.initializeDBForUser(uid)
//            if let u = User.userByID(uid) {
//                return u
//            }
//        }
        return nil
    }
    
    func isFirstRun() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey(UserDefaults.HasLaunchedOnceKey) == false
    }
    
    func showFirstRunPage() {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: UserDefaults.HasLaunchedOnceKey)
        showStartPage()
    }
    
    func showTestPage() {
        let dummy = UINavigationController(rootViewController: DummyViewControllerModDev())
        
        testWindow = UIWindow(frame: window.frame)
        testWindow.rootViewController = UIViewController()
        testWindow.windowLevel = UIWindowLevelAlert
        testWindow.makeKeyAndVisible()
        
        let c = testWindow.rootViewController!
        c.addChildViewController(dummy)
        dummy.view.frame = c.view.bounds
        c.view.addSubview(dummy.view)
        dummy.didMoveToParentViewController(c)
        
    }
    
    func showStartPage() {
        let c = UINavigationController(rootViewController: AppStart())
        let root = window.rootViewController!
        root.addChildViewController(c)
        c.view.frame = c.view.bounds
        root.view.addSubview(c.view)
        c.didMoveToParentViewController(root)
    }
    
    var tab: TabBar!
    
    func showHomePage() {
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
        
        let vc = TabBar()
        App.realWindow().rootViewController?.addChild(vc)
        tab = vc
    }
    
    func showLastActivity() {
        
    }
    
    func showScratchPage() {
        
    }
    
//    func hideStatusBar() {
//        (App.realWindow().rootViewController as! ViewController).statusBarHidden = true
//    }
//    
//    func showStatusBar() {
//        (App.realWindow().rootViewController as! ViewController).statusBarHidden = false
//    }
    
    let fileSYS = FileSys.self
}

extension BaseApp {
    func logout(controller: UIViewController) {
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: BaseApp.UserDefaults.LoggedInUserIDKey)
        controller.tabBarController?.removeFromSuper()
        App.runState()
    }
}

// initialization
extension BaseApp {
//<<<<<<< Updated upstream
//    static func initialize() {
//        // Network
//        // DB
////        var filename = NSProcessInfo.processInfo().globallyUniqueString
//        
//        if(UIApplication.instancesRespondToSelector(Selector("registerUserNotificationSettings:"))) {
//            if #available(iOS 8.0, *) {
//                UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Sound, .Alert], categories: nil))
//            } else {
//                // Fallback on earlier versions
//            }
//        }
//        
//        
//        let url = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]).URLByAppendingPathComponent("database")
//        
//        
////        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
////        let url = paths.stringByAppendingPathComponent("reminder.plist")
//        
//        
////      po(url)
//        
//        
//        
////      url = NSURL(fileURLWithPath: "/Users/z/Desktop/db_T")!
//=======
    
    static func setupTestCases() {
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.rootViewController = ViewController()
        
        let dummy = UINavigationController(rootViewController: DummyViewControllerDatasetTest())
        let c = window.rootViewController!
        c.addChildViewController(dummy)
        dummy.view.frame = c.view.bounds
        c.view.addSubview(dummy.view)
        dummy.didMoveToParentViewController(c)
        
        window.makeKeyAndVisible()
        gtestWindow = window
    }
    
    
    static func initialize(dbOpt: DADB?) {
        
        // UI Customize
//        UINavigationBar.appearance().setTitleVerticalPositionAdjustment(-3, forBarMetrics: UIBarMetrics.Default)
//        let attributes = [NSForegroundColorAttributeName: Palette.Color.MainTextBlack, NSFontAttributeName: Palette.Font.systemFontNaviTitle]
//        UINavigationBar.appearance().titleTextAttributes = attributes
//        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "cheveron")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
//        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage()
//        
//        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
//        UINavigationBar.appearance().shadowImage = UIImage(named: "nav_line_bottom")
////        UINavigationBar.appearance().barTintColor = Palette.Color.white2
//        UINavigationBar.appearance().translucent = false
//        
////        UINavigationBar.appearance().barTintColor = UIColor(white: (255-40)/(1-40/255), alpha: 1)
//        
//        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -1000), forBarMetrics: UIBarMetrics.Default)
//        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blackColor()], forState: UIControlState.Normal)
//        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.redColor()], forState: UIControlState.Highlighted)
        
        
        // db
//        initDB(dbOpt)
        
        // App
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.rootViewController = ViewController()
        App = BaseApp(window: window)
        window.makeKeyAndVisible()
        
        appEnvSetup?()
        
        if ShowDummy {
            App.runMod()
        } else {
            App.runState()
        }
    }
    
    func runMod() {
        state = .Test
    }
    
    convenience init(window: UIWindow) {
        self.init()
        self.window = window
        window.rootViewController?.view.backgroundColor = UIColor.whiteColor()
        
        FileSys.mkdirs()
    }
    
    func initOwner() {
        owner = User()
    }
    
    static func initializeDB(dbOpt: DADB?) {
        if let onlineDB = DB {
            onlineDB.close()
        }
        
        if let db = dbOpt {
            DB = db
        } else {
            DB = DADB(url: FileSys.appROOT.URLByAppendingPathComponent("db"))!
        }
        
        dbSetup?()
    }
    
    static func initializeDBForUser(uid: String) {
        BaseApp.initializeDB(DADB(url: BaseApp.dbURL(uid)))
    }
    
    
    static func dbURL(userID: String) -> NSURL {
        return FileSys.appROOT.URLByAppendingPathComponent("u_\(userID).db")
    }
    
    
    func token() -> String? {
        return nil
//        return "d9f007ccdd8f643d408685e35a1ded85dbe0470b"
    }
    
    struct FileSys {
        static var appROOT: NSURL {
            let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
            return urls[urls.count-1] 
        }
        
        static var avatarROOT: NSURL {
            return self.appROOT.URLByAppendingPathComponent("avatars")
        }
        
        static var audioROOT: NSURL {
            return self.appROOT.URLByAppendingPathComponent("audio")
        }
        
        static var photoROOT: NSURL { // photo
            return self.appROOT.URLByAppendingPathComponent("photo")
        }
        
        static var photoROOT_th: NSURL { // thumbnail
            return self.appROOT.URLByAppendingPathComponent("photo/th")
        }
        
        static var photoROOT_og: NSURL { // origin
            return self.appROOT.URLByAppendingPathComponent("photo/th")
        }
        
        // TODO: remake -> make in release
        static func mkdirs() {
            FileSys.avatarROOT.mkdir()
            FileSys.photoROOT.mkdir()
            FileSys.photoROOT_th.mkdir()
            FileSys.photoROOT_og.mkdir()
        }
        
        static func avartarFileURL(filename: String) -> NSURL {
            return avatarROOT.URLByAppendingPathComponent(filename)
        }
        
        static func audioFileURL(filename: String) -> NSURL {
            return audioROOT.URLByAppendingPathComponent(filename)
        }
        
        static func photoFileURL(filename: String) -> NSURL {
            return photoROOT.URLByAppendingPathComponent(filename + ".png")
        }
        
        static func photoFileURL_th(filename: String) -> NSURL {
            return photoROOT.URLByAppendingPathComponent(filename)
        }

        static func photoFileURL_og(filename: String) -> NSURL {
            return photoROOT.URLByAppendingPathComponent(filename)
        }
    }
}

// helpers
extension BaseApp {
    func pause(enable: Bool) {
        if enable {
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        } else {
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
        }
    }
}

var App: BaseApp!

