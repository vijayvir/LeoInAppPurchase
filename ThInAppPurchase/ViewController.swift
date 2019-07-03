//
//  ViewController.swift
//  ThInAppPurchase
//
//  Created by tecH on 01/07/19.
//  Copyright © 2019 vijayvir Singh. All rights reserved.
//

import UIKit
import StoreKit

class ViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableview.rowHeight = UITableView.automaticDimension;
        self.tableview.estimatedRowHeight = 200; // set to whatever your "average" cell height is
        // com.realFans.Helium2
        //com.realFans.hydrogen1
        
        LeoInAppPurchase.shared
            .withAppendProductId("com.realFans.Helium2")
            .withAppendProductId("com.realFans.hydrogen1")
            .withAppendProductId("com.realFans.lithium")
           .withAppendProductId("com.realFans.Beryllium")
           
            . actionRequestProductInfo()
            .withClosureInvalidProductIdentifiers({ (indentifiers) in
                print("Invalid : Product ID" ,indentifiers  )
            })
            .withDidUpdatedTransactions({ (transacation) in
                
                switch transacation.transactionState {
                    
                case .purchasing:
                    print("")
                case .purchased:
                      print("")
                case .failed:
                      print("")
                case .restored:
                      print("")
                case .deferred:
                      print("")
                @unknown default:
                      print("")
                }
                
                
                 self.tableview.reloadData()
            })
            .withDidReceiveProducts {
                
               self.tableview.reloadData()
                
           }.fullStop()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func actionRestore(_ sender: UIButton) {
        LeoInAppPurchase.shared.actionRestorePurchases()
        
    }
    
}


extension ViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension;
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return LeoInAppPurchase.shared.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThProductTableviewCell") as! ThProductTableviewCell
        
        if let some = LeoInAppPurchase.shared.products[indexPath.row]  as? SKProduct {
            cell.configure(some)
        }
        
        return cell
        
    }
}

class ThProductTableviewCell : UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var txtDesc: UITextView!
    
    var product : SKProduct?
    
    func configure(_ product : SKProduct){
        title.text = product.localizedTitle
        
        
        if LeoInAppPurchase.shared.actionIsProductPurchased(product.productIdentifier){
            
            title.backgroundColor = .red
            
        } else {
            title.backgroundColor = .clear
        }
        
        self.product = product
        
        var some : String = ""
        
        some.append("localizedDescription :   \(product.localizedDescription) \n ")
       
        some.append("localizedTitle :   \(product.localizedTitle) \n ")
        
        
        some.append("price :   \(product.price) \n ")
        
        
        some.append("priceLocale :   \(product.priceLocale) \n ")
        
        some.append("productIdentifier :   \(product.productIdentifier) \n ")
        
        some.append("isDownloadable :   \(product.isDownloadable) \n ")
        
        
        some.append("downloadContentLengths :   \(product.downloadContentLengths) \n ")
        
        
        some.append("downloadContentVersion :   \(product.downloadContentVersion) \n ")
        
        
        some.append("subscriptionPeriod -> numberOfUnits:   \(product.subscriptionPeriod?.numberOfUnits ) \n ")
      some.append("subscriptionPeriod :   \(product.subscriptionPeriod?.unit.rawValue ) \n ")
        
        some.append("introductoryPrice :   \(product.introductoryPrice) \n ")
        
        
     //   some.append("subscriptionGroupIdentifier :   \(product.subscriptionGroupIdentifier) \n ")
        
        
       // some.append("discounts :   \(product.discounts) \n ")
        
        
        
        
        
        txtDesc.text = some
        
        
    }
    @IBAction func actionTap(_ sender: UIButton) {
        if let product  = product {
            
            LeoInAppPurchase.shared.actionBuyProduct(product)
        }
        
        
    }
    
}

