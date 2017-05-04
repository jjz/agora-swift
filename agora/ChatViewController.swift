//
//  InitViewController.swift
//  agora
//
//  Created by jjz on 09/04/2017.
//  Copyright © 2017 jjz. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    var agoraKit : AgoraRtcEngineKit!
    
    @IBOutlet weak var localVideo: UIView!
    @IBOutlet weak var remoteView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        initAgoraEngine()
        setupVideo()
        setupLocalVideo()
        joinChannel()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initAgoraEngine(){
        agoraKit=AgoraRtcEngineKit.sharedEngine(withAppId: AgoraSetting.AgoraAppId, delegate: self)
    }
    func setupVideo(){
        agoraKit.enableVideo()
        agoraKit.setVideoProfile(._VideoProfile_360P, swapWidthAndHeight: false)
    }
    func setupLocalVideo(){
        let videoCanvas=AgoraRtcVideoCanvas()
        videoCanvas.uid=0
        videoCanvas.view=localVideo
        videoCanvas.renderMode = .render_Adaptive
        agoraKit.setupLocalVideo(videoCanvas)
    }

    func joinChannel(){
        agoraKit.joinChannel(byKey: nil, channelName: "demo", info: nil, uid: 0){[weak self](sid,uid,elapsed)->Void in
            if let weakSelf = self{
                weakSelf.agoraKit.setEnableSpeakerphone(true)
                UIApplication.shared.isIdleTimerDisabled = true
            }
            
    }
    }
    @IBAction func mute(_ sender: Any) {
    }

    @IBAction func switchCamera(_ sender: Any) {
    }
    @IBAction func hangUp(_ sender: Any) {
    }
}

extension ChatViewController:AgoraRtcEngineDelegate{
    func rtcEngine(_ engine: AgoraRtcEngineKit!, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int) {
        if(remoteView.isHidden){
        remoteView.isHidden=false
        }
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.view = remoteView
        videoCanvas.renderMode = .render_Adaptive
        agoraKit.setupRemoteVideo(videoCanvas)

        
        
    }
    func rtcEngine(_ engine: AgoraRtcEngineKit!, didLeaveChannelWith stats: AgoraRtcStats!) {
        
    }
    func rtcEngine(_ engine: AgoraRtcEngineKit!, didVideoEnabled enabled: Bool, byUid uid: UInt) {
        
    }
}
