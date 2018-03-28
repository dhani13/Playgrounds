import SpriteKit

class BoxContainer
{
    var box = [YourLineNode]()
    var zoomInAction = SKAction()
    var zoomOutAction = SKAction()
    
    init(X: Int, Y: Int)
    {
        var points = [[CGPoint]]()
        let lo = 0.060
        let hi = 1 - lo
        points.append([CGPoint(x: 1*Width/3 + X, y : Int(lo * Double(Height)) + Y), CGPoint(x: 1*Width/3 + X, y : Int(hi * Double(Height)) + Y)])
        points.append([CGPoint(x: 2*Width/3 + X, y : Int(lo * Double(Height)) + Y), CGPoint(x: 2*Width/3 + X, y : Int(hi * Double(Height)) + Y)])
        points.append([CGPoint(x: Int(lo * Double(Width)) + X, y : 1*Height/3 + Y), CGPoint(x: Int(hi * Double(Width)) + X, y : 1*Height/3 + Y)])
        points.append([CGPoint(x: Int(lo * Double(Width)) + X, y : 2*Height/3 + Y), CGPoint(x: Int(hi * Double(Width)) + X, y : 2*Height/3 + Y)])
        
        for i in 0...3
        {
            let line = YourLineNode(points: UnsafeMutablePointer<CGPoint>(mutating: points[i]), count: points[i].count)
            line.lineWidth = 5
            line.strokeColor = .gray
            line.glowWidth = 0.5
            line.isUserInteractionEnabled = true
            
            box.append(line)
        }
        
    }
    
    func addLinesToScene(scene: SKScene)
    {
        for line in box
        {
            scene.addChild(line)
        }
    }
    
    func setYourViewController(yourViewController: YourViewController)
    {
        for line in box
        {
            line.setYourViewController(yourViewController: yourViewController)
        }
    }
    
    func setZoomActions(zoomInAction: SKAction, zoomOutAction: SKAction)
    {
        for line in box
        {
            line.setZoomActions(zoomInAction: zoomInAction, zoomOutAction: zoomOutAction)
        }
    }
}
