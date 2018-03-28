import Foundation

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
