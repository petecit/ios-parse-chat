//
//  ChatViewController.swift
//  ios-parse-chat
//
//  Created by peter on 12/8/18.
//  Copyright © 2018 petecit. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController {

    @IBOutlet weak var chatMessageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickSendButton(_ sender: Any) {
        let chatMessage = PFObject(className: "Message")
        chatMessage["text"] = chatMessageTextField.text ?? ""
        
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
                
                // clear chat message text field
                self.chatMessageTextField.text = ""
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
    }
    

}
