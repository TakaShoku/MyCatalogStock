//
//  NewInputViewController.swift
//  MyCatalogStock
//
//  Created by 曽和寛貴 on 2019/01/20.
//  Copyright © 2019 曽和寛貴. All rights reserved.
//

import UIKit
import RealmSwift

class NewInputViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var catalogName: UITextField!
    @IBOutlet weak var catalogNumber: UITextField!
    @IBOutlet weak var writer: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var catalogCount: UITextField!
    @IBOutlet weak var catalogImage: UIImageView!

    var catalog: Catalog!
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        catalogName.text = catalog.name
        catalogNumber.text = catalog.number
        writer.text = catalog.writer
        datePicker.date = catalog.date
        catalogCount.text = "\(catalog.count)枚"
        catalogImage.image = catalog.image
        
        if catalogImage.image == nil {
            catalogImage.image = UIImage(named: "IMG_0379.JPG")
        } else {
            catalogImage.layoutIfNeeded()
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func imageButton(_ sender: Any) {
//         カメラロールが利用可能か？
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            // 写真を選ぶビュー
            let pickerView = UIImagePickerController()
            // 写真の選択元をカメラロールにする
            // 「.camera」にすればカメラを起動できる
            pickerView.sourceType = .photoLibrary
            // デリゲート
            pickerView.delegate = self
            // ビューに表示
            self.present(pickerView, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 選択した写真を取得する
        let photo = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        // ビューに表示する
        self.catalogImage.image = photo
        // 写真を選ぶビューを引っ込める
        self.dismiss(animated: true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write {
            
            self.catalog.name = self.catalogName.text!
            self.catalog.number = self.catalogNumber.text!
            self.catalog.writer = self.writer.text!
            self.catalog.date = self.datePicker.date
            self.catalog.count = self.catalogCount.text!
            self.catalog.image = self.catalogImage.image
            
            self.realm.add(self.catalog, update: true)
        }
    
//         func dismissKeyboard(){
//        // キーボードを閉じる
//        view.endEditing(true)
//    }

    super.viewWillDisappear(animated)
  }
}
