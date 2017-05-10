//
//  MutilChatViewController.swift
//  agora
//
//  Created by jjz on 07/05/2017.
//  Copyright © 2017 jjz. All rights reserved.
//

import Foundation

class  MutilChatViewController: UIViewController,LDWaterflowLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var remoteView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!

    public var dataArray:Array<UInt>?=Array<UInt>();
    public var allDataArray:Array<UInt>?=Array<UInt>();
    
    var agoraKit :AgoraRtcEngineKit!

    private var  localUid:UInt=UInt(arc4random())
    private var isSelect:Bool?=false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAgoraEngine()
        setupVideo()
    
        agoraKit.joinChannel(byKey: nil, channelName: "demo", info: nil, uid: 0) { [weak self](sid,uid,elapsed)->Void in
            if let weakSelf=self{
                weakSelf.agoraKit.setEnableSpeakerphone(true)
                UIApplication.shared.isIdleTimerDisabled=true
            }
        }
    
        dataArray?.append(localUid)
        allDataArray?.append(localUid)
        self.collectionView.dataSource=self
        self.collectionView.delegate=self
        
        let layout :LDWaterflowLayout=LDWaterflowLayout()
        layout.delegate=self
        self.collectionView.collectionViewLayout=layout
        self.remoteView.isHidden=true
      
        
    }
    func initAgoraEngine() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: AgoraSetting.AgoraAppId, delegate: self)
    }
    
    
    func setupVideo() {
        agoraKit.enableVideo()
        agoraKit.setVideoProfile(._VideoProfile_360P, swapWidthAndHeight: false)
    }
    
    
    func setupVideo(uid:UInt){
        if(self.remoteView.isHidden){
            self.remoteView.isHidden=false
        }
        let videoCanvas=AgoraRtcVideoCanvas()
        videoCanvas.uid=uid
        videoCanvas.view=remoteView
        videoCanvas.renderMode = .render_Fit
        if(uid==localUid){
            agoraKit.setupLocalVideo(videoCanvas)
        }else{
            agoraKit.setupRemoteVideo(videoCanvas)
        }
    }
    
    
    
    @IBAction func handUp(_ sender: Any) {
        self.leaveChannel()
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        leaveChannel()
    }
    
    func leaveChannel(){
        if(agoraKit != nil){
            agoraKit.leaveChannel(nil)
            remoteView.removeFromSuperview()
            collectionView.removeFromSuperview()
            
            agoraKit=nil
        }
    }
    @IBAction func mute(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        agoraKit.muteLocalAudioStream(sender.isSelected)
    }
    @IBAction func switchCamera(_ sender: Any) {
        agoraKit.switchCamera()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let uid:UInt = dataArray![indexPath.row]
            self.isSelect=true
            dataArray?.removeAll()
            for tempUid in allDataArray!{
                if(tempUid != uid){
                    dataArray?.append(tempUid)
                }
            }
            collectionView.reloadData()
            setupVideo(uid: uid)
        
        
        
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
        if(self.isSelect!){
            return itemWidth
        }
        switch count {
        case 1:
            return 300.0
        case 2:
            return 300.0
        case 3:
            return 150.0
        case 4:
            return 150.0
        default:
            return 100.0
        }
    }
    func columnCount(in waterflowLayout: LDWaterflowLayout!) -> CGFloat {
        let count:Int=(dataArray?.count)!
        switch count {
        case 1:
            return 1
        case 2:
            return 2
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
        if(!(allDataArray?.contains(uid))!){
            allDataArray?.append(uid)
        }
        if(!(dataArray?.contains(uid))!){
            dataArray?.append(uid)
            collectionView.reloadData()
        }
        
    }
    func rtcEngine(_ engine: AgoraRtcEngineKit!, didJoinedOfUid uid: UInt, elapsed: Int) {
        if(!(allDataArray?.contains(uid))!){
            allDataArray?.append(uid)
        }
        if(!(dataArray?.contains(uid))!){
            dataArray?.append(uid)
            collectionView.reloadData()
        }
        
    }
    func rtcEngine(_ engine: AgoraRtcEngineKit!, didOccurError errorCode: AgoraRtcErrorCode) {
        print("didOccurError ,%d", errorCode)
    }
    func rtcEngine(_ engine: AgoraRtcEngineKit!, didOfflineOfUid uid: UInt, reason: AgoraRtcUserOfflineReason){
        
        
    }
    func rtcEngine(_ engine: AgoraRtcEngineKit!, didLeaveChannelWith stats: AgoraRtcStats!) {
        
    }
}
