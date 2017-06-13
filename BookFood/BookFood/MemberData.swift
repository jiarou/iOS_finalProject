//
//  MemberData.swift
//  BookFood
//
//  Created by JohnLiu on 2017/6/13.
//  Copyright © 2017年 teamFour. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class MemberData: UIViewController {
    
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var address: UITextField!
    var userEmail: String = ""
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.email.text = userEmail
        loadData()
    }

    
    @IBAction func submit(_ sender: Any) {
    }
    func loadData(){
        self.ref = Database.database().reference()
        self.userEmail = self.userEmail.replacingOccurrences(of: ".", with: ",")
        print(self.userEmail)
        self.ref.child("users").child(self.userEmail).observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists() { return }
            let value = snapshot.value as? NSDictionary
            self.password.text = value?["password"] as? String ?? ""
        })
    }

}
