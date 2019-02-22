//
//  ViewController.swift
//  MyCatalogStock
//
//  Created by 曽和寛貴 on 2019/01/19.
//  Copyright © 2019 曽和寛貴. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Realmインスタンスを取得する
    let realm = try! Realm()
    
    // DB内のタスクが格納されるリスト。
    // 日付近い順\順でソート：降順
    // 以降内容をアップデートするとリスト内は自動的に更新される。
    var catalogArray = try! Realm().objects(Catalog.self).sorted(byKeyPath: "date", ascending: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.reloadData()
        print(Realm.Configuration.defaultConfiguration.fileURL as Any)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfColums: CGFloat = 2
        let width = collectionView.frame.size.width
        let xInsets: CGFloat = 10
        let cellSpacing: CGFloat = 5
        
        
        return CGSize(width: (width/numberOfColums) - (xInsets + cellSpacing), height: ((width/numberOfColums) - (xInsets + cellSpacing)))
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //データの個数を返すメソッド
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.catalogArray.count
    }
    
    //データを返すメソッド
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //コレクションビューから識別子「CatalogCell」のセルを取得する。
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatalogCell", for: indexPath) as! CataCell
        
        let catalog = catalogArray[indexPath.row]
        cell.carLabel?.text = catalog.name
        cell.carRest?.text = catalog.count
        cell.carImage?.image = catalog.image
    
        return cell
    }
    
    // セルをタップした時に呼ばれる
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "CellSegue", sender: nil)
        print("セルを押しました")
    }
    
//    一覧画面から編集画面へのデータの受け渡し
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let newInputViewController: NewInputViewController = segue.destination as! NewInputViewController
        
        if segue.identifier == "CellSegue" {
            let indexPath = self.collectionView.indexPathsForSelectedItems?.first
            newInputViewController.catalog = catalogArray[indexPath!.row]
        } else {
            let catalog = Catalog()
            catalog.date = Date()
            
            let allTasks = realm.objects(Catalog.self)
            if allTasks.count != 0 {
                catalog.id = allTasks.max(ofProperty: "id")! + 1
            }
            
            newInputViewController.catalog = catalog
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }

}

