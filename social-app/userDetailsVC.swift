//
//  userDetailsVC.swift
//  social-app
//
//  Created by @unknown on 12.12.2018.
//

import UIKit
import Firebase
class userDetailsVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    var postImage = [String]()
    var yorumlar = [String]()
    var kullaniciBegendimi = [String:String]()
    var likeDictionary = [String:String]()

    var likeArray = [String]()
    var tumppArray = [String]()
    var userPredictArray = [String]()
    var postFiyatArray = [String]()
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var userIdArray = [String]()
    var imageId = [String]()
    
    
    static var email = ""
    static var userpplink = ""
    
    @IBOutlet weak var userppimg: UIImageView!
    
    @IBOutlet weak var collectionView3: UICollectionView!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    


    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        userppimg.setRounded()
        collectionView3.delegate = self
        collectionView3.dataSource = self
        userppimg.sd_setImage(with: URL(string: userDetailsVC.userpplink))
        messageVC.userppimg = userDetailsVC.userpplink
        kenarAyarla()
        getDataFromFirebase()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func mesaggeButtonClicked(_ sender: Any)
    {
        let imageDetails = self.storyboard?.instantiateViewController(withIdentifier: "messageTab") as! UINavigationController
        self.present(imageDetails, animated: false, completion: nil)
        messageVC.selectedEmail = imageDetailsVC.selectedEmail
    }
    func kenarAyarla()
    {
        let itemSize = UIScreen.main.bounds.width/3 - 1
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        collectionView3.collectionViewLayout = layout
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return postImage.count
    }
    func collectionView(_ collectionView3: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView3.dequeueReusableCell(withReuseIdentifier: "Cell3", for: indexPath) as! CollectionViewCell3
        cell.kullaniciPost.sd_setImage(with: URL(string: postImage[indexPath.row]))
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imageDetailsVC.konum = "uD"
        imageDetailsVC.selectedImage = postImage[indexPath.row]
        imageDetailsVC.begendimi = self.kullaniciBegendimi[self.imageId[indexPath.row]]!
        imageDetailsVC.likelbl = self.likeDictionary[self.imageId[indexPath.row]]!
        imageDetailsVC.comment = self.userCommentArray[indexPath.row]
        imageDetailsVC.predictText = postFiyatArray[indexPath.row]
        imageDetailsVC.selectedEmail = userEmailArray[indexPath.row]
        imageDetailsVC.userid = userIdArray[indexPath.row]
        imageDetailsVC.imageid = imageId[indexPath.row]
        userDetailsVC.email = userEmailArray[indexPath.row]
        imageDetailsVC.likelbl = likeDictionary[imageId[indexPath.row]]!
        imageDetailsVC.begendimi = kullaniciBegendimi[imageId[indexPath.row]]!
        

       
        
        
        
        
        
        
  
        let imageDeatils = self.storyboard?.instantiateViewController(withIdentifier: "imageDetailsTab") as! UINavigationController
        self.present(imageDeatils, animated: false, completion: nil)
    }
    func getDataFromFirebase(){
 
      
        let databaseReference = Database.database().reference().child("users")
        databaseReference.observe(.childAdded) { (snapshot) in
            let values = snapshot.value! as! NSDictionary
            
            if let post = values["post"]
            {
                
                let postID = (post as! NSDictionary).allKeys
                for id in postID {
                    let singlePost = (post as! NSDictionary)[id] as! NSDictionary
                    if(userDetailsVC.email == (singlePost["postedby"] as! String))
                    {
                      
                        self.imageId.append(id as! String)
                        self.userIdArray.append(singlePost["userid"] as! String)
                        self.userCommentArray.append(singlePost["posttext"] as! String)
                        self.userEmailArray.append(singlePost["postedby"] as! String)
                        self.userPredictArray.append(singlePost["predict"] as! String)
                        self.postFiyatArray.append(singlePost["fiyat"] as! String)
                        
                        if let yorum = singlePost["yorum"]
                        {
                            let yorumlar = (yorum as! NSDictionary).allValues
                            yorumVC.yorumlar[id as! String] = (yorumlar)
                            
                        }
                        if !(self.postImage.contains(singlePost["image"] as! String))
                        {
                            self.postImage.append(singlePost["image"] as! String)
                        }
                        
                        let singlePost = (post as! NSDictionary)[id] as! NSDictionary
                        if let like = singlePost["like"]
                        {
                            
                            let x = ((like as! NSDictionary).allKeys) as! [String]
                            
                            if Auth.auth().currentUser?.uid != nil
                            {
                                self.kullaniciBegendimi[id as! String] = (String(x.contains((Auth.auth().currentUser?.uid)!)))
                            }
                            self.likeDictionary[id as! String] = String((like as! NSDictionary).count)
                        }
                        else
                        {
                            self.likeDictionary[id as! String] = "0"
                            self.kullaniciBegendimi[id as! String] = "false"
                            
                        }
                        
                        
                    }
                }
                self.collectionView3.reloadData()
                
                
            }
        }
        
    }



    
}
