import SpriteKit

class YourSpriteNode: SKSpriteNode
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
            if let sprite = self.atPoint(positionInScene) as? YourSpriteNode
            {
                if(YourSpriteNode.yourViewController.zoomedIn)
                {
                    //                    print("Touched \(sprite.id)")
                    if(YourSpriteNode.yourViewController.nextMoveBox == sprite.box || YourSpriteNode.yourViewController.nextMoveBox == -1)
                    {
                        //                        DispatchQueue(label: "queue", qos: .userInitiated).sync{
                        YourSpriteNode.yourViewController.moveAttempted(sprite: sprite)
                        //                        }
                    }
                    YourSpriteNode.yourViewController.cameraNode.run(zoomOutAction)
                    YourSpriteNode.yourViewController.zoomedIn = false
                }
                else
                {
                    YourSpriteNode.yourViewController.cameraNode.run(zoomInAction)
                    YourSpriteNode.yourViewController.zoomedIn = true
                }
            }
        }
    }
    
    func setYourViewController(yourViewController: YourViewController)
    {
        if(!YourSpriteNode.isYourViewControllerSet)
        {
            YourSpriteNode.yourViewController = yourViewController
            YourSpriteNode.isYourViewControllerSet = true
        }
    }
    
    func setZoomActions(zoomInAction: SKAction, zoomOutAction: SKAction)
    {
        let wait = SKAction.wait(forDuration: 0.05)
        self.zoomInAction = SKAction.sequence([wait, zoomInAction])
        self.zoomOutAction = SKAction.sequence([wait, zoomOutAction])
    }
}
