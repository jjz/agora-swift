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
    private var isSelect :Bool!=false
    private var  localUid:UInt=UInt(arc4random())
    
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
    
        dataArray?.append(localUid)
        
        self.collectionView.dataSource=self
        
        let layout :LDWaterflowLayout=LDWaterflowLayout()
        layout.delegate=self
        self.collectionView.collectionViewLayout=layout
    
        
    }
    func setupLocalVideo(){
        agoraKit.setVideoProfile(._VideoProfile_360P, swapWidthAndHeight: false)
        let videoCanvas=AgoraRtcVideoCanvas()
        videoCanvas.uid=localUid
        videoCanvas.view = remoteView
        videoCanvas.renderMode = .render_Fit
        
    }
    
    
    @IBAction func handUp(_ sender: Any) {
        agoraKit.leaveChannel(nil)
        remoteView.removeFromSuperview()
        collectionView.removeFromSuperview()
        
        agoraKit=nil
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func mute(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        agoraKit.muteLocalAudioStream(sender.isSelected)
    }
    @IBAction func switchCamera(_ sender: Any) {
        agoraKit.switchCamera()
        
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

        cell.setUid(uid: uid,localUid: localUid)
        return cell
        
        
    }
    func waterflowLayout(_ waterflowLayout: LDWaterflowLayout!, heightForItemAt index: UInt, itemWidth: CGFloat) -> CGFloat {
        let count:Int=(dataArray?.count)!
        if(isSelect){
            return 50
        }
        switch count {
        case 1:
            return 300
        case 2:
            return 300
        case 3:
            return 150
        case 4:
            return 150
        default:
            return 100
        }
    }
    func columnCount(in waterflowLayout: LDWaterflowLayout!) -> CGFloat {
        let count:Int=(dataArray?.count)!
        switch count {
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 2
        case 4:
            return 2
        default:
            return 3
        }
        
    }
    



}
extension MutilChatViewController :AgoraRtcEngineDelegate{
     func rtcEngine(_ engine: AgoraRtcEngineKit!, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int) {
        if(!(dataArray?.contains(uid))!){
            dataArray?.append(uid)
            collectionView.reloadData()
        }
        
    }
    func rtcEngine(_ engine: AgoraRtcEngineKit!, didJoinedOfUid uid: UInt, elapsed: Int) {
        if(!(dataArray?.contains(uid))!){
            dataArray?.append(uid)
            collectionView.reloadData()
        }
        
    }
    func rtcEngine(_ engine: AgoraRtcEngineKit!, didOccurError errorCode: AgoraRtcErrorCode) {
        print("didOccurError ,%d", errorCode)
    }
}
