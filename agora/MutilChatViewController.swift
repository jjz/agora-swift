//
//  MutilChatViewController.swift
//  agora
//
//  Created by jjz on 07/05/2017.
//  Copyright © 2017 jjz. All rights reserved.
//

import Foundation

class  MutilChatViewController: UIViewController {
    
    var agoraKit :AgoraRtcEngineKit!
    
    
    @IBOutlet weak var remoteView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func handUp(_ sender: Any) {
    }
    @IBAction func mute(_ sender: Any) {
    }
    @IBAction func switchCamera(_ sender: Any) {
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
