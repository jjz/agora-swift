

import Foundation

class ChatCell: UICollectionViewCell {
    
    public var agora :AgoraRtcEngineKit!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var labelUser: UILabel!
    private var uid :UInt!
    
    
    func setUid(uid:UInt){
        labelUser.text=String(uid)
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid=uid
        videoCanvas.view=videoView
        videoCanvas.renderMode = .render_Fit
        agora.setupRemoteVideo(videoCanvas)
    
    }
    
    
    
}
