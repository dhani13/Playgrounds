import PlaygroundSupport
import SpriteKit
import UIKit

let Width = 300
let Height = 300

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

//class YourSpriteView: SKView
//{
//    let toBeScene = SKScene(size: CGSize(width: 100, height: 100))
//    let defaultRect = CGRect(x:0 , y:0, width: 100, height: 100)
//    var action: SKAction
//
//    override func presentScene(_ scene: SKScene?)
//    {
//        super.presentScene(scene!, transition: SKTransition.crossFade(withDuration: 0.2))
//    }
//
//    init(_ image: String)
//    {
//        let fadeOut = SKAction.fadeOut(withDuration:1.2)
//        let fadeIn = SKAction.fadeIn(withDuration:1.2)
//        let wait = SKAction.wait(forDuration: 0.3)
//        let seq = SKAction.sequence([fadeOut,wait,fadeIn])
//        let pulseForever = SKAction.repeatForever(seq)
//        action = pulseForever
//
//        super.init(frame: defaultRect)
//
//        let node = SKSpriteNode(imageNamed: image)
//        node.name = image
//        node.setScale(CGFloat(0.5))
//        node.position = CGPoint(x: 50, y: 50)
//        self.scene?.addChild(node)
//    }
//
//    required init?(coder aDecoder: NSCoder)
//    {
//        action = SKAction()
//        super.init(coder: aDecoder)
//    }
//}

//class visual
//{
//    var id: Int = 0
//
//    var spriteNode = SKSpriteNode()
//    var blankTexture = SKTexture()
//    var xTexture = SKTexture()
//    var oTexture = SKTexture()
//
//    init(blankImage: String, xImage: String, oImage: String, id: Int)
//    {
//        blankTexture = SKTexture(imageNamed: blankImage)
//        spriteNode = SKSpriteNode(texture: blankTexture, size: CGSize(width: Width/3, height: Height/3))
//        xTexture = SKTexture(imageNamed: xImage)
//        oTexture = SKTexture(imageNamed: oImage)
//        self.id = id
//    }
//
//    @objc func doSomething(sender: visual)
//    {
//        let move = game.newMove(index: sender.id, player: parity%2 + 1)
//        if(move.validMove)
//        {
//            if(parity%2 == 0)
//            {
//                sender.setTitle(" \(sender.id+1)", for: .normal)
//            }
//            else
//            {
//                sender.setTitle("∆ \(sender.id+1)", for: .normal)
//            }
//
//            if(move.winner != -1)
//            {
//                for i in 0...8
//                {
//                    if(game.array[i] == move.winner)
//                    {
//                        sprites[i].run(pulseForever)
//                    }
//                }
//            }
//
//            parity += 1
//        }
//        //        print(sender.id, terminator: "\n")
//    }
//
//    required init?(coder aDecoder: NSCoder)
//    {
//        super.init(coder: aDecoder)
//    }
//}

class YourSpriteNode: SKSpriteNode
{
    var id = 0
    private var yourViewController = YourViewController()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let touch: UITouch = touches.first
        {
            let positionInScene = touch.location(in: self)
            if self.atPoint(positionInScene) is YourSpriteNode
            {
                let sprite = self.atPoint(positionInScene) as! YourSpriteNode
                print("Touched \(sprite.id)")
                yourViewController.doSomething2(sender: self)
                sprite.isUserInteractionEnabled = false
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
    var spriteView = SKView(frame: CGRect(x: (Int(0.2*Double(Width))) , y: (Int(0.2*Double(Height))), width: Width, height: Height))
    let scene = SKScene(size: CGSize(width: Width, height: Height))
    
    var seq = SKAction()
    var pulseForever = SKAction()
    var toX = SKAction()
    var toO = SKAction()
    
    var game = tictactoe()
    var sprites = [SKSpriteNode]()
    var labels = [SKLabelNode]()
    @IBOutlet weak var button: UIButton!
    var buttons: [UIButton] = [UIButton]()
    
    init(image: String, xImage: String, oImage: String)
    {
        super.init(nibName: nil, bundle: nil)
        
        self.preferredContentSize = CGSize(width: 1.4*Double(Width), height: 1.4*Double(Height))
        
        self.view = UIView(frame: CGRect(x: 0, y: 0, width: 1.4*Double(Width), height: 1.4*Double(Height)))
        self.view.backgroundColor = .gray
        //
        self.view.addSubview(spriteView)
        spriteView.showsFPS = true
//        spriteView.backgroundColor = .white
        scene.anchorPoint = CGPoint(x: 0.2/1.2, y: 0.2/1.2)
//        scene.position = CGPoint(x: 0.2/1.4, y: 0.2/1.4)
        scene.backgroundColor = .white
        
//        let tttFrame = CGMutablePath()
//        tttFrame.addLine(to: CGPoint(x: Width/3, y: Height))
//        tttFrame.addArc(center: CGPoint.zero,
//                    radius: 15,
//                    startAngle: 0,
//                    endAngle: CGFloat.pi * 2,
//                    clockwise: true)
        var points = [CGPoint(x: Width/4, y : -Int(0.2*Double(Width))),
                      CGPoint(x: Width/4, y : -Int(0.2*Double(Width)) + Height)]
        let line = SKShapeNode(points: &points,
                               count: points.count)
        line.lineWidth = 1
        line.fillColor = .blue
        line.strokeColor = .blue
        line.glowWidth = 0.5
//        scene.addChild(line)
        
        for i in 0...8
        {
//            let new = SKSpriteNode(imageNamed: image)
//            new.name = image
//            new.setScale(CGFloat(0.5))
//            new.position = CGPoint(x: 50 + 100*(i%3), y: 50 + 100*Int(Double(i)/3.0))
//            scene.addChild(new)
            
            let sprite = YourSpriteNode(imageNamed: image)
            sprite.scale(to: CGSize(width: Width/3, height: Height/3))
            sprite.position = CGPoint(x: (i%3)*100, y: Int(Double(i)/3.0)*100)
            sprite.isUserInteractionEnabled = true
            sprite.id = i
            sprite.setYourViewController(yourViewController: self)
            sprite.target(forAction: #selector(YourViewController.doSomething2(sender:)), withSender: self)
            sprites.append(sprite)
            scene.addChild(sprite)
        }
        
        scene.addChild(line)
        
        
        spriteView.presentScene(scene)
//        self.view.addSubview(spriteView)
        
        let fadeOut = SKAction.fadeOut(withDuration: 1.2)
        let fadeIn = SKAction.fadeIn(withDuration: 1.2)
        let wait = SKAction.wait(forDuration: 0.3)
        seq = SKAction.sequence([fadeOut,wait,fadeIn])
        pulseForever = SKAction.repeatForever(seq)
        let xTexture = SKTexture(imageNamed: xImage)
        let oTexture = SKTexture(imageNamed: oImage)
        toX = SKAction.setTexture(xTexture, resize: false)
        toO = SKAction.setTexture(oTexture, resize: false)
        
        
        
//        for i in 0...8
//        {
//            sprites[i].run(wait) {
//                if i%2 == 0
//                {
//                    self.sprites[i].run(self.toX)
//                }
//                else
//                {
//                    self.sprites[i].run(self.toO)
//                }
//            }
//        }
//        addButtons(image: image)
//        print("init over")
    }
    
    /*
    @objc func doSomething(sender: UIButton)
    {
        let move = game.newMove(index: sender.tag, player: parity%2 + 1)
        if(move.validMove)
        {
            if(parity%2 == 0)
            {
                sender.setTitle(" \(sender.tag+1)", for: .normal)
            }
            else
            {
                sender.setTitle("∆ \(sender.tag+1)", for: .normal)
            }
            
            if(move.winner != -1)
            {
                for i in 0...8
                {
                    if(game.array[i] == move.winner)
                    {
                        sprites[i].run(pulseForever)
                    }
                }
            }
            
            parity += 1
        }
        //        print(sender.tag, terminator: "\n")
    }*/
    
    @objc func doSomething2(sender: YourSpriteNode)
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
                    /*if(game.array[i] == move.winner)
                    {
                        sprites[i].run(pulseForever)
                    }*/
                    sprites[i].run(pulseForever)
                }
            }
            
            parity += 1
        }
        //        print(sender.tag, terminator: "\n")
    }
    
    func addButtons(image: String)
    {
        //        self.view = SKView(frame: CGRect(x: (Int(0.2*Double(Width))) , y: (Int(0.2*Double(Height))), width: Width, height: Height))
        //        let borderAlpha : CGFloat = 0.7
        //        let cornerRadius : CGFloat = 5.0
        
        for i in 0...8
        {
            let eagle = SKSpriteNode(imageNamed: image)
            eagle.scale(to: CGSize(width: Width/3, height: Height/3))
            eagle.position = CGPoint(x: (i%3)*100, y: Int(Double(i)/3.0)*100)
            eagle.target(forAction: #selector(YourViewController.doSomething2(sender:)), withSender: self)
            self.scene.addChild(eagle)
            
            //            let label = SKLabelNode(fontNamed: "Chalkduster")
            //            label.text = "You Win!"
            //            label.fontSize = 65
            //            label.fontColor = SKColor.white
            //            label.position = CGPoint(x: self.scene.frame.midX, y: self.scene.frame.midY)
            //
            //            button = UIButton(type: .roundedRect)
            //            button.frame = CGRect(x: (i%3)*100, y: Int(Double(i)/3.0)*100, width: 100, height: 100)
            //            button.setTitle("∏ \(i+1)", for: .normal)
            //            button.setTitleColor(UIColor.black, for: .normal)
            //            button.tintColor = UIColor.blue
            //            button.backgroundColor = UIColor.clear
            //            button.layer.borderWidth = 1.0
            //            button.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
            //            button.layer.cornerRadius = cornerRadius
            //            button.showsTouchWhenHighlighted = true
            //            button.tag = i
            //            button.addTarget(self, action: #selector(YourViewController.doSomething(sender:)), for: .touchUpInside)
            //
            //            spriteView.addSubview(button)
            //            buttons.append(button)
            
            //            print("∆\(i)")
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
//viewController.preferredContentSize = CGSize(width: (Int(7/5*Width)), height: (Int(7/5*Height)))
PlaygroundSupport.PlaygroundPage.current.liveView = viewController
