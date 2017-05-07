

import Foundation

class ChatCell: UICollectionViewCell {
    
    public var agora :AgoraRtcEngineKit!
    @IBOutlet weak var videoView: UIView!
    public var uid :UInt!
    
    func setUid(uid:UInt){
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid=uid
        videoCanvas.view=videoView
        videoCanvas.renderMode = .render_Fit
        agora.setupLocalVideo(videoCanvas)
    
    }
    
}
