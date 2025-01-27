//
//  GameScene.swift
//  Online HardR
//
//  Created by Dias Atudinov on 27.01.2025.
//


import SpriteKit

class GameScene: SKScene {
    let boardSize = 8
    let cellSize: CGFloat = 40
    let checkerRadius: CGFloat = 15
    var selectedChecker: SKSpriteNode?
    var directionArrow: SKShapeNode?
    
    var playerChecks: [String] = ["inst1", "inst2", "inst3", "instEmpty", "inst4","inst5", "inst6", "inst7"]
    var opponentChecks: [String] = ["music1", "music2", "music3", "musicEmpty", "music4","music5", "music6", "music7"]
    let redToWhiteShader = """
    void main() {
        vec2 uv = v_tex_coord;
        vec4 startColor = vec4(0.992, 0.533, 0.902, 1.0); // Красный
        vec4 endColor = vec4(0.996, 0.392, 0.537, 1.0);   // Белый
        gl_FragColor = mix(startColor, endColor, uv.y);
    }
    """
    
    // Градиент от синего к фиолетовому
    let blueToPurpleShader = """
    void main() {
        vec2 uv = v_tex_coord;
        vec4 startColor = vec4(0.463, 0.102, 0.831, 1.0); // Синий
        vec4 endColor = vec4(0.004, 0.443, 0.992, 1.0);   // Фиолетовый
        gl_FragColor = mix(startColor, endColor, uv.y);
    }
    """
    
    var currentPlayer: Int = 1
    var player1Checkers: [SKSpriteNode] = []
    var player2Checkers: [SKSpriteNode] = []
    var emptyCheckerName = "Empty"
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.categoryBitMask = 1
        
        backgroundColor = .clear
        createBoard()
        addCheckers()
    }
    
    func createBoard() {
        let boardWidth = CGFloat(boardSize) * cellSize
        let boardHeight = CGFloat(boardSize) * cellSize
        
        // Рассчитываем начальные координаты для центрирования доски
        let startX = (UIScreen.main.bounds.width - boardWidth) / 2
        let startY = (UIScreen.main.bounds.height - boardHeight) / 2
        
        for row in 0..<boardSize {
            for col in 0..<boardSize {
                let cell = SKSpriteNode(color: .clear, size: CGSize(width: cellSize, height: cellSize))
                if (row + col) % 2 == 0 {
                    // Применяем синий-фиолетовый градиент
                    let shader = SKShader(source: blueToPurpleShader)
                    cell.shader = shader
                } else {
                    // Применяем красный-белый градиент
                    let shader = SKShader(source: redToWhiteShader)
                    cell.shader = shader
                }
                //  cell.fillColor = (row + col) % 2 == 0 ? .systemBrown : .white
                // cell.strokeColor = .clear
                
                let xPosition = startX + CGFloat(col) * cellSize + cellSize / 2
                let yPosition = startY + CGFloat(row) * cellSize + cellSize / 2
                cell.position = CGPoint(x: xPosition, y: yPosition)
                cell.zPosition = 0
                addChild(cell)
            }
        }
    }
    
    func addCheckers() {
        let startX = 0.0
        let startY = 0.0
        
        // Верхний ряд (красные шашки, игрок-соперник)
        // Добавляем шашки для игрока 1 (красные)
        for col in 0..<boardSize {
            let checker = createChecker(row: 0, col: col, imageName: playerChecks[col], player: 1)
            player1Checkers.append(checker)
        }
        
        // Добавляем шашки для игрока 2 (синие)
        for col in 0..<boardSize {
            let checker = createChecker(row: boardSize - 1, col: col, imageName: opponentChecks[col], player: 2)
            player2Checkers.append(checker)
        }
    }
    
    func createChecker(row: Int, col: Int, imageName: String, player: Int) -> SKSpriteNode {
        let boardWidth = CGFloat(boardSize) * cellSize
        let boardHeight = CGFloat(boardSize) * cellSize
        
        let startX = (UIScreen.main.bounds.width - boardWidth) / 2
        let startY = (UIScreen.main.bounds.height - boardHeight) / 2
        
        let checker = SKSpriteNode(imageNamed: imageName)
        checker.size = CGSize(width: checkerRadius * 2, height: checkerRadius * 2)
        
        let xPosition = startX + CGFloat(col) * cellSize + cellSize / 2
        let yPosition = startY + CGFloat(row) * cellSize + cellSize / 2
        checker.position = CGPoint(x: xPosition, y: yPosition)
        
        checker.physicsBody = SKPhysicsBody(circleOfRadius: checkerRadius)
        checker.physicsBody?.isDynamic = true
        checker.physicsBody?.restitution = 0.5
        checker.physicsBody?.friction = 0.8
        checker.physicsBody?.affectedByGravity = false
        checker.physicsBody?.allowsRotation = false
        checker.name = "checker" + imageName
        checker.zPosition = 1
        checker.userData = ["player": player] // Добавляем информацию о владельце шашки
        
        addChild(checker)
        return checker
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if let node = nodes(at: location).first(where: { $0.name?.contains("checker") == true }) as? SKSpriteNode {
            // Проверяем, принадлежит ли шашка текущему игроку
            if let player = node.userData?["player"] as? Int, player == currentPlayer {
                selectedChecker = node
                showArrow(at: location)
            }
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let arrow = directionArrow, let checker = selectedChecker else { return }
        let location = touch.location(in: self)
        let checkerPosition = checker.position
        
        let dx = location.x - checkerPosition.x
        let dy = location.y - checkerPosition.y
        let distance = hypot(dx, dy)
        
        let angle = atan2(dy, dx) - .pi / 2
        arrow.zRotation = angle
        arrow.setScale(min(distance / 100, 2))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let checker = selectedChecker, let arrow = directionArrow else { return }
        let location = touch.location(in: self)
        let checkerPosition = checker.position
        
        let dx = location.x - checkerPosition.x
        let dy = location.y - checkerPosition.y
        
        // Применяем импульс к шашке
        checker.physicsBody?.applyImpulse(CGVector(dx: dx / 10, dy: dy / 10))
        
        // Удаляем стрелку и сбрасываем выбор
        arrow.removeFromParent()
        directionArrow = nil
        selectedChecker = nil
        
        switchPlayer()
    }
    
    func checkWinConditions(for player: Int) {
        let opponentCheckers = player == 1 ? player2Checkers : player1Checkers

        // Проверяем, осталась ли "пустая" фишка
        if let emptyChecker = opponentCheckers.first(where: { $0.name?.contains(emptyCheckerName) == true }) {
            // Если "пустая" фишка сбита, но остались другие фишки
            if emptyChecker.parent == nil && opponentCheckers.contains(where: { $0.parent != nil && $0.name != emptyCheckerName }) {
                gameOver(loser: player)
                return
            }
        }

        // Если все фишки противника сбиты
        if opponentCheckers.allSatisfy({ $0.parent == nil }) {
            gameOver(winner: player)
        }
    }
    
    func gameOver(winner: Int? = nil, loser: Int? = nil) {
        var message: String

        if let winner = winner {
            message = "Игрок \(winner) выиграл!"
        } else if let loser = loser {
            let winner = loser == 1 ? 2 : 1
            message = "Игрок \(loser) проиграл! Игрок \(winner) победил!"
        } else {
            message = "Игра завершилась!"
        }

        // Отображаем сообщение и останавливаем игру
        let label = SKLabelNode(text: message)
        label.fontSize = 24
        label.fontColor = .white
        label.position = CGPoint(x: frame.midX, y: frame.midY)
        label.zPosition = 10
        addChild(label)

        isPaused = true
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Рассчитываем границы доски
        let boardWidth = CGFloat(boardSize) * cellSize
        let boardHeight = CGFloat(boardSize) * cellSize
        let startX = (UIScreen.main.bounds.width - boardWidth) / 2
        let startY = (UIScreen.main.bounds.height - boardHeight) / 2
        let endX = startX + boardWidth
        let endY = startY + boardHeight
        
        // Проверяем все шашки
        for node in children {
            if let checker = node as? SKSpriteNode, checker.name?.contains("checker") == true {
                if checker.position.x < startX ||
                    checker.position.x > endX ||
                    checker.position.y < startY ||
                    checker.position.y > endY {
                    // Удаляем фишку из сцены
                    checker.removeFromParent()
                    
                    // Проверяем условия игры
                    handleCheckerRemoval(checker: checker)
                    
                    return
                        
                }
            }
        }
        
        
    }
    
    func handleCheckerRemoval(checker: SKSpriteNode) {
        let isPlayer1Turn = currentPlayer == 1
        var currentPlayerCheckers = isPlayer1Turn ? player1Checkers : player2Checkers
        var opponentCheckers = isPlayer1Turn ? player2Checkers : player1Checkers
        
        // Проверяем условия победы
        if opponentCheckers.isEmpty {
            // Если у соперника не осталось фишек
            if let lastChecker = checker.name, lastChecker.contains(emptyCheckerName) {
                // Победа текущего игрока, если последняя фишка - пустая
                gameOver(winner: currentPlayer)
            } else {
                // Проигрыш, если сбита не пустая фишка
                gameOver(loser: currentPlayer)
            }
        }
        // Проверяем, была ли выбита пустая фишка
        if let checkerName = checker.name, checkerName.contains(emptyCheckerName) {
            if currentPlayerCheckers.contains(checker) {
                // Игрок выбил свою пустую фишку - немедленный проигрыш
                gameOver(loser: currentPlayer)
                return
            } else if opponentCheckers.contains(checker) {
                // Игрок выбил пустую фишку соперника - немедленный проигрыш
                gameOver(loser: currentPlayer)
                return
            }
        }
        
        // Удаляем фишку из соответствующего массива
        if let index = currentPlayerCheckers.firstIndex(of: checker) {
            currentPlayerCheckers.remove(at: index)
        } else if let index = opponentCheckers.firstIndex(of: checker) {
            opponentCheckers.remove(at: index)
        }
    }
    
    func showArrow(at position: CGPoint) {
        // Если стрелка уже существует, удаляем её
        directionArrow?.removeFromParent()
        
        // Создаём новую стрелку
        let arrowPath = CGMutablePath()
        arrowPath.move(to: .zero)
        arrowPath.addLine(to: CGPoint(x: 0, y: 50))
        arrowPath.addLine(to: CGPoint(x: -5, y: 40))
        arrowPath.move(to: CGPoint(x: 0, y: 50))
        arrowPath.addLine(to: CGPoint(x: 5, y: 40))
        
        let arrow = SKShapeNode(path: arrowPath)
        arrow.strokeColor = .black
        arrow.lineWidth = 2
        arrow.position = position
        arrow.zPosition = 1
        
        addChild(arrow)
        directionArrow = arrow
    }
    
    func switchPlayer() {
        currentPlayer = currentPlayer == 1 ? 2 : 1
        print("Сейчас ход игрока \(currentPlayer)")
    }
}
