//
//  messageBoxVC.swift
//  social-app
//
//  Created by @unknown on 8.01.2019.
//

import UIKit
import Firebase
import FirebaseAuth
class messageBoxVC: UIViewController, UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    static var mesajlar = [Any]()
    static var mailArray = [String]()
    static var profilResmi = [String]()
    static var time = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        datapreprocessing(arr: messageBoxVC.mesajlar)
        
        self.tableView.reloadData()
        let databaseRef = Database.database().reference()

        databaseRef.child("users").child((Auth.auth().currentUser?.uid)!).child("bildirim").child("durum").setValue("0")
        messageVC.mesajArray.removeAll(keepingCapacity: false)
        messageVC.kim.removeAll(keepingCapacity: false)
        messageVC.mesajTarih.removeAll(keepingCapacity: false)
        messageVC.profilResmi.removeAll(keepingCapacity: false)
        messageVC.email.removeAll(keepingCapacity: false)
    }
    override func viewWillAppear(_ animated: Bool)
    {
        NotificationCenter.default.addObserver(self, selector: #selector(self.xy), name: NSNotification.Name(rawValue: "newImage"), object: nil)

        
    }
    @objc func xy()
    {
        print("xy")
        datapreprocessing(arr: messageBoxVC.mesajlar)
        
        self.tableView.reloadData()
        
    }
    func datapreprocessing(arr:Array<Any>)
    {
        messageBoxVC.mailArray.removeAll(keepingCapacity: false)
        messageBoxVC.profilResmi.removeAll(keepingCapacity: false)
        messageBoxVC.time.removeAll(keepingCapacity: false)
        if arr.count != 0
        {
            for i in 0...arr.count-1
            {
                
                for j in arr[i] as! NSDictionary
                {
                    if j.key as! String == "email"
                    {
                        print("jkeykey",j.value)
                        messageBoxVC.mailArray.append(j.value as! String)
                    }
                    else if j.key as! String == "time"
                    {
                        messageBoxVC.time.append(j.value as! String)
                    }
                    else if j.key as! String == "profilResmi"
                    {
                        messageBoxVC.profilResmi.append(j.value as! String)
                        print("asdasdasdasdasdas")
                    }
                    else
                    {
                        continue
                    }
                    
                }
                
            }
            
        }
        
        

    }
    func sort()
    {
        if messageBoxVC.time.count-1 > -1
        {
            for x in 0...messageBoxVC.time.count-1
            {
                for y in 0...messageBoxVC.time.count-1
                {
                    if messageBoxVC.time[x] < messageBoxVC.time[y]
                    {
                        let temp = messageBoxVC.mailArray[y]
                        messageBoxVC.mailArray[y] = messageBoxVC.mailArray[x]
                        messageBoxVC.mailArray[x] = temp
                        let temp2 = messageBoxVC.profilResmi[y]
                        messageBoxVC.profilResmi[y] = messageBoxVC.profilResmi[x]
                        messageBoxVC.profilResmi[x] = temp2
                        
                    }
                    
                }
            }

        }
        
    }
   
 

  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("countt",messageBoxVC.mailArray.count)
        return messageBoxVC.mailArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! messageCell
        if messageBoxVC.profilResmi.count == messageBoxVC.mailArray.count
        {
            print("resimler",messageBoxVC.profilResmi[indexPath.row])
            cell.messageText.text = messageBoxVC.mailArray[indexPath.row]
            cell.profileImage.sd_setImage(with: URL(string: messageBoxVC.profilResmi[indexPath.row]))

        }

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("gonderdim",messageBoxVC.mailArray[indexPath.row])
        messageVC.selectedEmail = messageBoxVC.mailArray[indexPath.row]
        let main = self.storyboard?.instantiateViewController(withIdentifier: "messageTab")
        self.present(main!, animated: false, completion: nil)
    }
    
    @IBAction func backButtonClicked(_ sender: Any)
    {
        let main = self.storyboard?.instantiateViewController(withIdentifier: "tabBar")
        self.present(main!, animated: false, completion: nil)
    }
    

}

