import SpriteKit

class YourLineNode: SKShapeNode
{
    var id = 0
    var box = 0
    static private var yourViewController = YourViewController()
    static private var isYourViewControllerSet = false
    var zoomInAction = SKAction()
    var zoomOutAction = SKAction()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let touch: UITouch = touches.first
        {
            let positionInScene = touch.location(in: self)
            if self.atPoint(positionInScene) is YourLineNode
            {
                if(YourLineNode.yourViewController.zoomedIn)
                {
                    YourLineNode.yourViewController.cameraNode.run(zoomOutAction)
                    YourLineNode.yourViewController.zoomedIn = false
                }
                else
                {
                    YourLineNode.yourViewController.cameraNode.run(zoomInAction)
                    YourLineNode.yourViewController.zoomedIn = true
                }
            }
        }
    }
    
    func setYourViewController(yourViewController: YourViewController)
    {
        if(!YourLineNode.isYourViewControllerSet)
        {
            YourLineNode.yourViewController = yourViewController
            YourLineNode.isYourViewControllerSet = true
        }
    }
    
    func setZoomActions(zoomInAction: SKAction, zoomOutAction: SKAction)
    {
        self.zoomInAction = zoomInAction
        self.zoomOutAction = zoomOutAction
    }
}
