////
////  GameScene.swift
////  Snake
////
////  Created by João de Vasconcelos on 30/10/2016.
////  Copyright © 2016 João de Vasconcelos. All rights reserved.
////
//
//import SpriteKit
//import GameplayKit
//
//class GameScene: SKScene {
//    
//    var entities = [GKEntity]()
//    var graphs = [String : GKGraph]()
//    
//    fileprivate var lastUpdateTime : TimeInterval = 0
//    fileprivate var label : SKLabelNode?
//    fileprivate var spinnyNode : SKShapeNode?
//    
//    override func sceneDidLoad() {
//
//        self.lastUpdateTime = 0
//        
//        // Get label node from scene and store it for use later
//        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
//        if let label = self.label {
//            label.alpha = 0.0
//            label.run(SKAction.fadeIn(withDuration: 2.0))
//        }
//        
//        // Create shape node to use during mouse interaction
//        let w = (self.size.width + self.size.height) * 0.05
//        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
//        
//        if let spinnyNode = self.spinnyNode {
//            spinnyNode.lineWidth = 2.5
//            
//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(M_PI), duration: 1)))
//            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                              SKAction.fadeOut(withDuration: 0.5),
//                                              SKAction.removeFromParent()]))
//        }
//    }
//    
//    
//    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
//    }
//    
//    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
//    }
//    
//    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
//        
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
//    }
//    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//    
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//    
//    
//    override func update(_ currentTime: TimeInterval) {
//        // Called before each frame is rendered
//        
//        // Initialize _lastUpdateTime if it has not already been
//        if (self.lastUpdateTime == 0) {
//            self.lastUpdateTime = currentTime
//        }
//        
//        // Calculate time since last update
//        let dt = currentTime - self.lastUpdateTime
//        
//        // Update entities
//        for entity in self.entities {
//            entity.update(deltaTime: dt)
//        }
//        
//        self.lastUpdateTime = currentTime
//    }
//}







//
//  Snake
//
//  GameScene.swift
//
//  Created by João de Vasconcelos.
//  Copyright (c) 2014 João de Vasconcelos. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    /* * * VARIABLES * * */
    
    
    /* RESOURCES */
    
    let settings = Settings()
    let theme = Themes()
    
    
    
    /* APPLICATION WIDE HANDLERS */
    
    var firstTocuhIsYetToCome = true;
    
    
    
    /* SCORE */
    
    var score = 0
    var scoreLabel = SKLabelNode()
    
    
    
    /* PHYSICS */
    
    let category_snake: UInt32 = 1 << 0
    let category_food: UInt32 = 1 << 1
    let category_dizy: UInt32 = 1 << 2
    let category_dead: UInt32 = 1 << 3
    
    
    /* * * END OF VARIABLES * * */
    
    
    
    /* * * INITIALIZERS * * */
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override init(size: CGSize) {
        
        theme.setTheme(settings.getDefaultTheme())
        
        super.init(size: size)
        
    }
    
    /* * * END OF INITIALIZERS * * */
    
    
    
    /* * * WHEN SCENE BECOMES ACTIVE * * */
    
    override func didMove(to view: SKView) {
        
        
        // COLORS
        
        backgroundColor = theme.getColor("Game", element: "Background")
        
        
        // DISPLAY SCORE
        
        scoreLabel = SKLabelNode(fontNamed: theme.fonts()[0])
        scoreLabel.fontSize = 18
        scoreLabel.position = CGPoint(x: size.width/2, y: 25)
        scoreLabel.fontColor = theme.getColor("Game", element: "Foreground")
        
        addChild(scoreLabel)
        
        
        // TOUCHES
        
        setupSnakeSwipeGestures()
        
        
        // PHYSICS
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        physicsWorld.contactDelegate = self
        
        
        // INTIALIZE SNAKE
        
        initializeSnake()
        
        
        // INITIALIZE ELEMENTS * MODIFICATION ZONE *
        
        initialize("Food")
        initialize("Dead")
        
        
        // NOTIFICATION OBSERVERS
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameScene.pauseGame), name: NSNotification.Name(rawValue: "pauseGameNotification"), object: nil)
        
    }
    
    
    
    /* * * SCORE * * */
    
    func updateScore() {
        
        score += 1
        
        scoreLabel.text = "\(score)  \(settings.getHighScore(score))"
        
    }
    
    
    
    /* * * SETUP TOUCHES * * */
    
    func setupSnakeSwipeGestures() {
        
        let swipeRightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedRight(_:)))
        
        swipeRightGestureRecognizer.direction = .right
        
        view?.addGestureRecognizer(swipeRightGestureRecognizer)
        
        
        let swipeLeftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedLeft(_:)))
        
        swipeLeftGestureRecognizer.direction = .left
        
        view?.addGestureRecognizer(swipeLeftGestureRecognizer)
        
        
        let swipeUpGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedUp(_:)))
        
        swipeUpGestureRecognizer.direction = .up
        
        view?.addGestureRecognizer(swipeUpGestureRecognizer)
        
        
        let swipeDownGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedDown(_:)))
        
        swipeDownGestureRecognizer.direction = .down
        
        view?.addGestureRecognizer(swipeDownGestureRecognizer)
        
    }
    
    
    func swipedRight(_ sender:UISwipeGestureRecognizer){
        
        if !(direction == "RIGHT" || direction == "LEFT") {
            
            setDirection("RIGHT")
            
        }
        
        if firstTocuhIsYetToCome {
            
            startGame()
            
        }
        
    }
    
    
    func swipedLeft(_ sender:UISwipeGestureRecognizer){
        
        if !(direction == "LEFT" || direction == "RIGHT") {
            
            setDirection("LEFT")
            
        }
        
        if firstTocuhIsYetToCome {
            
            startGame()
            
        }
        
    }
    
    
    func swipedUp(_ sender:UISwipeGestureRecognizer){
        
        if !(direction == "UP" || direction == "DOWN") {
            
            setDirection("UP")
            
        }
        
        if firstTocuhIsYetToCome {
            
            startGame()
            
        }
        
    }
    
    
    func swipedDown(_ sender:UISwipeGestureRecognizer){
        
        if !(direction == "DOWN" || direction == "UP") {
            
            setDirection("DOWN")
            
        }
        
        if firstTocuhIsYetToCome {
            
            startGame()
            
        }
        
    }
    
    
    func setupPauseResumeTapGesture(_ pause: Bool) {
        
        var function = "startGame"
        
        if pause {
            
            function = "pauseGame"
            
        }
        
        let tapToPauseOrResumeGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector(function))
        
        tapToPauseOrResumeGestureRecognizer.numberOfTapsRequired = settings.tapsToPause()
        
        view?.addGestureRecognizer(tapToPauseOrResumeGestureRecognizer)
        
    }
    
    
    
    
    
    
    
    
    /* * * SNAKE * * */
    
    func initializeSnake() {
        
        for i in 0 ..< settings.initialSnakeLenght() {
            
            updateScore()
            
            addHeadToSnake()
            
        }
        
    }
    
    
    /* SNAKE BODY */
    
    var snakeBody: [SKSpriteNode] = []
    
    func addHeadToSnake() {
        
        var node = getNewNode(theme.getColor("Game", element: "Snake"), random: true)
        
        if !(snakeBody.isEmpty) {
            
            node.position = snakeBody[0].position
            
        }
        
        
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: node.size.width - 2, height: node.size.height - 2))
        node.physicsBody?.isDynamic = true
        node.physicsBody?.categoryBitMask = category_snake
        node.physicsBody?.contactTestBitMask = category_snake | category_food | category_dizy | category_dead
        node.physicsBody?.collisionBitMask = 0
        node.physicsBody?.usesPreciseCollisionDetection = true
        
        
        var blockSize = CGFloat(settings.blockSize())
        
        var borderUp = size.height + blockSize/2
        var borderDown: CGFloat = 0
        var borderLeft: CGFloat = 0
        var borderRight = size.width + blockSize/2
        
        
        switch direction {
            
        case "UP":
            
            node.position.y += blockSize
            
            if (node.position.y > borderUp) {
                node.position.y = borderDown
            }
            
        case "DOWN":
            
            node.position.y -= blockSize
            
            if (node.position.y < borderDown) {
                node.position.y = borderUp
            }
            
        case "LEFT":
            
            node.position.x -= blockSize
            
            if (node.position.x < borderLeft) {
                node.position.x = borderRight
            }
            
        default:
            
            node.position.x += blockSize
            
            if (node.position.x > borderRight) {
                node.position.x = borderLeft
            }
        }
        
        self.addChild(node)
        snakeBody.insert(node, at: 0)
        
    }
    
    
    var removeTail = true
    
    func removeTailFromSnake() {
        
        if removeTail {
            
            snakeBody.last?.removeFromParent()
            snakeBody.removeLast()
            
        } else {
            
            removeTail = true
            
        }
        
    }
    
    
    /* HELPER METHODS TO MOVE OR GROW SNAKE */
    
    func moveSnake() {
        
        addHeadToSnake()
        removeTailFromSnake()
        
    }
    
    func growSnake() {
        
        removeTail = false
        updateScore()
        
    }
    
    
    /* DIRECTION OF SNAKE */
    
    var direction = "UP"
    
    func setDirection(_ dir: String) {
        
        direction = dir
        
    }
    
    
    /* SNAKE TIMER */
    
    var snakeTimer: Timer!
    
    func startSnakeTimer() {
        
        let speed = TimeInterval(settings.snakeSpeed()) / 100
        
        snakeTimer = Timer.scheduledTimer(timeInterval: speed, target: self, selector: #selector(GameScene.moveSnake), userInfo: nil, repeats: true)
        
    }
    
    func stopSnakeTimer() {
        
        if !firstTocuhIsYetToCome {
            
            snakeTimer.invalidate()
            
        }
        
    }
    
    
    /* * * END OF SNAKE * * */
    
    
    
    /* * * ELEMENTS * * */
    
    var elements: [String: [SKSpriteNode]]!
    
    func initialize(_ element: String) {
        
        if let e = elements {
            
            elements[element] = [SKSpriteNode()]
            
        } else {
            
            elements = [element: [SKSpriteNode]()]
            
        }
        
        for var i = 0; i < settings.elementCount(element); i += 1 {
            
            regenerate(element)
            
        }
        
    }
    
    
    func regenerate(_ element: String) {
        
        var node = getNewNode(theme.getColor("Game", element: element), random: true)
        
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        
        switch element {
            
        case "Dizy":
            
            node.physicsBody?.categoryBitMask = category_dizy
            
        case "Dead":
            
            node.physicsBody?.categoryBitMask = category_dead
            
            // case "NEW_ELEMENT":
            
            // IF A NEW ELEMENT IS ADDED:
            // UPDATE THIS SWITCH TO REFLECT THE NEW CHANGES
            
        default:
            
            node.physicsBody?.categoryBitMask = category_food
            
        }
        
        node.physicsBody?.isDynamic = false
        node.physicsBody?.contactTestBitMask = category_snake | category_food | category_dizy | category_dead
        node.physicsBody?.collisionBitMask = 0
        node.physicsBody?.usesPreciseCollisionDetection = true
        
        
        self.addChild(node)
        
        elements[element]!.append(node)
        
    }
    
    
    /* * * END OF ELEMENTS * * */
    
    
    
    /* * * CONSTRUCTION OF ELEMENTS * * */
    
    /* THIS METHOD IS RESPONSIBLE FOR PROVIDING NODES APP WIDE */
    
    func getNewNode(_ color: UIColor, random: Bool) -> SKSpriteNode {
        
        let blockSize = settings.blockSize()
        
        let node = SKSpriteNode(color: color, size: CGSize(width: blockSize, height: blockSize))
        
        if random {
            
            node.position = randomNodePosition()
            
        }
        
        return node
        
    }
    
    
    /* THIS METHOD IS RESPONSIBLE FOR PROVIDING RANDOM COORDINATES APP WIDE */
    
    func randomNodePosition() -> CGPoint {
        
        let blockSize = UInt32(settings.blockSize())
        
        let width: UInt32 = UInt32(size.width)
        let height: UInt32 = UInt32(size.height)
        
        return CGPoint(
            
            x: round( CGFloat( arc4random_uniform(width) + blockSize ) / 15) * 15,
            
            y: round( CGFloat( arc4random_uniform(height) + blockSize ) / 15) * 15
            
        )
        
    }
    
    
    /* * * END OF CONSTRUCTION OF ELEMENTS * * */
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /* * * PHYSICS CONTACTS * * */
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        switch (contact.bodyA.categoryBitMask, contact.bodyB.categoryBitMask) {
            
            
        case (category_snake, category_food):
            
            contact.bodyB.node?.removeChildren(in: elements["Food"]!)
            contact.bodyB.node?.removeFromParent()
            
            growSnake()
            regenerate("Food")
            
        case (category_food, category_snake):
            
            contact.bodyA.node?.removeChildren(in: elements["Food"]!)
            contact.bodyA.node?.removeFromParent()
            
            growSnake()
            regenerate("Food")
            
            
        case (category_snake, category_dizy):
            
            contact.bodyB.node?.removeChildren(in: elements["Dizy"]!)
            contact.bodyB.node?.removeFromParent()
            
            // applyDizyEffect()
            regenerate("Dizy")
            
            
        case (category_dizy, category_snake):
            
            contact.bodyA.node?.removeChildren(in: elements["Dizy"]!)
            contact.bodyA.node?.removeFromParent()
            
            // applyDizyEffect()
            regenerate("Dizy")
            
            
        case (category_snake, category_dead), (category_dead, category_snake), (category_snake, category_snake):
            
            gameOver()
            
        default:
            
            growSnake()
            
        }
        
    }
    
    
    /* * * END OF PHYSICS CONTACTS * * */
    
    
    
    
    
    
    
    
    
    /* * * GAME STATES * * */
    
    func startGame() {
        
        firstTocuhIsYetToCome = false
        
        view?.gestureRecognizers?.removeAll()
        
        setupSnakeSwipeGestures()
        setupPauseResumeTapGesture(true)
        
        startSnakeTimer()
        
    }
    
    
    func pauseGame() {
        
        stopSnakeTimer()
        
        firstTocuhIsYetToCome = true
        
        view?.gestureRecognizers?.removeAll()
        
        setupSnakeSwipeGestures()
        setupPauseResumeTapGesture(false)
        
    }
    
    
    func gameOver() {
        
        stopSnakeTimer()
        
        view?.gestureRecognizers?.removeAll()
        
        
        // TRANSITION TO GAME OVER SCENE
        
        let fadeToColor = SKTransition.fade(with: theme.getColor("Main", element: "Background"), duration: 1)
        
        let gameOverScene = GameOverScene(size: self.scene!.size, theme: theme, score: score)
        
        view?.presentScene(gameOverScene, transition: fadeToColor)
        
    }
    
    
    /* * * END OF GAME STATES * * */
    
}
