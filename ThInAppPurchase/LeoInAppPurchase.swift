//
//  LeoInAppPurchase.swift
//  ThInAppPurchase
//
//  Created by tecH on 01/07/19.
//  Copyright © 2019 vijayvir Singh. All rights reserved.
//
import StoreKit

import Foundation
class LeoInAppPurchase : NSObject {
    static let shared = LeoInAppPurchase()
    private override init() {
        super.init()
        
        
        
    }
    enum PurchaseType {
        case consumable
        case nonConsumable
        case renewableSubscriptions
        case nonRenewableSubscriptions
    }
    private var productIDs: Set<String> = []
    private  var productsArray:  Set<SKProduct> = []
    private var purchasedProductIdentifiers: Set<String> {
        
        var some : Set<String> = []
        
        for  productID in productIDs {
            let purchased = UserDefaults.standard.bool(forKey: productID)
            if purchased {
                  some.insert(productID)
            }
        }
        return some
    }
    
    
    var closureDidRecivesProduct : (() -> Void)?
    var closureDidUpdatedTransactions : ((SKPaymentTransaction) -> Void)?
    
    var closureInvalidProductIdentifiers  : (([String]) -> Void)?
    
    var products :  [SKProduct]  {
    let some = productsArray.map { (SKProduct) -> SKProduct in
            return SKProduct
        }
        return some
    }
    
    func configure() {
        // com.realFans.Helium2
        //com.realFans.hydrogen1

    }
    
    
    func  fullStop(){
        
    }
    
    
    func  withDidUpdatedTransactions ( _ callback : ((SKPaymentTransaction) -> Void)? = nil  ) ->  LeoInAppPurchase{
        
        closureDidUpdatedTransactions = callback
        
        return self
    }
    
    
    func  withDidReceiveProducts ( _ callback : (() -> Void)? = nil  ) ->  LeoInAppPurchase{
        
        closureDidRecivesProduct = callback
        
        return self
    }
    
    func  withClosureInvalidProductIdentifiers( _ callback : (([String]) -> Void)? = nil  ) ->  LeoInAppPurchase{
        
        closureInvalidProductIdentifiers = callback
        
        return self
    }
    
    
    func withAppendProductId(_ value : String) -> LeoInAppPurchase {
        productIDs.insert(value)
        
        return self
    }
    
    func actionRequestProductInfo()  -> LeoInAppPurchase{
        if SKPaymentQueue.canMakePayments() {
            let productRequest = SKProductsRequest(productIdentifiers: productIDs)
            
            productRequest.delegate = self
            productRequest.start()
            // observe for the transactions:
            SKPaymentQueue.default().add(self)
        }
        else {
            print("Cannot perform In App Purchases.")
        }
        
        return  self
    }
    
    public func actionRestorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    public func actionBuyProduct(_ product: SKProduct) {
        print("Buying \(product.productIdentifier)...")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    public func actionCanMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    public func actionIsProductPurchased(_ productIdentifier: String) -> Bool {
        return purchasedProductIdentifiers.contains(productIdentifier)
    }

    
    
    
}
extension LeoInAppPurchase : SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count != 0 {
            for product in response.products {
                productsArray.insert(product)
                
            }
            closureDidRecivesProduct?()
            
        }
        else {
            print("There are no products.")
        }
        if response.invalidProductIdentifiers.count != 0 {
            
            closureInvalidProductIdentifiers?(response.invalidProductIdentifiers)
            
            
        }
        
        
        
    }
    
    
}

extension LeoInAppPurchase : SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            
            print("*********" , transaction.payment.productIdentifier)
            
            switch transaction.transactionState {
            case SKPaymentTransactionState.purchased:
                print("Transaction completed successfully.")
                SKPaymentQueue.default().finishTransaction(transaction)
                 UserDefaults.standard.set(true, forKey:  transaction.payment.productIdentifier)
                
            case SKPaymentTransactionState.failed:
                print("Transaction Failed");
                SKPaymentQueue.default().finishTransaction(transaction)
              //  transactionInProgress = false
                

            case .purchasing:
                print("purchasing")
            case .restored:
                     print("restoreddd" , transaction.payment.productIdentifier)
                
                     UserDefaults.standard.set(true, forKey:  transaction.payment.productIdentifier)
                    SKPaymentQueue.default().finishTransaction(transaction)
                
            case .deferred:
                     print("deferred")
            @unknown default:
                     print("Please see here ")
            }
            closureDidUpdatedTransactions?(transaction)
            
        }
        
    }
    
    
}
