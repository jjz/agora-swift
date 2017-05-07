//
//  MutilChatViewController.swift
//  agora
//
//  Created by jjz on 07/05/2017.
//  Copyright © 2017 jjz. All rights reserved.
//

import Foundation

class  MutilChatViewController: UIViewController,LDWaterflowLayoutDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var remoteView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!

    public var dataArray:Array<UInt>?=Array<UInt>();
    
    var agoraKit :AgoraRtcEngineKit!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        agoraKit=AgoraRtcEngineKit.sharedEngine(withAppId: AgoraSetting.AgoraAppId, delegate: self)
        agoraKit.enableVideo()
        setupLocalVideo()
        agoraKit.joinChannel(byKey: nil, channelName: "demo", info: nil, uid: 0) { [weak self](sid,uid,elapsed)->Void in
            if let weakSelf=self{
                weakSelf.agoraKit.setEnableSpeakerphone(true)
                UIApplication.shared.isIdleTimerDisabled=true
            }
        }
    
        dataArray?.append(1)
        dataArray?.append(2)
        dataArray?.append(3)
        dataArray?.append(4)
        self.collectionView.dataSource=self
        
        let layout :LDWaterflowLayout=LDWaterflowLayout()
        layout.delegate=self
        self.collectionView.collectionViewLayout=layout
    
        
    }
    func setupLocalVideo(){
        agoraKit.setVideoProfile(._VideoProfile_360P, swapWidthAndHeight: false)
        let videoCanvas=AgoraRtcVideoCanvas()
        videoCanvas.uid=1
        videoCanvas.view = remoteView
        videoCanvas.renderMode = .render_Fit
        
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
        return (dataArray?.count)!
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell :ChatCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatCell", for: indexPath) as? ChatCell else {
            fatalError("the dequeued cell is not an instance of ChannelCell")
        }
        cell.agora=agoraKit
        let uid:UInt = dataArray![indexPath.row]

        cell.setUid(uid: uid)
        return cell
        
        
    }
    func waterflowLayout(_ waterflowLayout: LDWaterflowLayout!, heightForItemAt index: UInt, itemWidth: CGFloat) -> CGFloat {
        return 200;
    }
    func columnCount(in waterflowLayout: LDWaterflowLayout!) -> CGFloat {
        return 2
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
        videoCanvas.renderMode = .render_Fit
        agoraKit.setupRemoteVideo(videoCanvas)
        
    }
    func rtcEngine(_ engine: AgoraRtcEngineKit!, didJoinedOfUid uid: UInt, elapsed: Int) {
        if(!(dataArray?.contains(uid))!){
            dataArray?.append(uid)
            collectionView.reloadData()
        }
        
    }
}
