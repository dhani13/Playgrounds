import Foundation

class tictactoe
{
    var tiles: [Int]
    var gameOver: Bool
    var winner: Int
    
    func newMove(index: Int, player: Int) -> (validMove: Bool, winner: Int?, boxes: [Int]?)
    {
        if(!gameOver && tiles[index] == 0)
        {
            tiles[index] = player
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
            if(tiles[i] == tiles[i+3] && tiles[i] == tiles[i+6] && tiles[i] == player) //columns
            {
                gameOver = true
                winner = player
                return (true, winner, [i, i+3, i+6])
            }
            
            if(tiles[i*3] == tiles[i*3+1] && tiles[i*3] == tiles[i*3+2]  && tiles[i*3] == player) //rows
            {
                gameOver = true
                winner = player
                return (true, winner, [i*3, i*3+1, i*3+2])
            }
        }
        
        if(tiles[2] == tiles[4] && tiles[2] == tiles[6] && tiles[2] == player) //diagonal
        {
            gameOver = true
            winner = player
            return (true, winner, [2, 4, 6])
        }
        
        if(tiles[0] == tiles[4] && tiles[0] == tiles[8] && tiles[0] == player) //diagonal
        {
            gameOver = true
            winner = player
            return (true, winner, [0, 4, 8])
        }
        
        for i in 0...8
        {
            if(tiles[i] != 0) //atleast one tile is unoccupied
            {
                return (true, -1, nil)
            }
        }
        
        gameOver = true
        return (true, 0, nil) //draw
    }
    
    required init()
    {
        tiles = [Int]()
        winner = 0
        gameOver = false
        for _ in 0...8
        {
            tiles.append(0)
        }
    }
}
