//
//  RestaurantViewController.swift
//  BookFood
//
//  Created by jiarou on 2017/6/8.
//  Copyright © 2017年 teamFour. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase



class RestaurantViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
     var ref: DatabaseReference!
     var shop_number = 0
     var shop_name = [String]()
     var RestaurantInfo = [Shop]()
     var refHandle: UInt!
   
    
    @IBOutlet weak var mycollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         ref = Database.database().reference()
               getfirebaseDATA()
        
    
    }

    func gerfirebaseShoname() -> Array<Any>  {
        ref = Database.database().reference().child("Restuarant")
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            let jason =  snapshot.value as? [String: AnyObject]
            self.shop_number = (jason?.count)!
            for i in 1...self.shop_number {
                let firebase_shop = "shop" + String(i)
                self.ref.child(firebase_shop).observe(DataEventType.value, with: { (snapshot) in
            func GetShopNameArray() -> Array<Any>{
                        var every_shop = snapshot.value as? [String: AnyObject]
                        //print(every_shop!["name"] <#default value#>?? )
                        self.shop_name.append(every_shop!["name"] as! String)
                        print(self.shop_name)
                     return  self.shop_name
                    }
                   self.shop_name = GetShopNameArray() as! [String]
                })
                           }
        })
        return  shop_name
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return  RestaurantInfo.count//Menuimge.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RestaurantCell", for: indexPath) as! RestaurantCollectionViewCell
        // Configure the cell
        do{
        cell.Restaurantimg.image = UIImage(data: try NSData(contentsOf:NSURL(string: RestaurantInfo[indexPath.row].shop_img!)! as URL) as Data)
        }catch let error{
          NSLog("got an error creating the request: \(error)")
        }
   //     cell.MoneyView.text = ItemMony[indexPath.row]

             cell.RestaurantName.text =  self.RestaurantInfo[indexPath.row].name
   
       
        //cell.StorageView.text = ItemStorage[indexPath.row]
        return cell
    }
    func getfirebaseDATA() {
        refHandle = ref.child("Restuarant").observe(.childAdded, with: { (snapshot) in
            if let dictionry = snapshot.value as? [String : AnyObject] {
                var shop = Shop()
                shop.setValuesForKeys(dictionry)
                self.RestaurantInfo.append(shop)
                print(self.RestaurantInfo)
                DispatchQueue.main.async {
                self.mycollection?.reloadData()
                 print(self.RestaurantInfo)
                    // Depends if you were populating a collection view or table view
                }
                
            }
        })
         self.RestaurantInfo = []
        
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
