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
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bgView: UIView!
    
    
    public var dataArray:Array<Channel>? = Array<Channel>()
    private var agoraKit : AgoraRtcEngineKit!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let channelSignle :Channel = Channel()
        channelSignle.name="一对一"
        channelSignle.imagePath="signle"
        let channelMulti:Channel=Channel()
        channelMulti.name="多对多"
        channelMulti.imagePath="multi"
        dataArray?.append(channelSignle)
        dataArray?.append(channelMulti)
    
        self.tableView.dataSource=self
        self.tableView.delegate=self
    
          agoraKit=AgoraRtcEngineKit.sharedEngine(withAppId: AgoraSetting.AgoraAppId, delegate: self)
        agoraKit.enableVideo()
        agoraKit.setVideoProfile(._VideoProfile_480P, swapWidthAndHeight: false)
        let videoCanvas=AgoraRtcVideoCanvas()
        videoCanvas.uid=0
        videoCanvas.view=bgView
        videoCanvas.renderMode = .render_Adaptive
        agoraKit.setupLocalVideo(videoCanvas)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        agoraKit.startPreview()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        agoraKit.startPreview()
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
        }else if(indexPath.row==1){
            self.performSegue(withIdentifier: "ToMutil", sender: nil)
        }
    }
    
}
extension ChannelViewController:AgoraRtcEngineDelegate{
    func rtcEngine(_ engine: AgoraRtcEngineKit!, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int) {
        

        
    }
    func rtcEngine(_ engine: AgoraRtcEngineKit!, didLeaveChannelWith stats: AgoraRtcStats!) {
        
    }
    func rtcEngine(_ engine: AgoraRtcEngineKit!, didVideoEnabled enabled: Bool, byUid uid: UInt) {
        
    }
}





