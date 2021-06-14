//
//  FilePickerController.swift
//  Smart Care
//
//  Created by Suleman Ali on 03/05/2021.
//


import UIKit
import MobileCoreServices

public protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?)
}

open class ImagePicker: NSObject {
    var didSelect: ((_ info: [UIImagePickerController.InfoKey : Any] ,_ fileUrl:URL?)->())? //an optional function
    var docPicker: DocumentPicker!
    var didSelectFolder:(()->())?
    
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
   // private weak var delegate: ImagePickerDelegate?

//    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
    public init(presentationController: UIViewController) {

        self.pickerController = UIImagePickerController()

        super.init()

        self.presentationController = presentationController
        //self.delegate = delegate
        self.docPicker = DocumentPicker(presentationController: presentationController)

        self.pickerController.delegate = self
        self.pickerController.allowsEditing = false
        self.pickerController.mediaTypes = ["public.image"]
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }
    
    public func present(from sourceView: UIView,documentOption:Bool = false,folder:Bool = false) {

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if folder == true{
            let folder = UIAlertAction(title: "Create a folder".localized, style: .default)
            { (action) in
                self.didSelectFolder!()
            }
            alertController.addAction(folder)

        }
        if let action = self.action(for: .camera, title: "Take a photo".localized) {
            alertController.addAction(action)
        }
        if documentOption == true{
            let document = UIAlertAction(title: "Browse file".localized, style: .default)
            { (action) in
                self.docPicker.present(from: sourceView)
                self.docPicker.didSelect = { fileUrl in
                    self.didSelect!([:], fileUrl)
                }
            }
            alertController.addAction(document)

        }
        if let action = self.action(for: .photoLibrary, title: "Photo library".localized) {
            alertController.addAction(action)
        }
        alertController.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }

        self.presentationController?.present(alertController, animated: true)
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect info: [UIImagePickerController.InfoKey : Any]) {
        if info.count != 0{
            didSelect!(info, nil)
        }
       

        controller.dismiss(animated: true, completion: nil)
        //self.delegate?.didSelect(image: image)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: [:])
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.pickerController(picker, didSelect: info)


    }
}

extension ImagePicker: UINavigationControllerDelegate {
    
}




//MARK: -

class DocumentPicker: NSObject ,UIDocumentPickerDelegate,UINavigationControllerDelegate {
        
    var didSelect: ((_ fileUrl: URL?)->())? //an optional function

    private let pickerController: UIDocumentPickerViewController
    private weak var presentationController: UIViewController?

    
    public init(presentationController: UIViewController) {

        let types = ["public.item","com.microsoft.word.doc","com.microsoft.word.docx","org.openxmlformats.wordprocessingml.document", kUTTypePDF as String ,kUTTypeRTFD as String , kUTTypeTXNTextAndMultimediaData as String, "com.apple.iwork.pages.pages", "com.apple.iwork.numbers.numbers", "com.apple.iwork.keynote.key","public.image", "public.text","public.text" ,kUTTypeText as String ,"com.microsoft.excel.xls", "com.microsoft.powerpoint.ppt"
        ]
        self.pickerController = UIDocumentPickerViewController(documentTypes: types, in: .import)

        super.init()

        self.presentationController = presentationController
        self.pickerController.delegate = self
    }

  
    public func present(from sourceView: UIView) {
        pickerController.delegate = self
        pickerController.modalPresentationStyle = .formSheet
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            pickerController.popoverPresentationController?.sourceView = sourceView
            pickerController.popoverPresentationController?.sourceRect = sourceView.bounds
            pickerController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }

        self.presentationController?.present(pickerController, animated: true)

    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        //print(urls)
        let url = urls[0]
       // let anyvar =  String(describing: url)

        didSelect!(url)
    }
    

     func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }


}
