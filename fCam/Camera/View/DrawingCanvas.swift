

import UIKit



@IBDesignable
class DrawingCanvas: XibBasedView {
    
    enum DrawingCanvasState {
        case ready
        case recording
    }
    
    var circleRadius: CGFloat = 30.0
    var circleShape: CGFloat = 300// Updated to store y-coordinate
  
    var displayLink: CADisplayLink?
    var direction: CGFloat = -1.0 // -1.0 for up, 1.0 for down
    var isTopState: Bool = true // Variable to determine the current state
    var currentPoint = 0.0
    var isToogle = false
    var isDone = false
    var count = 0
    //Goat
    var circleImage: UIImage?
    var imagePlayer: UIImage?
    var imagePlayer1: UIImage?
    
    var imageBuffer: UIImage?
    var imageplayerBuffer: UIImage?
    var imageplayerBuffer1: UIImage?
    
    var hideItem = false
    
  
    var state = DrawingCanvasState.ready
    
    override func load() {
        super.load()
        print("Load content 1")
        setup()
    }

    private func setup() {
        circleShape = circleRadius
        startAnimation()
      
        // SetupImage
        circleImage = UIImage(named: "Scissor")
        imagePlayer = UIImage(named: "TestImage")
        imagePlayer1 = UIImage(named: "TestImage1")

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(tapGesture)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext(), let image = circleImage, let image2 = imagePlayer, let image3 = imagePlayer1 else { return }
        context.clear(rect)
        
      
        if !hideItem {
            image2.draw(in: drawPlayer())
            drawImagePlayerToBuffer()
        }else{
                image3.draw(in: self.drawPlayer())
                self.drawImagePlayerToBuffer1()
        }
        image.draw(in: moveImage())
        drawImageBuffer()
    }

    func startAnimation() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateImage))
        displayLink?.add(to: .main, forMode: .default)
    }

    func stopAnimation() {
        displayLink?.invalidate()
        displayLink = nil
    }

    @objc private func updateImage() {
        let increment: CGFloat = 2.0
        circleShape += increment * direction
        if circleShape >= (isToogle == false ? 500 : bounds.width - circleRadius) {
            if(!isToogle){
                direction = -3.0
            }else{
                stopAnimation()
            }
        } else if circleShape <= circleRadius {
            direction = 3.0
        }
        setNeedsDisplay()
    }
    
    private func moveImage () -> CGRect {
        var imageRect: CGRect
        
        if(isToogle == false){
            currentPoint = circleShape
        }

        let newSize = ResizeClass.shared.pixelPerfect(forWidth: 62, forHeight: 54)
      
        if isTopState {
            imageRect = CGRect(x: 30, y: circleShape - circleRadius, width: newSize.width , height: newSize.height)
        } else {
            imageRect = CGRect(x: circleShape , y: currentPoint - 25, width: newSize.width , height:newSize.height )
        }
        
        return imageRect
    }
    
    private func drawPlayer() -> CGRect {
        let newSize = ResizeClass.shared.pixelPerfect(forWidth: 200, forHeight: 490)
        return CGRect(x: bounds.width / 4.3, y: bounds.height / 3.5, width: newSize.width , height: newSize.height)
    }

    func drawImageBuffer() {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        guard let _ = UIGraphicsGetCurrentContext(), let image = circleImage else { return }
        image.draw(in: moveImage())
        imageBuffer = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    //PLayer
    func drawImagePlayerToBuffer() {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        guard let _ = UIGraphicsGetCurrentContext(), let image = imagePlayer else { return }
        image.draw(in: drawPlayer())
        imageplayerBuffer = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    //PLayer
    func drawImagePlayerToBuffer1() {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        guard let _ = UIGraphicsGetCurrentContext(), let image = imagePlayer1 else { return }
        image.draw(in: drawPlayer())
        imageplayerBuffer1 = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }

    
    

    func getImageBuffer() -> UIImage? {
        return imageBuffer
    }
    
    func getImagePlayerBuffer() -> UIImage? {
        return imageplayerBuffer
    }
    
    func getImagePlayerBuffer1() -> UIImage? {
        return imageplayerBuffer1
    }
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        
//        if state == .ready {
//            hideItem = true
//            return
//        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            self.hideItem = true
        }
     
        if !isDone {
            isDone = true
            isTopState.toggle()
            isToogle = true
            stopAnimation()
            self.direction = 3.0
            self.startAnimation()
            circleShape = 30
            setNeedsDisplay()
        }
    }
    
    
    //Drawing Content Goat
    
    
    
}
