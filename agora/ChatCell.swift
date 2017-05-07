

import Foundation

class ChatCell: UICollectionViewCell {
    
    public var agora :AgoraRtcEngineKit!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var labelUser: UILabel!
    private var uid :UInt!
    
    
    func setUid(uid:UInt){
        labelUser.text=uid.description
        //self.frame=CGRect(x: 0, y: 0, width: 200, height: 100)
//        let videoCanvas = AgoraRtcVideoCanvas()
//        videoCanvas.uid=uid
//        videoCanvas.view=videoView
//        videoCanvas.renderMode = .render_Fit
//        agora.setupLocalVideo(videoCanvas)
    
    }
    
    
    
}
