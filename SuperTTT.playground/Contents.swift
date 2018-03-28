/*
 **SuperTTT** is a super tic-tac-toe game built with Swift 4.
 
 If you don't know the rules of super tic-tac-toe, here they are -
 1) The board is made up of 9 tic-tac-toe games (board), arranged in a 3x3 grid, much like each individual board, hence the name.
 2) To start, player 1 selects a board and places an X in any tile of that board. Henceforth, there is no difference between the players.
 3) The next player then makes their move in the board corresponding to the tile marked by the previous move (don't worry, the board will be highlighted).
 4) Each individual board is independent of the others in its game state i.e. to win a board, the rules of regular tic-tac-toe apply.
 5) Once a board has been won or drawn, no further moves can be made in that board. If a player's next board is one of these, they can choose any other playable board (similar to how the game started).
 6) After every move, the game will zoom out to view all the boards, as the objective is to win the global board by winning individual boards. To make a move, the player will first have to zoom in to the correct board, if the condition applies.
 7) To zoom in, touch the board. To zoom out, touch either a marked tile or the lines which divide the board into tiles.
 8) This is a two-player game. For a computer, it is just as tough as chess, so don't play hastily.
 */

import PlaygroundSupport
import SpriteKit
import UIKit

let viewController = YourViewController(image: "tic-tac-toe-blank.png", xImage: "tic-tac-toe-x.png", oImage: "tic-tac-toe-o.png")
PlaygroundSupport.PlaygroundPage.current.liveView = viewController
