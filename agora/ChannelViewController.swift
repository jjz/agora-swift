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
class ChannelViewController: UITableViewController {
    public var dataArray:Array<Channel>? = Array<Channel>()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let channelSignle :Channel = Channel()
        channelSignle.name="一对一"
        channelSignle.imagePath=""
        let channelMulti:Channel=Channel()
        channelMulti.name="多对多"
        channelMulti.imagePath=""
        dataArray?.append(channelSignle)
        dataArray?.append(channelMulti)
      
        

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.register(ChannelCell.self, forCellReuseIdentifier: "ChannelCell")
        
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataArray?.count)!
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell :ChannelCell = tableView.dequeueReusableCell(withIdentifier: "ChannelCell",for:indexPath) as?  ChannelCell else{
                fatalError("the dequeued cell is not an instance of ChannelCell")
        }
                let channel:Channel = dataArray![indexPath.row]
               cell.labChannelName.text=channel.name
                cell.imgChannelIcon.image=UIImage();
                return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
}
