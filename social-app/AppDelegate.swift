//
//  AppDelegate.swift
//  social-app
//
//  Created by @unknown on 29.10.2018.
//

import UIKit
import Firebase
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate{
    let board : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        rememberUser()
        return true
    }    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    func getDataFromFirebase(){
        mainPageVC.tumppArray.removeAll(keepingCapacity: false)
        let databaseReference = Database.database().reference().child("users")
        databaseReference.observe(.childChanged) { (snapshot) in
            print("chan")
            
            let values = snapshot.value! as! NSDictionary
            if(Auth.auth().currentUser?.uid == snapshot.key)
            {
                if let control = values["userImage"]
                {
                    let control2 = ((control as! NSDictionary)["image"]) as! String
                    if control2 != ""
                    {
                        myProfileVC.userProfileImage = control2
                        yorumVC.userpp = control2
                        messageVC.userppimg = control2
                 
                    }
                }
            }
            if(Auth.auth().currentUser?.uid == snapshot.key)
            {
                if let post2 = values["message"]
                {
                    
                    let mesajlar = ((post2 as! NSDictionary).allValues)
                    messageBoxVC.mesajlar = mesajlar
                    messageVC.mesajlar = mesajlar
                }
                
            }
            if(Auth.auth().currentUser?.uid == snapshot.key)
            {
                if let post2 = values["bildirim"]
                {
                    
                    let bildirim = ((post2 as! NSDictionary).allValues)
                    for i in 0...bildirim.count-1
                    {
                        if (bildirim[i] as AnyObject).count == nil
                        {
                            mainPageVC.notification = bildirim[i] as! String
                        }
                    }
                    notificationVC.bildirim = bildirim
                 
                    
                }
                
            }
            
            if let post = values["post"]
            {
                
                let postID = (post as! NSDictionary).allKeys
            
                
                for id in postID {
                    
                    
                    let singlePost = (post as! NSDictionary)[id] as! NSDictionary
                    if let like = singlePost["like"]
                    {
                        
                        let x = ((like as! NSDictionary).allKeys) as! [String]
                        
                        if Auth.auth().currentUser?.uid != nil
                        {
                            mainPageVC.kullaniciBegendimi[id as! String] = (String(x.contains((Auth.auth().currentUser?.uid)!)))
                        }
                        mainPageVC.likeDictionary[id as! String] = String((like as! NSDictionary).count)
                    }
                    else
                    {
                        mainPageVC.likeDictionary[id as! String] = "0"
                        mainPageVC.kullaniciBegendimi[id as! String] = "false"
                        
                    }
                    if let control = values["userImage"]
                    {
                        let control2 = ((control as! NSDictionary)["image"]) as! String
                        if control2 != ""
                        {
                            mainPageVC.tumppArray.append(control2)
                           
                            
                        }
                        
                        
                    }
                    else
                    {
                        let databaseRef = Database.database().reference(); databaseRef.child("users").child((Auth.auth().currentUser?.uid)!).child("userImage").child("https://firebasestorage.googleapis.com/v0/b/social-app-d08b4.appspot.com/o/media%2FuserImage.png?alt=media&token=741b87c1-6336-4fe9-bcda-edbb924d54ed")
                    }
                    if !(mainPageVC.userImageArray.contains(singlePost["image"] as! String))
                    {
                       
                        mainPageVC.userImageArray.append(singlePost["image"] as! String)
                        
                        

                    }
                    if let yorum = singlePost["yorum"]
                    {
                        let yorumlar = (yorum as! NSDictionary).allValues
                        yorumVC.yorumlar[id as! String] = (yorumlar)
                        
                        
                    }
                    if mainPageVC.userImageArray.count > mainPageVC.userEmailArray.count
                    {
                        
                        mainPageVC.imageId.append(id as! String)
                        mainPageVC.userIdArray.append(singlePost["userid"] as! String)
                        mainPageVC.userCommentArray.append(singlePost["posttext"] as! String)
                        mainPageVC.userEmailArray.append(singlePost["postedby"] as! String)
                        mainPageVC.userPredictArray.append(singlePost["predict"] as! String)
                        mainPageVC.postFiyatArray.append(singlePost["fiyat"] as! String)
                    }
                    if(Auth.auth().currentUser?.uid == snapshot.key)
                    {

                        if !(myProfileVC.userImageArray.contains(singlePost["image"] as! String))
                        {
                            myProfileVC.userImageArray.append(singlePost["image"] as! String)
                        }
                        if myProfileVC.userImageArray.count > myProfileVC.userEmailArray.count
                        {
                            myProfileVC.imageId.append(id as! String)
                            myProfileVC.userCommentArray.append(singlePost["posttext"] as! String)
                            myProfileVC.userPredictArray.append(singlePost["predict"] as! String)
                            myProfileVC.userEmailArray.append(singlePost["postedby"] as! String)
                            myProfileVC.postFiyatArray.append(singlePost["fiyat"] as! String)

                        }
           
                        
                    }
                }
                
            }
            
             NotificationCenter.default.post(name:NSNotification.Name(rawValue: "newImage"),object:nil)
        }
        databaseReference.observe(.childAdded) { (snapshot) in
            let values = snapshot.value! as! NSDictionary
            if(Auth.auth().currentUser?.uid == snapshot.key)
            {
                if let control = values["userImage"]
                {
                    let control2 = ((control as! NSDictionary)["image"]) as! String
                    if control2 != ""
                    {
                        myProfileVC.userProfileImage = control2
                        yorumVC.userpp = control2
                        messageVC.myuserppimg = control2
                        
                    }
                    
                }

            
            }
            if(Auth.auth().currentUser?.uid == snapshot.key)
            {
                if let post2 = values["message"]
                {
                    
                    let mesajlar = ((post2 as! NSDictionary).allValues)
                    messageBoxVC.mesajlar = mesajlar
                    messageVC.mesajlar = mesajlar
                }
                
            }
            if(Auth.auth().currentUser?.uid == snapshot.key)
            {
                if let post2 = values["bildirim"]
                {
                    
                    let bildirim = ((post2 as! NSDictionary).allValues)
                    for i in 0...bildirim.count-1
                    {
                        if (bildirim[i] as AnyObject).count == nil
                        {
                            mainPageVC.notification = bildirim[i] as! String
                        }
                    }
                    notificationVC.bildirim = bildirim
                    
                }
                
            }
            if let post = values["post"]
            {
                
                let postID = (post as! NSDictionary).allKeys
                for id in postID {
                    
                    let singlePost = (post as! NSDictionary)[id] as! NSDictionary
                    if let like = singlePost["like"]
                    {
                        
                        let x = ((like as! NSDictionary).allKeys) as! [String]
                        if Auth.auth().currentUser?.uid != nil
                        {
                            mainPageVC.kullaniciBegendimi[id as! String] = (String(x.contains((Auth.auth().currentUser?.uid)!)))
                        }
                        
                        
                        mainPageVC.likeDictionary[id as! String] = String((like as! NSDictionary).count)
                    }
                    else
                    {
                        mainPageVC.likeDictionary[id as! String] = "0"
                        mainPageVC.kullaniciBegendimi[id as! String] = "false"

                    }
                    if !(mainPageVC.userImageArray.contains(singlePost["image"] as! String))
                    {
                        
                        mainPageVC.userImageArray.append(singlePost["image"] as! String)
                        
                        if let control = values["userImage"]
                        {
                            
                            let control2 = ((control as! NSDictionary)["image"]) as! String
                            if control2 != ""
                            {
                                
                                mainPageVC.tumppArray.append(control2)
                            }
                           
                        }
                        else
                        {
                            
                            mainPageVC.tumppArray.append(" ")
                            
                        }
                    }
                    
                    if let yorum = singlePost["yorum"]
                    {
                        let yorumlar = (yorum as! NSDictionary).allValues
                        yorumVC.yorumlar[id as! String] = (yorumlar)
                        
                        
                    }
                    if mainPageVC.userImageArray.count > mainPageVC.userEmailArray.count
                    {
                        mainPageVC.imageId.append(id as! String)
                        mainPageVC.userIdArray.append(singlePost["userid"] as! String)
                        mainPageVC.userCommentArray.append(singlePost["posttext"] as! String)
                        mainPageVC.userEmailArray.append(singlePost["postedby"] as! String)
                        mainPageVC.userPredictArray.append(singlePost["predict"] as! String)
                        mainPageVC.postFiyatArray.append(singlePost["fiyat"] as! String)
                    }
                    

                    if(Auth.auth().currentUser?.uid == snapshot.key)
                    {
                        if !(myProfileVC.userImageArray.contains(singlePost["image"] as! String))
                        {
                            myProfileVC.userImageArray.append(singlePost["image"] as! String)
                        }
                        if myProfileVC.userImageArray.count > myProfileVC.userEmailArray.count
                        {
                            myProfileVC.imageId.append(id as! String)
                            myProfileVC.userCommentArray.append(singlePost["posttext"] as! String)
                            myProfileVC.userPredictArray.append(singlePost["predict"] as! String)
                            myProfileVC.userEmailArray.append(singlePost["postedby"] as! String)
                            myProfileVC.postFiyatArray.append(singlePost["fiyat"] as! String)
                        }
                        
                    }
                }
                
            }
             NotificationCenter.default.post(name:NSNotification.Name(rawValue: "newImage"),object:nil)

        }
       
    }
    func rememberUser() {
        print("remember")
        self.clearData()
        getDataFromFirebase()

        let user : String? = UserDefaults.standard.string(forKey: "user")
        if user != nil
        {
            window?.rootViewController = self.board.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
        }

    }
    
   
    
    func clearData()
    {
        print("clear")
        mainPageVC.imageId.removeAll(keepingCapacity: false)
        mainPageVC.userIdArray.removeAll(keepingCapacity: false)
        mainPageVC.userPredictArray.removeAll(keepingCapacity: false)
        mainPageVC.userEmailArray.removeAll(keepingCapacity: false)
        mainPageVC.userImageArray.removeAll(keepingCapacity: false)
        mainPageVC.userCommentArray.removeAll(keepingCapacity: false)
        mainPageVC.postFiyatArray.removeAll(keepingCapacity: false)
        myProfileVC.imageId.removeAll(keepingCapacity: false)
        myProfileVC.userEmailArray.removeAll(keepingCapacity: false)
        myProfileVC.userImageArray.removeAll(keepingCapacity: false)
        myProfileVC.userCommentArray.removeAll(keepingCapacity: false)
        myProfileVC.userPredictArray.removeAll(keepingCapacity: false)
        myProfileVC.postFiyatArray.removeAll(keepingCapacity: false)
        myProfileVC.userProfileImage = ""
        myProfileVC.count = 0
        yorumVC.userpp = ""
        yorumVC.yorum.removeAll(keepingCapacity: false)
        yorumVC.yorumSahibiResmi.removeAll(keepingCapacity: false)
        yorumVC.userMail.removeAll(keepingCapacity: false)
        

        messageBoxVC.mesajlar.removeAll(keepingCapacity: false)
        messageBoxVC.mailArray.removeAll(keepingCapacity: false)
        messageBoxVC.profilResmi.removeAll(keepingCapacity: false)
        
        
        
        messageVC.useridArray.removeAll(keepingCapacity: false)
        messageVC.mesajArray.removeAll(keepingCapacity: false)
        messageVC.profilResmi.removeAll(keepingCapacity: false)
        messageVC.mesajlar.removeAll(keepingCapacity: false)
      
    }

}

