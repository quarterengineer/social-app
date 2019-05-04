//
//  SecondViewController.swift
//  social-app
//
//  Created by @unknown on 29.10.2018.
//\
extension UIImageView {
    
    func setRounded() {
        self.contentMode = .scaleAspectFill
        self.layer.cornerRadius = (self.frame.width / 2) //instead of let radius = CGRectGetWidth(self.frame) / 2
        self.layer.masksToBounds = true
        
     
    }
}
import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import SDWebImage
class myProfileVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource{

    
    @IBOutlet weak var collectionView2: UICollectionView!
    @IBOutlet weak var userImage: UIImageView!
    static var userEmailArray = [String]()
    static var userCommentArray = [String]()
    static var userImageArray = [String]()
    static var userPredictArray = [String]()
    static var postFiyatArray = [String]()
    static var userProfileImage = ""
    static var imageId = [String]()
    static var count = 0;
    var imageCount = 0 ;
    override func viewDidLoad()
    {
        userImage.setRounded()
        super.viewDidLoad()
      
        userImage.sd_setImage(with: URL(string: myProfileVC.userProfileImage))
        view.backgroundColor = .white
        navigationItem.title = Auth.auth().currentUser?.email
   
        navigationItem.rightBarButtonItem = UIBarButtonItem(title:"Çıkış Yap", style: .done, target: self, action: #selector(logoutClicked(_:)))

        userImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(myProfileVC.selectUserImage))
        userImage.addGestureRecognizer(gestureRecognizer)
        collectionView2.delegate = self
        collectionView2.dataSource = self
        kenarAyarla()
        
       
        
        
    }
  

    override func viewWillAppear(_ animated: Bool)
    {
        NotificationCenter.default.addObserver(self, selector: #selector(self.xy), name: NSNotification.Name(rawValue: "newImage"), object: nil)


    }

    @objc func xy()
    {
        if myProfileVC.count == 0
        {
            if myProfileVC.userProfileImage != ""
            {
                userImage.sd_setImage(with: URL(string: myProfileVC.userProfileImage))
                myProfileVC.count = 1
            }
            
        }
        
        self.collectionView2.reloadData()
    }
    func kenarAyarla()
    {
        let itemSize = UIScreen.main.bounds.width/3 - 1
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        collectionView2.collectionViewLayout = layout
        
    }
    @objc func selectUserImage()
    {

        let pickerController=UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        present(pickerController,animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        userImage.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        self.userImageChanged()
        let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        delegate.rememberUser()
    }
    
    func userImageChanged()
    {
    
        let storage = Storage.storage().reference()
        let mediaFolder = storage.child("media")
        if let data = userImage.image?.jpegData(compressionQuality: 0.5)
        {
            let mediaImageRef = mediaFolder.child("\(String(describing: Auth.auth().currentUser?.uid)).userImage.jpg")
            mediaImageRef.putData(data,metadata:nil){(metadata,error) in
                if error != nil
                {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                else
                {

                    mediaImageRef.downloadURL(completion: { (url, error) in
                        if error == nil
                        {
                            let imageUrl = url?.absoluteString
                            let databaseRef = Database.database().reference()
                            let post = ["image":imageUrl!]
                        databaseRef.child("users").child((Auth.auth().currentUser?.uid)!).child("userImage").setValue(post)
                            
                            
                        }
                    })
                }
            }
        }
       

    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        let signOutAction = UIAlertAction(title: "Çıkış Yap", style: .destructive) { (action) in
            do {
                self.userImage.image = UIImage(named: "userImage");
                UserDefaults.standard.removeObject(forKey: "user")
                UserDefaults.standard.synchronize()
                
                let signIn = self.storyboard?.instantiateViewController(withIdentifier: "signIn") as! signInVC
                
                let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                
                delegate.window?.rootViewController = signIn
                
                
                do {
                   
                    try Auth.auth().signOut()
                    

                }
                catch let err {
                    print("Failed to sign out with error", err)
                    signInVC.showAlert(on: self, style: .alert, title: "Sign Out Error", message: err.localizedDescription)
                }
                
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        signInVC.showAlert(on: self, style: .actionSheet, title: nil, message: nil, actions: [signOutAction, cancelAction], completion: nil)
        
    }
    
    
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myProfileVC.userImageArray.count
        
        
    }
    
    func collectionView(_ collectionView2: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView2.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath) as! CollectionViewCell2
        cell.kullaniciResimleri.sd_setImage(with: URL(string: myProfileVC.userImageArray[indexPath.row]))
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imageDetailsVC.imageid = myProfileVC.imageId[indexPath.row]
        imageDetailsVC.userid = (Auth.auth().currentUser?.uid)!
        userDetailsVC.email = myProfileVC.userEmailArray[indexPath.row]
        userDetailsVC.userpplink = myProfileVC.userProfileImage
        imageDetailsVC.userpp = myProfileVC.userProfileImage
        imageDetailsVC.selectedImage = myProfileVC.userImageArray[indexPath.row]
        imageDetailsVC.predictText = myProfileVC.postFiyatArray[indexPath.row]
        imageDetailsVC.selectedEmail = myProfileVC.userEmailArray[indexPath.row]
        imageDetailsVC.likelbl = mainPageVC.likeDictionary[myProfileVC.imageId[indexPath.row]]!
        imageDetailsVC.begendimi = mainPageVC.kullaniciBegendimi[myProfileVC.imageId[indexPath.row]]!
        imageDetailsVC.comment = myProfileVC.userCommentArray[indexPath.row]
        let imageDeatils = self.storyboard?.instantiateViewController(withIdentifier: "imageDetailsTab") as! UINavigationController
        self.present(imageDeatils, animated: false, completion: nil)
        
        
    }
   
 

    
    

    

}

