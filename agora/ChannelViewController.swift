//
//  ChannelViewController.swift
//  agora
//
//  Created by jjz on 02/05/2017.
//  Copyright © 2017 jjz. All rights reserved.
//

import Foundation

class Channel: NSObject {
    public var name:String?
    public var imagePath:String?
}
class ChannelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    public var dataArray:Array<Channel>? = Array<Channel>()
    //private var agoraKit : AgoraRtcEngineKit

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bgView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let channelSignle :Channel = Channel()
        channelSignle.name="一对一"
        channelSignle.imagePath="signle"
        let channelMulti:Channel=Channel()
        channelMulti.name="多对多"
        channelMulti.imagePath="multi"
        dataArray?.append(channelSignle)
        dataArray?.append(channelMulti)
      
        

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource=self
        self.tableView.delegate=self
        //self.tableView.register(ChannelCell.self, forCellReuseIdentifier: "ChannelCell")
        
        
    }
     func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataArray?.count)!
    }
   
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell :ChannelCell = tableView.dequeueReusableCell(withIdentifier: "ChannelCell",for:indexPath) as?  ChannelCell else{
                fatalError("the dequeued cell is not an instance of ChannelCell")
        }
                let channel:Channel = dataArray![indexPath.row]
               cell.labChannelName.text=channel.name
        cell.imgChannelIcon.image=UIImage(named:channel.imagePath!);
                return cell
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row==0){
            self.performSegue(withIdentifier: "ToSignle", sender:nil )
        }
    }
    
}
