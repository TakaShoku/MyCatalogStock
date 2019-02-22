//
//  Catalog.swift
//  MyCatalogStock
//
//  Created by 曽和寛貴 on 2019/01/20.
//  Copyright © 2019 曽和寛貴. All rights reserved.
//

import Foundation
import RealmSwift

class Catalog: Object {
    
    @objc dynamic var id = 0
    
    @objc dynamic var  name = ""
    
    @objc dynamic var number = ""
    
    @objc dynamic var writer = ""
    
    @objc dynamic var date = Date()
    
    @objc dynamic var count = ""
    
    @objc dynamic var _image: UIImage? = nil
    
    @objc dynamic var image: UIImage? {
        set{
            self._image = newValue
            if let value = newValue {
                self.imageData = value.pngData()! as NSData
            }
        }
        get{
            if let image = self._image {
                return image
            }
            if let data = self.imageData {
                self._image = UIImage(data: data as Data)
                return self._image
            }
            return nil
        }
    }
    @objc dynamic private var imageData: NSData? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["image", "_image"]
    }
    
}


