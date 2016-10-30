//
//  Snake
//
//  GameOverScene.swift
//
//  Created by João de Vasconcelos.
//  Copyright (c) 2014 João de Vasconcelos. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    var score = 0
    var highScore = 0
    
    var theme: Themes
    
    
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    init(size: CGSize, theme: Themes, score: Int) {
        
        self.score = score
        self.theme = theme
        
        super.init(size: size)
        
    }
    
    
    
    override func didMove(to view: SKView) {
        
        backgroundColor = theme.getColor("Main", element: "Background")
        
        setupCurrentScore()
        
        setupHighScore()
        
    }
    
    
    
    func setupCurrentScore() {
        
        var scoreLabelTitle = SKLabelNode(fontNamed: theme.fonts()[1])
        
        scoreLabelTitle.text = "your score"
        scoreLabelTitle.fontSize = 15
        scoreLabelTitle.fontColor = theme.getColor("Main", element: "Foreground")
        scoreLabelTitle.position = CGPoint(x: size.width/2, y: size.height - 120)
        addChild(scoreLabelTitle)
        
        
        var scoreLabel = SKLabelNode(fontNamed: theme.fonts()[0])
        
        scoreLabel.text = "\(score)"
        scoreLabel.fontSize = 120
        scoreLabel.fontColor = theme.getColor("Main", element: "Foreground")
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height - 230)
        addChild(scoreLabel)
        
    }
    
    
    
    func setupHighScore() {
        
        var highScoreLabelTitle = SKLabelNode(fontNamed: theme.fonts()[1])
        var highScoreLabel = SKLabelNode(fontNamed: theme.fonts()[0])
        
        highScoreLabelTitle.text = "best so far"
        
        
        var defaults: UserDefaults = UserDefaults.standard
        
        if let isNotNill = defaults.object(forKey: "highScore") as? Int {
            
            highScore = defaults.object(forKey: "highScore") as! Int
            
            if score > highScore {
                
                highScore = score
                
                saveUserInfo()
                
                highScoreLabelTitle.text = "new record!"
                
            }
            
        } else {
            
            highScore = score
            
            saveUserInfo()
            
        }
        
        
        highScoreLabelTitle.fontSize = 15
        highScoreLabelTitle.fontColor = theme.getColor("Main", element: "Foreground")
        highScoreLabelTitle.position = CGPoint(x: size.width/2, y: size.height - 350)
        addChild(highScoreLabelTitle)
        
        
        highScoreLabel.text = "\(highScore)"
        highScoreLabel.fontSize = 80
        highScoreLabel.fontColor = theme.getColor("Main", element: "Foreground")
        highScoreLabel.position = CGPoint(x: size.width/2, y: size.height - 430)
        addChild(highScoreLabel)
        
        goBackToGame()
        
    }
    
    
    
    func saveUserInfo() {
        
        let defaults: UserDefaults = UserDefaults.standard
        
        defaults.set(highScore, forKey: "highScore")
        
        defaults.synchronize()
        
    }
    
    
    
    func goBackToGame() {
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 3.0),
            SKAction.run() {
                let fadeToColor = SKTransition.fade(with: self.theme.getColor("Game", element: "Background"), duration: 1)
                self.view?.presentScene(GameScene(size: self.scene!.size), transition: fadeToColor)
            }
            ])
        )
        
    }
    
}
