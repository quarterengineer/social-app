//
//  messageVC.swift
//  social-app
//
//  Created by @unknown on 6.01.2019.
//

import UIKit
import Firebase
import FirebaseAuth
class messageVC: UIViewController,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var kisiselMesajlar: UITableView!
    @IBOutlet weak var messageText: UITextView!

    static var useridArray = [String:String]()
    static var mesajArray = [String:[String]]()
    static var kim = [String:[String]]()
    static var mesajTarih = [String]()
    static var profilResmi = [String:String]()
    static var tumMail = [String:[String]]()
    static var mesajlar = [Any]()
    static var selectedEmail = ""
    static var userppimg = ""
    static var myuserppimg = ""
    
    static var email = [String]()
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        print("aldimm",messageVC.selectedEmail)
        kisiselMesajlar.delegate = self
        kisiselMesajlar.dataSource = self
      
        messageText.delegate = self
        
        print("yyy")
        datapreprocessing(arr: messageVC.mesajlar)
        self.kisiselMesajlar.reloadData()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        NotificationCenter.default.addObserver(self, selector: #selector(self.xy), name: NSNotification.Name(rawValue: "newImage"), object: nil)

    }
    @objc func xy()
    {
        datapreprocessing(arr: messageVC.mesajlar)
        self.kisiselMesajlar.reloadData()
        
    }
    func datapreprocessing(arr:Array<Any>)
    {
       
        messageVC.mesajArray.removeAll(keepingCapacity: false)
        messageVC.kim.removeAll(keepingCapacity: false)
        messageVC.mesajTarih.removeAll(keepingCapacity: false)
        messageVC.profilResmi.removeAll(keepingCapacity: false)
        messageVC.email.removeAll(keepingCapacity: false)

        var jvalue = [String]()
      
        if arr.count != 0
        {
            var temp = [String]()
            var temp2 = ""
            var kim = [String]()
            var pp = ""
           
            for i in 0...arr.count-1
            {
                messageVC.mesajTarih.removeAll(keepingCapacity: false)
                for j in arr[i] as! NSDictionary
                {
                    if j.key as! String == "email"
                    {
                        messageVC.email.append(j.value as! String)
                        temp.append(j.value as! String)
                    }
                   
                    else if j.key as! String == "childMessage"
                    {
                        
                        let qwer = (j.value as! NSDictionary).allValues
                        for msj in qwer
                        {
                            let c = msj as! NSDictionary

                            jvalue.append(c["mesaj"] as! String)
                            messageVC.mesajTarih.append(c["tarih"] as! String)
                            kim.append(c["kim"] as! String)
                        }
                        
                    }
                    else if j.key as! String == "userid"
                    {
                        temp2 = j.value as! String
                    }
                    else if j.key as! String == "profilResmi"
                    {
                        pp = j.value as! String
                    }
                    
                }
                if messageVC.mesajTarih.count-1 > -1 && messageVC.mesajTarih.count == jvalue.count
                {
                    for i in 0...messageVC.mesajTarih.count-1
                    {
                        for j in 0...messageVC.mesajTarih.count-1
                        {
                            if messageVC.mesajTarih[i]<messageVC.mesajTarih[j]
                            {
                                print("true")
                                let temp = messageVC.mesajTarih[j]
                                messageVC.mesajTarih[j] = messageVC.mesajTarih[i]
                                messageVC.mesajTarih[i] = temp
                                let temp2 = jvalue[j]
                                jvalue[j] = jvalue[i]
                                jvalue[i] = temp2
                                
                                let temp3 = kim[j]
                                kim[j] = kim[i]
                                kim[i] = temp3
                                
                            }
                        }
                    }
                }
                messageVC.profilResmi[temp[i]] = pp
                messageVC.mesajArray[temp[i]] = jvalue
                messageVC.useridArray[temp[i]] = temp2
                messageVC.kim[temp[i]] = kim
              
                jvalue.removeAll(keepingCapacity: false)

            }

            if messageVC.profilResmi[messageVC.selectedEmail] != nil && messageVC.kim[messageVC.selectedEmail]!.count-1 > -1
            {
          
                print("temp",temp)
                print(messageVC.kim[messageVC.selectedEmail]!.count-1)
                var mailtemp = [String]()
                for pp in 0...messageVC.kim[messageVC.selectedEmail]!.count-1
                {
                    print("resime gr")
                    
                    if (messageVC.kim[messageVC.selectedEmail])![pp]  == "0"
                    {
                        
                        mailtemp.append(messageVC.selectedEmail)
                        print("0")
                        print((messageVC.kim[messageVC.selectedEmail])![pp] )
                        (messageVC.kim[messageVC.selectedEmail])![pp] = messageVC.profilResmi[messageVC.selectedEmail]!
                    }
                    else
                    {
                        print("1")
                        print((messageVC.kim[messageVC.selectedEmail])![pp] )
                        mailtemp.append((Auth.auth().currentUser?.email)!)
                        (messageVC.kim[messageVC.selectedEmail])![pp] = messageVC.myuserppimg
                        
                    }
                    
                    
                    
                }
                messageVC.tumMail[messageVC.selectedEmail] = mailtemp
                mailtemp.removeAll(keepingCapacity: false)
           
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prototypeCell", for: indexPath) as! kisiselMessageCell
        
        if messageVC.tumMail[messageVC.selectedEmail] != nil
        {
            let boldText  = (messageVC.tumMail[messageVC.selectedEmail])![indexPath.row]
            let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
            let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)
            let normalText = "\n"+(messageVC.mesajArray[messageVC.selectedEmail])![indexPath.row]
            let normalString = NSMutableAttributedString(string:normalText)
            
            attributedString.append(normalString)
           
            cell.messageText.attributedText = attributedString
            cell.profilImage.sd_setImage(with: URL(string: (messageVC.kim[messageVC.selectedEmail])![indexPath.row]))
           
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if messageVC.mesajArray[messageVC.selectedEmail] != nil
        {
             count = messageVC.mesajArray[messageVC.selectedEmail]!.count
        }
        return count
    }
    @IBAction func backButtonClicked(_ sender: Any)
    {
        let imageDetails = self.storyboard?.instantiateViewController(withIdentifier: "tabBar2") as! UITabBarController
        self.present(imageDetails, animated: false, completion: nil)
    }
   
    func textViewDidBeginEditing(_ textField: UITextView) {
        if textField == messageText {
            messageText.text = ""
        }
    }
    
    @IBAction func messageButtonClicked(_ sender: Any)
    {
        
        
        print("aldimm22",messageVC.selectedEmail)
        print("timeee")
      
        
        let databaseRef = Database.database().reference()
        var ppo = ""
        var mail = ""
        if messageVC.selectedEmail != ""
        {
            mail = messageVC.selectedEmail
        }
        else if imageDetailsVC.selectedEmail != ""
        {
            mail = imageDetailsVC.selectedEmail
        }
       
        
        
        if mail != ""
        {
            var userid = ""
            if messageVC.useridArray[mail] != nil
            {
                userid = messageVC.useridArray[mail]!
            }
            else
            {
                userid = imageDetailsVC.userid
            }
            
            if messageVC.profilResmi[mail] == nil
            {
                ppo = messageVC.userppimg
                
            }
            else
            {
                ppo = messageVC.profilResmi[mail]!
            }
            

            print("userid",userid)
            print("profilr",ppo)
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss:"
            let utcTime = formatter.string(from: date)
            print("TARIHZAMAN",utcTime)
            
            let mesajFormatiO = ["mesaj":messageText.text,"tarih":utcTime,"kim":"1"]as[String:String]
            let mesajFormatiBen = ["mesaj":messageText.text,"tarih":utcTime,"kim":"0"]as[String:String]

            databaseRef.child("users").child(userid).child("bildirim").child("durum").setValue("1")
            databaseRef.child("users").child(userid).child("message").child((Auth.auth().currentUser?.uid)!).child("email").setValue(Auth.auth().currentUser?.email)
            
            databaseRef.child("users").child(userid).child("message").child((Auth.auth().currentUser?.uid)!).child("time").setValue(utcTime)
            databaseRef.child("users").child(userid).child("message").child((Auth.auth().currentUser?.uid)!).child("userid").setValue(Auth.auth().currentUser?.uid)
            databaseRef.child("users").child(userid).child("message").child((Auth.auth().currentUser?.uid)!).child("profilResmi").setValue(messageVC.myuserppimg)
        databaseRef.child("users").child(userid).child("message").child((Auth.auth().currentUser?.uid)!).child("childMessage").childByAutoId().setValue(mesajFormatiBen)
            
            
            databaseRef.child("users").child((Auth.auth().currentUser?.uid)!).child("message").child(userid).child("email").setValue(mail)
            
            databaseRef.child("users").child((Auth.auth().currentUser?.uid)!).child("message").child(userid).child("time").setValue(utcTime)
            databaseRef.child("users").child((Auth.auth().currentUser?.uid)!).child("message").child(userid).child("userid").setValue(userid)
            
            databaseRef.child("users").child((Auth.auth().currentUser?.uid)!).child("message").child(userid).child("profilResmi").setValue(ppo)
        databaseRef.child("users").child((Auth.auth().currentUser?.uid)!).child("message").child(userid).child("childMessage").childByAutoId().setValue(mesajFormatiO)
            
            messageText.text = ""
        }
        else
        {
            print("mail",mail)
            print("userid",imageDetailsVC.userid)
            print("mesaj olmadi babbba")
        }
    

        
    }
    
    
    
}
