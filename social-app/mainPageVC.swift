//
//  FirstViewController.swift
//  social-app
//
//  Created by @unknown on 29.10.2018.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import SDWebImage
class mainPageVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    

    @IBOutlet weak var notificationButton: UIBarButtonItem!
    
    
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    static var likeArray = [String]()
    static var tumppArray = [String]()
    static var userEmailArray = [String]()
    static var userCommentArray = [String]()
    static var userImageArray = [String]()
    static var userPredictArray = [String]()
    static var postFiyatArray = [String]()
    static var userIdArray = [String]()
    static var imageId = [String]()
    static var kullaniciBegendimi = [String:String]()
    static var likeDictionary = [String:String]()
    var refresher: UIRefreshControl!
    var count = 0;
    static var notification = ""
    var x = UIImageView()

    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        
        notificationBarButtonImageChanged()
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Yenileniyor")
        refresher.addTarget(self, action: #selector(mainPageVC.refreshButton), for: UIControl.Event.valueChanged)
        collectionView.addSubview(refresher)
        collectionView.delegate = self
        collectionView.dataSource = self
        kenarAyarla()

        
        
    
    }
    func notificationBarButtonImageChanged()
    {
        if mainPageVC.notification == "0"
        {
            notificationButton.image = UIImage(named: "Image-14")
            
        }
        else if mainPageVC.notification == "1"
        {
            notificationButton.image = UIImage(named: "Image")
            
        }
        else
        {
            notificationButton.image = UIImage(named: "Image-14")
        }
    }
  
    @IBAction func notificationButtonClicked(_ sender: Any)
    {
        
        
        let main = self.storyboard?.instantiateViewController(withIdentifier: "tabBar2")
        self.present(main!, animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
         NotificationCenter.default.addObserver(self, selector: #selector(self.xy), name: NSNotification.Name(rawValue: "newImage"), object: nil)
    
       
        
    }
    @objc func xy()
    {
        notificationBarButtonImageChanged()
        if mainPageVC.userImageArray.count < 17
        {
            self.collectionView.reloadData()
        }
        
    }

    
    func kenarAyarla()
    {
        let itemSize = UIScreen.main.bounds.width/3 - 1
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        collectionView.collectionViewLayout = layout
    }
    
    
    @objc func refreshButton()
    {
        let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        delegate.rememberUser()
        refresher.endRefreshing()
    }

    



    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainPageVC.userImageArray.count
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imageDetailsVC.konum = "main"
        imageDetailsVC.comment = mainPageVC.userCommentArray[indexPath.row]
        imageDetailsVC.selectedImage = mainPageVC.userImageArray[indexPath.row]
        imageDetailsVC.predictText = mainPageVC.postFiyatArray[indexPath.row]
        imageDetailsVC.selectedEmail = mainPageVC.userEmailArray[indexPath.row]
        imageDetailsVC.userpp = mainPageVC.tumppArray[indexPath.row]
        imageDetailsVC.userid = mainPageVC.userIdArray[indexPath.row]
        userDetailsVC.email = mainPageVC.userEmailArray[indexPath.row]
        userDetailsVC.userpplink = mainPageVC.tumppArray[indexPath.row]
        imageDetailsVC.imageid = mainPageVC.imageId[indexPath.row]
        imageDetailsVC.likelbl = mainPageVC.likeDictionary[mainPageVC.imageId[indexPath.row]]!
        imageDetailsVC.begendimi = mainPageVC.kullaniciBegendimi[mainPageVC.imageId[indexPath.row]]!
        let imageDetails = self.storyboard?.instantiateViewController(withIdentifier: "imageDetailsTab") as! UINavigationController
        self.present(imageDetails, animated: false, completion: nil)
  
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        cell.tumResimler.sd_setImage(with: URL(string: mainPageVC.userImageArray[indexPath.row]))
        
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        return cell
        
    }
    func arrayIndex(array:[String],searhing:String) -> [Int]
    {   var countArray = [Int]()
        var count = 0
        for prd in array
        {
            if prd.prefix(5) == searhing
            {
                countArray.append(count)
            }
            count = count+1
        }
        
        return countArray
    }
    @IBAction func searchButtonClicked(_ sender: Any) {

        var tempArray = [Int]()
        var newImageArray = [String]()
        var newEmailArray = [String]()
        var newPredictArray = [String]()
       
        if searchText.text == "jeans"
        {
            
            tempArray = arrayIndex(array: mainPageVC.userPredictArray, searhing: "jeans")
          
            let range = mainPageVC.userImageArray.count-1
            let range2 = tempArray.count-1
            for img in 0...range
            {
                for index in 0...range2
                {
                    if img == tempArray[index]
                    {
                    
                       
                        newPredictArray.append(mainPageVC.userPredictArray[img])
                        newEmailArray.append(mainPageVC.userEmailArray[img])
                        newImageArray.append(mainPageVC.userImageArray[img])
                    }
                }
                
            }
            mainPageVC.userImageArray = newImageArray
            mainPageVC.userPredictArray = newPredictArray
            mainPageVC.userEmailArray = newEmailArray
            collectionView.reloadData()
            
            
        }
        else if searchText.text == "shirt"
        {
         
            tempArray = arrayIndex(array: mainPageVC.userPredictArray, searhing: "shirt")
           
            let range = mainPageVC.userImageArray.count-1
            let range2 = tempArray.count-1
            
            for img in 0...range
            {
                for index in 0...range2
                {
                    if img == tempArray[index]
                    {
                     
                        newPredictArray.append(mainPageVC.userPredictArray[img])
                        newEmailArray.append(mainPageVC.userEmailArray[img])
                        newImageArray.append(mainPageVC.userImageArray[img])
                    }
                }
                
            }
            mainPageVC.userImageArray = newImageArray
            mainPageVC.userPredictArray = newPredictArray
            mainPageVC.userEmailArray = newEmailArray
            collectionView.reloadData()

        }
        else if searchText.text == "dress"
        {   
            tempArray = arrayIndex(array: mainPageVC.userPredictArray, searhing: "dress")
          
            let range = mainPageVC.userImageArray.count-1
            let range2 = tempArray.count-1
            for img in 0...range
            {
                for index in 0...range2
                {
                    if img == tempArray[index]
                    {
                        
                    
                        newPredictArray.append(mainPageVC.userPredictArray[img])
                        newEmailArray.append(mainPageVC.userEmailArray[img])
                        newImageArray.append(mainPageVC.userImageArray[img])
                    }
                }
                
            }
            mainPageVC.userImageArray = newImageArray
            mainPageVC.userPredictArray = newPredictArray
            mainPageVC.userEmailArray = newEmailArray
            collectionView.reloadData()

        }
        else
        {
            let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
            delegate.rememberUser()
            
          
        }
        
    }
    
}

