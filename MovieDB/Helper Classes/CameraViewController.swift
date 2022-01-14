//
//  CameraViewController.swift
//  SeatUs
//
//  Created by Qazi Naveed on 10/31/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController:UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Outlets
    let imagePicker = UIImagePickerController()
    var selectedImage : UIImage? = nil
    var selectedImageURL : NSURL? = nil
    var imageName : String? = nil
    var docImage : UIImage? = nil

    var isAddingDoc : Bool = false
    var isComingFromChangeDP : Bool = false
    var isPickingImage = false
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: - ActionSheet Methods
    func showCameraFromUploadPictures(isComeFromChange:Bool)
    {
        if !isPickingImage {
            isPickingImage = true
            isComingFromChangeDP = isComeFromChange
            showCameraOptions()
        }
    }
    
    func showCameraOptions(){
        
        let actionSheet = UIAlertController.init(title: "Select Photo via", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction( .init(title: "Camera", style: UIAlertAction.Style.default, handler: { (action) in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction.init(title: "Gallery", style: UIAlertAction.Style.default, handler: { (action) in
            self.showCameraRoll()
        }))
        
        if isComingFromChangeDP{
            
            selectedImage = nil
            isComingFromChangeDP = false
            actionSheet.addAction(UIAlertAction.init(title: "Remove Picture", style: UIAlertAction.Style.default, handler: { (action) in
                self.isPickingImage = false
               NotificationCenter.default.post(name: Notification.Name(ApplicationConstants.UserImageChangNotification), object: nil)
            }))
        }
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) in
            self.isPickingImage = false
        }))
        
        self.present(actionSheet, animated: true, completion: nil)
    
    }
    
    func askPermission(){
        let cameraMediaType = AVMediaType.video
        AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
            if granted {
                DispatchQueue.main.async {
                    self.showCameraOptions()
                }
            }
            else {
                DispatchQueue.main.async {
                    self.showCameraSettingsAlert(controller: self)
                }
            }
        }
    }
    
     func showCameraSettingsAlert(controller:UIViewController){

        let alert = UIAlertController(title: "", message: Alert.Message.CameraWarning,
                                      preferredStyle: UIAlertController.Style.alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { action -> Void in
            //Just dismiss the action sheet
        })

        let okAction = UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { action -> Void in
            //Just dismiss the action sheet
            Utility.goToApplicationSettings()
        })
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        controller.present(alert, animated: false, completion: nil)
    }

    
    func isAccessCamera() -> Bool {
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        
        switch cameraAuthorizationStatus {
        case .denied:
            return false
        case .authorized:
            return true
        case .restricted:
            return false
        case .notDetermined:
            return false
        default:
            return false
        }
    }


    
    private func showCamera(){
        
        if isAccessCamera() {
            DispatchQueue.main.async {
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        else{
            askPermission()
        }
    }
    
    private func showCameraRoll(){
        DispatchQueue.main.async {
            self.imagePicker.delegate = self
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }

     func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        let croppedImage = resizeImage(image: image, targetSize: DefaultSizes.imageSize)
        if isAddingDoc{
            docImage = croppedImage
            self.updateDocImages()
        }
        else{
            selectedImage = croppedImage
            if #available(iOS 11.0, *) {
                if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL{
                    let imgName = imgUrl.lastPathComponent
                    selectedImageURL = imgUrl as NSURL
                    imageName = imgName
                    self.updateImageToView()
                }
                else
                {
                    
                    let imgname = "CameraImage" + getCurrentDateString()
                        + ".jpg"
                    print(imgname)
                    let localPath  = saveImageToDocumentDirectory(selectedImage!, filename: imgname)
                    let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
                    let localPath2 = documentDirectory?.appending("/" + imgname)
                    let photoURL = URL.init(fileURLWithPath: localPath2!)//NSURL(fileURLWithPath: localPath!)
                    print(photoURL)
                    selectedImageURL = photoURL as NSURL
                    imageName = imgname
                    self.updateImageToView()
                }
            } else {
                // Fallback on earlier versions
            }
            
        }
        self.isPickingImage = false
        dismiss(animated: true, completion: nil)
    }
    
    func getCurrentDateString() -> String
    {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyyhh:mm:ss"
        let result = formatter.string(from: date)
        return result
    }
    func getImage(fileName:String){
        let fileManager = FileManager.default
        
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let imagePAth = (documentDirectory! as NSString).appendingPathComponent(fileName)
        if fileManager.fileExists(atPath: imagePAth){
            let image = UIImage(contentsOfFile: imagePAth)
        }else{
            print("No Image")
        }
    }
    
    func saveImageToDocumentDirectory(_ chosenImage: UIImage ,filename : String) -> String {
        let directoryPath =  NSHomeDirectory().appending("/Documents/")
        if !FileManager.default.fileExists(atPath: directoryPath) {
            do {
                try FileManager.default.createDirectory(at: NSURL.fileURL(withPath: directoryPath), withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
        let filepath = directoryPath.appending(filename)
        let url = NSURL.fileURL(withPath: filepath)
        do {
            let imageData = chosenImage.jpegData(compressionQuality: 0.75)

            try imageData?.write(to: url, options: .atomic)

            return String.init("/Documents/\(filename)")
            
        } catch {
            print(error)
            print("file cant not be save at path \(filepath), with error : \(error)");
            return filepath
        }
    }
    func removeImage(itemName:String, fileExtension: String) {
        let fileManager = FileManager.default
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        guard let dirPath = paths.first else {
            return
        }
        let filePath = "\(dirPath)/\(itemName).\(fileExtension)"
        do {
            try fileManager.removeItem(atPath: filePath)
        } catch let error as NSError {
            print(error.debugDescription)
        }
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            
        isPickingImage = false
        dismiss(animated: true, completion: nil)
    }
    
    func updateImageToView(){
    }

    func updateDocImages(){
    }

    
}
