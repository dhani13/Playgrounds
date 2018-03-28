import PlaygroundSupport
import SpriteKit

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
