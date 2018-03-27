import PlaygroundSupport
import SpriteKit
import UIKit

let Width = 300
let Height = 300

func sigmoidApprox(n: Int) -> [CGFloat]
{
    var values = [CGFloat]()
    for i in 1..<n
    {
        let value = 1/(1 + exp(-12.0*CGFloat(i)/CGFloat(n) + 6))
        values.append(value)
    }
    values.append(1.0)
    return values
}

func parabolaApprox(n: Int) -> [CGFloat]
{
    var values = [CGFloat]()
    for i in 1...n
    {
        let x = CGFloat(i)/CGFloat(n)
        let value = -x*x + 2.0*x
        values.append(value)
    }
//    print(values)
    return values
}

func zoomIn(from origin: CGPoint, to point: CGPoint, duration: TimeInterval, intervals: Int, approximationFunction: (Int)->[CGFloat]) -> SKAction
{
    let values = approximationFunction(intervals)
    let deltaX = point.x - origin.x
    let deltaY = point.y - origin.y
    var moves = [SKAction]()
    var zooms = [SKAction]()
    for i in 0...(intervals-1)
    {
        let point = CGPoint(x: origin.x + deltaX*values[i], y : origin.y + deltaY*values[i])
        let move = SKAction.move(to: point, duration: duration*1.0/Double(intervals))
        let zoom = SKAction.scale(to: 1.0 - values[i]*0.67, duration: duration*1.0/Double(intervals))
        
        moves.append(move)
        zooms.append(zoom)
    }
    
    let zoomSeq = SKAction.sequence(zooms)
    let moveSeq = SKAction.sequence(moves)
    
    let zoom = SKAction.group([moveSeq, zoomSeq])
    return zoom
}

func zoomIn(from origin: CGPoint, to point: CGPoint, duration: TimeInterval, intervals: Int) -> SKAction
{
    return zoomIn(from: origin, to: point, duration: duration, intervals: intervals, approximationFunction: parabolaApprox)
}

func zoomOut(from origin: CGPoint, to point: CGPoint, duration: TimeInterval, intervals: Int, approximationFunction: (Int)->[CGFloat]) -> SKAction
{
    let values = approximationFunction(intervals)
    let deltaX = point.x - origin.x
    let deltaY = point.y - origin.y
    var moves = [SKAction]()
    var zooms = [SKAction]()
    for i in 0...(intervals-1)
    {
        let point = CGPoint(x: origin.x + deltaX*values[i], y : origin.y + deltaY*values[i])
        let move = SKAction.move(to: point, duration: duration*1.0/Double(intervals))
        let zoom = SKAction.scale(to: 0.33 + values[i]*0.67, duration: duration*1.0/Double(intervals))
        
        moves.append(move)
        zooms.append(zoom)
    }
    
    let zoomSeq = SKAction.sequence(zooms)
    let moveSeq = SKAction.sequence(moves)
    
    let zoom = SKAction.group([moveSeq, zoomSeq])
    return zoom
}

func zoomOut(from origin: CGPoint, to point: CGPoint, duration: TimeInterval, intervals: Int) -> SKAction
{
    return zoomOut(from: origin, to: point, duration: duration, intervals: intervals, approximationFunction: parabolaApprox)
}

class tictactoe
{
    var array: [Int]
    var gameOver: Bool
    
    func newMove(index: Int, player: Int) -> (validMove: Bool, winner: Int?, boxes: [Int]?)
    {
        if(!gameOver && array[index] == 0)
        {
            array[index] = player
            return checkGameOver(player: player)
        }
        else
        {
            return (false, nil, nil)
        }
    }
    
    func checkGameOver(player: Int) -> (Bool, Int?, [Int]?)
    {
        for i in 0...2
        {
            if(array[i] == array[i+3] && array[i] == array[i+6] && array[i] != 0)
            {
                gameOver = true
                return (true, player, [i, i+3, i+6])
            }
            
            if(array[i*3] == array[i*3+1] && array[i*3] == array[i*3+2]  && array[i*3] != 0)
            {
                gameOver = true
                return (true, player, [i*3, i*3+1, i*3+2])
            }
            
            if(array[2] == array[4] && array[2] == array[6] && array[2] != 0)
            {
                gameOver = true
                return (true, player, [2, 4, 6])
            }
            
            if(array[0] == array[4] && array[0] == array[8] && array[0] != 0)
            {
                gameOver = true
                return (true, player, [0, 4, 8])
            }
        }
        
        for i in 0...8
        {
            if(array[i] != 0)
            {
                return (true, -1, nil)
            }
        }
        
        gameOver = true
        return (true, 0, nil)
    }
    
    required init()
    {
        gameOver = false
        array = [Int]()
        for _ in 0...8
        {
            array.append(0)
        }
    }
}

class YourSpriteNode: SKSpriteNode
{
    var id = 0
    var box = 0
    private var yourViewController = YourViewController()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let touch: UITouch = touches.first
        {
            let positionInScene = touch.location(in: self)
            if let sprite = self.atPoint(positionInScene) as? YourSpriteNode
            {
                let X = (sprite.box%3)*Width + Width/2
                let Y = Int(sprite.box/3)*Height + Height/2
                
                let O = CGPoint(x: yourViewController.scene.size.width/2, y: yourViewController.scene.size.height/2)
                let P = CGPoint(x: X, y: Y)
                if(yourViewController.zoomedIn)
                {
//                    print("Touched \(sprite.id)")
                    yourViewController.moveAttempted(sender: self)
                    sprite.isUserInteractionEnabled = false
                    let zoomOutAction = zoomOut(from: P, to: O, duration: 0.7, intervals: 7)
                    yourViewController.cameraNode.run(zoomOutAction)
                    yourViewController.zoomedIn = false
                }
                else
                {
                    let zoomInAction = zoomIn(from: O, to: P, duration: 0.7, intervals: 7)
                    yourViewController.cameraNode.run(zoomInAction)
                    yourViewController.zoomedIn = true
                }
            }
        }
    }
    
    func setYourViewController(yourViewController: YourViewController)
    {
        self.yourViewController = yourViewController
    }
}

class YourViewController: UIViewController
{
    var parity = 0
    var spriteView = SKView(frame: CGRect(x: 0 , y: 0, width: Width, height: Height))
    var zoomedIn = false
    let scene = SKScene(size: CGSize(width: Width*3, height: Height*3))
    
    var seq = SKAction()
    var pulseForever = SKAction()
    var toX = SKAction()
    var toO = SKAction()
    var cameraNode = SKCameraNode()
    
    var game = tictactoe()
    var sprites = [SKSpriteNode]()
    var labels = [SKLabelNode]()
    @IBOutlet weak var button: UIButton!
    var buttons: [UIButton] = [UIButton]()
    
    init(image: String, xImage: String, oImage: String)
    {
        super.init(nibName: nil, bundle: nil)
        
        self.preferredContentSize = CGSize(width: Width, height: Height)
        
        self.view = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: Height))
        self.view.backgroundColor = .gray
        self.view.addSubview(spriteView)
        
        spriteView.showsFPS = true

        scene.anchorPoint = CGPoint(x: 0, y: 0)
        scene.backgroundColor = .white
        
        
        for j in 0...8
        {
            let X = (j%3)*Width
            let Y = Int(j/3)*Height
            for i in 0...8
            {
                let sprite = YourSpriteNode(imageNamed: image)
                sprite.scale(to: CGSize(width: Width/3, height: Height/3))
                let x = (i%3)*Width/3 + Width/6 + X
                let y = Int(i/3)*Height/3 + Height/6 + Y
                sprite.position = CGPoint(x: x, y: y)
                sprite.isUserInteractionEnabled = true
                sprite.id = i
                sprite.box = j
                sprite.setYourViewController(yourViewController: self)
                sprite.target(forAction: #selector(YourViewController.moveAttempted(sender:)), withSender: self)
                sprites.append(sprite)
                scene.addChild(sprite)
            }
        
            var points = [[CGPoint]]()
            let lo = 0.060
            let hi = 1 - lo
            points.append([CGPoint(x: 1*Width/3 + X, y : Int(lo * Double(Height)) + Y),
                           CGPoint(x: 1*Width/3 + X, y : Int(hi * Double(Height)) + Y)])
            points.append([CGPoint(x: 2*Width/3 + X, y : Int(lo * Double(Height)) + Y),
                           CGPoint(x: 2*Width/3 + X, y : Int(hi * Double(Height)) + Y)])
            points.append([CGPoint(x: Int(lo * Double(Width)) + X, y : 1*Height/3 + Y),
                           CGPoint(x: Int(hi * Double(Width)) + X, y : 1*Height/3 + Y)])
            points.append([CGPoint(x: Int(lo * Double(Width)) + X, y : 2*Height/3 + Y),
                           CGPoint(x: Int(hi * Double(Width)) + X, y : 2*Height/3 + Y)])
        
            for i in 0...3
            {
                let line = SKShapeNode(points: UnsafeMutablePointer<CGPoint>(mutating: points[i]), count: points[i].count)
                line.lineWidth = 5
                line.fillColor = .gray
                line.strokeColor = .gray
                line.glowWidth = 0.5
                line.isUserInteractionEnabled = false
                
                scene.addChild(line)
            }
        }
    
        var points = [[CGPoint]]()
        let lo = 0.010
        let hi = 1 - lo
        points.append([CGPoint(x: Width, y : Int(lo * Double(Height*3))),
                       CGPoint(x: Width, y : Int(hi * Double(Height*3)))])
        points.append([CGPoint(x: 2*Width, y : Int(lo * Double(Height*3))),
                       CGPoint(x: 2*Width, y : Int(hi * Double(Height*3)))])
        points.append([CGPoint(x: Int(lo * Double(Width*3)), y : Height),
                       CGPoint(x: Int(hi * Double(Width*3)), y : Height)])
        points.append([CGPoint(x: Int(lo * Double(Width*3)), y : 2*Height),
                       CGPoint(x: Int(hi * Double(Width*3)), y : 2*Height)])

        for i in 0...3
        {
            let line = SKShapeNode(points: UnsafeMutablePointer<CGPoint>(mutating: points[i]), count: points[i].count)
            line.lineWidth = 8
            line.fillColor = .black
            line.strokeColor = .black
            line.glowWidth = 0.5
            line.isUserInteractionEnabled = false

            scene.addChild(line)
        }
    
        cameraNode.position = CGPoint(x: scene.size.width/2, y: scene.size.height/2)
        scene.addChild(cameraNode)
        scene.camera = cameraNode
//        let zoom = SKAction.scale(to: 3.00, duration: 1)
//        cameraNode.run(zoom)
        
        spriteView.presentScene(scene)
        
        let fadeOut = SKAction.fadeOut(withDuration: 1.2)
        let fadeIn = SKAction.fadeIn(withDuration: 1.2)
        let wait = SKAction.wait(forDuration: 0.3)
        seq = SKAction.sequence([fadeOut,wait,fadeIn])
        pulseForever = SKAction.repeatForever(seq)
        
        let xTexture = SKTexture(imageNamed: xImage)
        let oTexture = SKTexture(imageNamed: oImage)
        toX = SKAction.setTexture(xTexture, resize: false)
        toO = SKAction.setTexture(oTexture, resize: false)
        
//        print("init over")
    }
    
    @objc func moveAttempted(sender: YourSpriteNode)
    {
        let playerID = parity%2 + 1
        let move = game.newMove(index: sender.id, player: playerID)
        if(move.validMove)
        {
            if(playerID == 1)
            {
                sender.run(toX)
            }
            else
            {
                sender.run(toO)
            }
            
            if(move.winner == playerID)
            {
                for i in move.boxes!
                {
                    sprites[i].run(pulseForever)
                }
            }
            
            parity += 1
        }
    }
    
    init()
    {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
}

let viewController = YourViewController(image: "tic-tac-toe-blank.png", xImage: "tic-tac-toe-x.png", oImage: "tic-tac-toe-o.png")
PlaygroundSupport.PlaygroundPage.current.liveView = viewController
