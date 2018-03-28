import PlaygroundSupport
import SpriteKit
import UIKit

let Width = 300
let Height = 300

public class YourViewController: UIViewController
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
    
    public init(image: String, xImage: String, oImage: String)
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
    
    func moveAttempted(sprite: YourSpriteNode)
    {
        let playerID = parity%2 + 1
        let move = games[sprite.box].newMove(index: sprite.id, player: playerID)
        
        //        {
        if(move.validMove)
        {
            if(playerID == 1) //change tile to X or O
            {
                sprite.run(toX)
            }
            else
            {
                sprite.run(toO)
            }
            
            
            if(games[sprite.box].gameOver) //box will no longer be interacted with
            {
                if(move.winner == playerID) //if move resulted in victory
                {
                    for i in move.boxes!
                    {
                        sprites[sprite.box][i].run(pulseForever2)
                    }
                }
                for sprite in sprites[sprite.box]
                {
                    sprite.isUserInteractionEnabled = false
                }
                for line in boxes[sprite.box]
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
            
            if(games[sprite.id].gameOver) //if next box is game over
            {
                highlightNextBox(nextBox: nil, currentBox: boxes[sprite.box])
                nextMoveBox = -1
            }
            else //if next box is playable
            {
                highlightNextBox(nextBox: boxes[sprite.id], currentBox: boxes[sprite.box])
                nextMoveBox = sprite.id
            }
            
            parity += 1
        }
        //        }
    }
    
    init()
    {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
}
