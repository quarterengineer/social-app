//
//  signInVC.swift
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
import CoreML
import Vision

class exploreVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate{

    @IBOutlet weak var fiyatText: UITextField!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postText: UITextView!
    var imageDetails = ""
    override func viewDidLoad() {
        fiyatText.text = ""
        super.viewDidLoad()
        postText.delegate = self

        postImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(exploreVC.selectImage))
        postImage.addGestureRecognizer(gestureRecognizer)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    @objc func selectImage()
    {
        let pickerController=UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        present(pickerController,animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.postImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
  
        
    }
    func textViewDidBeginEditing(_ textField: UITextView) {
        if textField == postText {
            postText.text = ""
        }
    }
    
    @IBAction func postClicked(_ sender: Any) {
        view.endEditing(true)
        let storageRef = Storage.storage().reference()
        let mediaFolder = storageRef.child("media")
        self.predict(image: self.postImage.image!)
        if let data = self.postImage.image?.jpegData(compressionQuality: 0.5)
        {
            let uuid = NSUUID().uuidString
            let mediaImageRef = mediaFolder.child("\(uuid).jpg")
            mediaImageRef.putData(data, metadata:nil){(metadata,error) in
                
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
                            let post = ["image":imageUrl!,"postedby":Auth.auth().currentUser!.email!,"posttext":self.postText.text!,"uuid":uuid,"predict":self.imageDetails,"fiyat":self.fiyatText.text!,"userid":Auth.auth().currentUser!.uid]as[String: Any]
                            databaseRef.child("users").child((Auth.auth().currentUser?.uid)!).child("post").childByAutoId().setValue(post)
                                
                            self.postText.text = "";
                            self.postImage.image = UIImage(named: "image_placeholder");
                            self.fiyatText.text = ""
                            let main = self.storyboard?.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
                            self.present(main, animated: false, completion: nil)
                            
                        }
                    })
                }
            }
        }
  
        
 
    }

    
    func predict(image:UIImage)
    {
        self.imageDetails = ""
        do
        {
            let model = try! VNCoreMLModel(for: fashionCNN().model)
            let request = VNCoreMLRequest(model: model)
            {(request,error)in
                
                if var results = request.results as? [VNClassificationObservation]
                {
                    for i in 0...0
                    {
                        let x = results[i]
                        self.imageDetails += (x.identifier + (" "+(String(x.confidence*100))))
                        
                    }
                    
                }
            }
            request.imageCropAndScaleOption = .centerCrop
            let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
            do
            {
                try handler.perform([request])
            } catch
            {
                print(error)
            }
        }
    }
}
