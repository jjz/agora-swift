//
//  MutilChatViewController.swift
//  agora
//
//  Created by jjz on 07/05/2017.
//  Copyright © 2017 jjz. All rights reserved.
//

import Foundation

class  MutilChatViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var remoteView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!

    
    var agoraKit :AgoraRtcEngineKit!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        agoraKit=AgoraRtcEngineKit.sharedEngine(withAppId: AgoraSetting.AgoraAppId, delegate: self)
        agoraKit.enableVideo()
        agoraKit.joinChannel(byKey: nil, channelName: "demo", info: nil, uid: 0) { [weak self](sid,uid,elapsed)->Void in
            if let weakSelf=self{
                weakSelf.agoraKit.setEnableSpeakerphone(true)
                UIApplication.shared.isIdleTimerDisabled=true
            }
        }
        self.collectionView.dataSource=self
        self.collectionView.delegate=self
        
    }
    func setupLocalVideo(){
        agoraKit.setVideoProfile(._VideoProfile_360P, swapWidthAndHeight: false)
        let videoCanvas=AgoraRtcVideoCanvas()
        videoCanvas.uid=0
        //videoCanvas.view=lo
    }
    
    
    @IBAction func handUp(_ sender: Any) {
    }
    @IBAction func mute(_ sender: Any) {
    }
    @IBAction func switchCamera(_ sender: Any) {
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell :ChatCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatCell", for: indexPath) as? ChatCell else {
            fatalError("the dequeued cell is not an instance of ChannelCell")
        }
        cell.agora=agoraKit
        cell.setUid(uid: 0)
        return cell
        
        
    }
    


}
extension MutilChatViewController :AgoraRtcEngineDelegate{
     func rtcEngine(_ engine: AgoraRtcEngineKit!, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int) {
        if(remoteView.isHidden){
            remoteView.isHidden=false
        }
        let videoCanvas=AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.view = remoteView
        videoCanvas.renderMode = .render_Adaptive
        agoraKit.setupRemoteVideo(videoCanvas)
        
    }
    func rtcEngine(_ engine: AgoraRtcEngineKit!, didJoinedOfUid uid: UInt, elapsed: Int) {
        
    }
}
