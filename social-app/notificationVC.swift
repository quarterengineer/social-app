//
//  notificationVC.swift
//  social-app
//
//  Created by @unknown on 8.01.2019.
//

import UIKit

class notificationVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    static var bildirim = [Any]()
    static var olay = [String]()
    static var tarih = [String]()
    static var resimler = [String]()
    static var userImage = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        datapreprocessing(arr: notificationVC.bildirim)
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! notificationCell

        cell.notificationText.text = notificationVC.olay[indexPath.row]
        cell.userImage.sd_setImage(with: URL(string: notificationVC.userImage[indexPath.row]))
        cell.sImage.sd_setImage(with: URL(string: notificationVC.resimler[indexPath.row]))
  
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationVC.olay.count
    }
    @IBAction func backButtonClicked(_ sender: Any)
    {
        let main = self.storyboard?.instantiateViewController(withIdentifier: "tabBar")
        self.present(main!, animated: false, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool)
    {
        NotificationCenter.default.addObserver(self, selector: #selector(self.xy), name: NSNotification.Name(rawValue: "newImage"), object: nil)
        
    }
    @objc func xy()
    {
        datapreprocessing(arr: notificationVC.bildirim)
        self.tableView.reloadData()
        
    }
    func datapreprocessing(arr:[Any])
    {
      
        notificationVC.resimler.removeAll(keepingCapacity: false)
        notificationVC.userImage.removeAll(keepingCapacity: false)
        notificationVC.olay.removeAll(keepingCapacity: false)
        notificationVC.tarih.removeAll(keepingCapacity: false)
        if arr.count > 1
        {
  
         
            for i in 0...arr.count-1
            {
                if (arr[i] as AnyObject).count == nil
                {
                    continue
                }
                for j in arr[i] as! NSDictionary
                {
                    if j.key as! String == "sImage"
                    {
                        notificationVC.resimler.append(j.value as! String)
                    }
                    else if j.key as! String == "olay"
                    {
                        notificationVC.olay.append(j.value as! String)
                    }
                    else if j.key as! String == "userImage"
                    {
                        notificationVC.userImage.append(j.value as! String)
                    }
                    else
                    {
                        notificationVC.tarih.append(j.value as! String)
                    }
                    
                }
              
               
            }
            for i in 0...notificationVC.tarih.count-1
            {
                for j in 0...notificationVC.tarih.count-1
                {
                    if notificationVC.tarih[i] > notificationVC.tarih[j]
                    {
                        let temp = notificationVC.tarih[j]
                        notificationVC.tarih[j] = notificationVC.tarih[i]
                        notificationVC.tarih[i] = temp
                        
                        let temp2 = notificationVC.olay[j]
                        notificationVC.olay[j] = notificationVC.olay[i]
                        notificationVC.olay[i] = temp2
                        
                        let temp3 = notificationVC.resimler[j]
                        notificationVC.resimler[j] = notificationVC.resimler[i]
                        notificationVC.resimler[i] = temp3
                        
                        let temp4 = notificationVC.userImage[j]
                        notificationVC.userImage[j] = notificationVC.userImage[i]
                        notificationVC.userImage[i] = temp4
                        
                        
                    }
                }
            }
            
              
        }
      
        
        
      
    }

}
