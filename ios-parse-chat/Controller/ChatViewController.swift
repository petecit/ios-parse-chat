//
//  ChatViewController.swift
//  ios-parse-chat
//
//  Created by peter on 12/8/18.
//  Copyright © 2018 petecit. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var chatMessageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var chatMessages: [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.loadMessages), userInfo: nil, repeats: true)
        
        tableView.reloadData()
    }
    
    @objc func loadMessages() {
        let query = PFQuery(className: "Messages")
        query.addDescendingOrder("createdAt")
        query.limit = 20
        query.includeKey("user")
        query.findObjectsInBackground { (messages, error) in
            if let messages = messages {
                self.chatMessages = messages
                self.tableView.reloadData()
            }
            else {
                print(error!.localizedDescription)
            }
        }
    }
    
    @IBAction func clickSendButton(_ sender: Any) {
        let newMessage = PFObject(className: "Messages")
        newMessage["text"] = chatMessageTextField.text ?? ""
        
        newMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
                
                // clear chat message text field
                self.chatMessageTextField.text = ""
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func clickLogoutButton(_ sender: Any) {
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        let chatMessage = chatMessages[indexPath.row]
        cell.chatMessageLabel.text = chatMessage["text"] as? String
        
        // get username if available
        cell.chatMessageLabel.text = chatMessage["user"] as? String
        if let user = chatMessage["user"] as? PFUser {
            cell.usernameLabel.text = user.username
        } else {
            cell.usernameLabel.text = "Anonymous User"
        }
        return cell
    }
}
