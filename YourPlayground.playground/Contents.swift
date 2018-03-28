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
    var winner: Int
    
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
            if(array[i] == array[i+3] && array[i] == array[i+6] && array[i] == player) //columns
            {
                gameOver = true
                winner = player
                return (true, winner, [i, i+3, i+6])
            }
            
            if(array[i*3] == array[i*3+1] && array[i*3] == array[i*3+2]  && array[i*3] == player) //rows
            {
                gameOver = true
                winner = player
                return (true, winner, [i*3, i*3+1, i*3+2])
            }
        }
        
        if(array[2] == array[4] && array[2] == array[6] && array[2] == player) //diagonal
        {
            gameOver = true
            winner = player
            return (true, winner, [2, 4, 6])
        }
        
        if(array[0] == array[4] && array[0] == array[8] && array[0] == player) //diagonal
        {
            gameOver = true
            winner = player
            return (true, winner, [0, 4, 8])
        }
        
        for i in 0...8
        {
            if(array[i] != 0) //atleast one tile is unoccupied
            {
                return (true, -1, nil)
            }
        }
        
        gameOver = true
        return (true, 0, nil) //draw
    }
    
    required init()
    {
        array = [Int]()
        winner = 0
        gameOver = false
        for _ in 0...8
        {
            array.append(0)
        }
    }
}

class YourLineNode: SKShapeNode
{
    var id = 0
    var box = 0
    private var yourViewController = YourViewController()
    var zoomInAction = SKAction()
    var zoomOutAction = SKAction()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let touch: UITouch = touches.first
        {
            let positionInScene = touch.location(in: self)
            if self.atPoint(positionInScene) is YourLineNode
            {
                if(yourViewController.zoomedIn)
                {
                    yourViewController.cameraNode.run(zoomOutAction)
                    yourViewController.zoomedIn = false
                }
                else
                {
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
    
    func setZoomActions(zoomInAction: SKAction, zoomOutAction: SKAction)
    {
        self.zoomInAction = zoomInAction
        self.zoomOutAction = zoomOutAction
    }
}

class BoxContainer
{
    var box = [YourLineNode]()
    var zoomInAction = SKAction()
    var zoomOutAction = SKAction()
    private var yourViewController = YourViewController()
    
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

class YourSpriteNode: SKSpriteNode
{
    var id = 0
    var box = 0
    private var yourViewController = YourViewController()
    var zoomInAction = SKAction()
    var zoomOutAction = SKAction()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let touch: UITouch = touches.first
        {
            let positionInScene = touch.location(in: self)
            if let sprite = self.atPoint(positionInScene) as? YourSpriteNode
            {
                if(yourViewController.zoomedIn)
                {
//                    print("Touched \(sprite.id)")
                    if(yourViewController.nextMoveBox == sprite.box || yourViewController.nextMoveBox == -1)
                    {
                        yourViewController.moveAttempted(sender: self)
                    }
                    yourViewController.cameraNode.run(zoomOutAction)
                    yourViewController.zoomedIn = false
                }
                else
                {
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
    
    func setZoomActions(zoomInAction: SKAction, zoomOutAction: SKAction)
    {
        self.zoomInAction = zoomInAction
        self.zoomOutAction = zoomOutAction
    }
}

class YourViewController: UIViewController
{
    var parity = 0
    var zoomedIn = false
    var nextMoveBox = -1
    let spriteView = SKView(frame: CGRect(x: 0 , y: 0, width: Width, height: Height))
    let scene = SKScene(size: CGSize(width: Width*3, height: Height*3))
    
    var pulseForever1 = SKAction()
    var pulseForever2 = SKAction()
    var toX = SKAction()
    var toO = SKAction()
    var cameraNode = SKCameraNode()
    
    var games = [tictactoe]()
    var sprites = [[SKSpriteNode]]()
    var boxes = [[SKShapeNode]]()
    
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
            
            games.append(tictactoe())
            
            var boxSprites = [YourSpriteNode]()
            
            let O = CGPoint(x: scene.size.width/2, y: scene.size.height/2)
            let P = CGPoint(x: X + Width/2, y: Y + Height/2)
    
            let zoomOutAction = zoomOut(from: P, to: O, duration: 0.8, intervals: 10)
            let zoomInAction = zoomIn(from: O, to: P, duration: 0.8, intervals: 10)
            
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
                sprite.setZoomActions(zoomInAction: zoomInAction, zoomOutAction: zoomOutAction)
                
                boxSprites.append(sprite)
                scene.addChild(sprite)
            }
            
            sprites.append(boxSprites)
            
            let boxContainer = BoxContainer(X: X, Y: Y)
            boxContainer.setYourViewController(yourViewController: self)
            boxContainer.setZoomActions(zoomInAction: zoomInAction, zoomOutAction: zoomOutAction)
            boxContainer.addLinesToScene(scene: scene)
            
            boxes.append(boxContainer.box)
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
            line.strokeColor = .black
            line.glowWidth = 0.5
            line.isUserInteractionEnabled = false

            scene.addChild(line)
        }
    
        cameraNode.position = CGPoint(x: scene.size.width/2, y: scene.size.height/2)
        scene.addChild(cameraNode)
        scene.camera = cameraNode
        
        spriteView.presentScene(scene)
        
        let pulseBlink = SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.4),
            SKAction.wait(forDuration: 0.2),
            SKAction.fadeIn(withDuration: 0.4)])
        pulseForever1 = SKAction.repeatForever(pulseBlink)
        
        let pulseRed = SKAction.sequence([
            SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.4),
            SKAction.wait(forDuration: 0.2),
            SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.4)])
        pulseForever2 = SKAction.repeatForever(pulseRed)
        
        let xTexture = SKTexture(imageNamed: xImage)
        let oTexture = SKTexture(imageNamed: oImage)
        toX = SKAction.setTexture(xTexture, resize: false)
        toO = SKAction.setTexture(oTexture, resize: false)
        
//        print("init over")
    }
    
    func highlightNextBox(nextBox: [SKShapeNode]?, currentBox: [SKShapeNode]?)
    {
        if let current = currentBox
        {
            for line in current
            {
                line.lineWidth = 5
                line.strokeColor = .gray
            }
        }

        if let next = nextBox
        {
            for line in next
            {
                line.lineWidth = 8
                line.strokeColor = .black
            }
        }
    }
    
    func checkGlobalGame(player: Int) -> (gameOver: Bool, winner: Int, boxes: [Int]?)
    {
        for i in 0...2
        {
            if(games[i].winner == games[i+3].winner && games[i].winner == games[i+6].winner && games[i].winner == player) //columns
            {
                return (true, player, [i, i+3, i+6])
            }
            
            if(games[i*3].winner == games[i*3+1].winner && games[i*3].winner == games[i*3+2].winner  && games[i*3].winner == player) //rows
            {
                return (true, player, [i*3, i*3+1, i*3+2])
            }
        }
        
        if(games[2].winner == games[4].winner && games[2].winner == games[6].winner && games[2].winner == player) //diagonal
        {
            return (true, player, [2, 4, 6])
        }
        
        if(games[0].winner == games[4].winner && games[0].winner == games[8].winner && games[0].winner == player) //diagonal
        {
            return (true, player, [0, 4, 8])
        }
        
        for i in 0...8
        {
            if(games[i].winner != 0) //atleast one box is unfinished
            {
                return (false, -1, nil)
            }
        }
        
        return (true, 0, nil) //draw
    }
    
    @objc func moveAttempted(sender: YourSpriteNode)
    {
        let playerID = parity%2 + 1
        let move = games[sender.box].newMove(index: sender.id, player: playerID)
        DispatchQueue.global().sync {
            if(move.validMove)
            {
                if(playerID == 1) //change tile to X or O
                {
                    sender.run(toX)
                }
                else
                {
                    sender.run(toO)
                }
                
                
                if(games[sender.box].gameOver) //box will no longer be interacted with
                {
                    if(move.winner == playerID) //if move resulted in victory
                    {
                        for i in move.boxes!
                        {
                            sprites[sender.box][i].run(pulseForever2)
                        }
                    }
                    for sprite in sprites[sender.box]
                    {
                        sprite.isUserInteractionEnabled = false
                    }
                    for line in boxes[sender.box]
                    {
                        line.isUserInteractionEnabled = false
                    }
                    
                    let globalGame = checkGlobalGame(player: playerID)
                    if(globalGame.gameOver)
                    {
                        if(globalGame.winner == playerID)
                        {
                            for i in globalGame.boxes!
                            {
                                for box in sprites
                                {
                                    box[i].run(pulseForever1)
                                }
                            }
                        }
                        for box in sprites
                        {
                            for sprite in box
                            {
                                sprite.isUserInteractionEnabled = false
                            }
                        }
                        for box in boxes
                        {
                            for line in box
                            {
                                line.isUserInteractionEnabled = false
                            }
                        }
                    }
                }
                
                if(games[sender.id].gameOver) //if next box is game over
                {
                    highlightNextBox(nextBox: nil, currentBox: boxes[sender.box])
                    nextMoveBox = -1
                }
                else //if next box is playable
                {
                    highlightNextBox(nextBox: boxes[sender.id], currentBox: boxes[sender.box])
                    nextMoveBox = sender.id
                }
                
                parity += 1
            }
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
