import SpriteKit

enum GameState {
    case ai, player
}

class GameScene: SKScene {
    
    let settings = SM()
    
    let boardSize = 8
    let cellSize: CGFloat = DeviceCool.shared.deviceType == .pad ? 80:40
    let checkerRadius: CGFloat = DeviceCool.shared.deviceType == .pad ? 30:15
    var selectedChecker: SKSpriteNode?
    var directionArrow: SKShapeNode?
    
    var playerChecks: [String] = []
    var opponentChecks: [String] = []
    
    var currentPlayerHandle: ((_ currentPlayer: Int)->())?
    var winnerHandle: ((_ winner: Int)->())?
    
    var opponentState: GameState = .ai
    
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
        
        for col in 0..<boardSize {
            let checker = createChecker(row: 0, col: col, imageName: playerChecks[col], player: 1)
            player1Checkers.append(checker)
        }
        
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
        checker.userData = ["player": player]
        
        addChild(checker)
        return checker
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if let node = nodes(at: location).first(where: { $0.name?.contains("checker") == true }) as? SKSpriteNode {
            // Проверяем, принадлежит ли шашка текущему игроку
            if let player = node.userData?["player"] as? Int, player == currentPlayer {
                if opponentState == .ai {
                    if player == 1 {
                        selectedChecker = node
                        showArrow(at: location)
                    }
                } else {
                    selectedChecker = node
                    showArrow(at: location)
                }
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
        
        checker.physicsBody?.applyImpulse(DeviceCool.shared.deviceType == .pad ? CGVector(dx: dx / 5, dy: dy / 5):CGVector(dx: dx / 10, dy: dy / 10))
        if settings.soundEnabled {
            playSound(named: "volleySound")
        }
        arrow.removeFromParent()
        directionArrow = nil
        selectedChecker = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1)  {
            self.switchPlayer()
        }
        
    }
    
    func checkWinConditions(for player: Int) {
        let opponentCheckers = player == 1 ? player2Checkers : player1Checkers
        let playerCheckers = player == 1 ? player1Checkers : player2Checkers

        // 1. Проверяем, выбросил ли игрок свою "пустую" фишку → немедленный проигрыш
        if playerCheckers.contains(where: { $0.parent == nil && $0.name?.contains(emptyCheckerName) == true }) {
            gameOver(winner: player == 1 ? 2 : 1)
            return
        }

        // 2. Проверяем, выбил ли игрок "пустую" фишку противника до всех остальных → немедленный проигрыш
        if let emptyChecker = opponentCheckers.first(where: { $0.name?.contains(emptyCheckerName) == true }),
           emptyChecker.parent == nil,
           opponentCheckers.contains(where: { $0.parent != nil && $0.name != emptyCheckerName }) {
            gameOver(winner: player == 1 ? 2 : 1)
            return
        }

        // 3. Победа, если все фишки противника сбиты и последней была "пустая" фишка
        if opponentCheckers.allSatisfy({ $0.parent == nil }) {
            gameOver(winner: player)
        }
    }

    func gameOver(winner: Int) {
            self.winnerHandle?(winner)
        
            self.restartGame()
        
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

        // Получаем имя фишки
        guard let checkerName = checker.name else { return }

        // 1. Если игрок выбил свою пустую фишку → проигрыш
        if checkerName.contains(emptyCheckerName) && currentPlayerCheckers.contains(checker) {
            gameOver(winner: isPlayer1Turn ? 2 : 1)
            return
        }

        // 2. Если игрок выбил пустую фишку соперника раньше времени → проигрыш
        if checkerName.contains(emptyCheckerName) && opponentCheckers.contains(checker) {
            let remainingOpponentCheckers = opponentCheckers.filter { $0.parent != nil && !$0.name!.contains(emptyCheckerName) }
            
            if !remainingOpponentCheckers.isEmpty {
                gameOver(winner: isPlayer1Turn ? 2 : 1)
                return
            }
        }


        // Удаляем фишку из соответствующего массива
        if let index = currentPlayerCheckers.firstIndex(of: checker) {
            currentPlayerCheckers.remove(at: index)
        } else if let index = opponentCheckers.firstIndex(of: checker) {
            opponentCheckers.remove(at: index)
        }

        // Проверяем, остались ли у противника фишки кроме пустой
        let remainingOpponentCheckers = opponentCheckers.filter { $0.parent != nil }

        // Если у противника не осталось фишек → победа
        if remainingOpponentCheckers.isEmpty {
            gameOver(winner: currentPlayer)
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
        currentPlayerHandle?(currentPlayer)
        print("Сейчас ход игрока \(currentPlayer)")
        if opponentState == .ai {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if self.currentPlayer == 2 {
                    self.aiMove()
                }
            }
        }
    }
    
    func aiMove() {
        // Фильтруем шашки, которые всё ещё находятся на доске
        let activeAIcheckers = player2Checkers.filter { $0.parent != nil }
        let activePlayerCheckers = player1Checkers.filter { $0.parent != nil }
        
        guard !activeAIcheckers.isEmpty, !activePlayerCheckers.isEmpty else { return }
        
        // Выбираем случайную шашку ИИ
        let randomChecker = activeAIcheckers.randomElement()!
        
        // Выбираем случайную шашку игрока
        let targetChecker = activePlayerCheckers.randomElement()!
        
        // Вычисляем вектор направления к цели
        let dx = targetChecker.position.x - randomChecker.position.x
        let dy = targetChecker.position.y - randomChecker.position.y
        let magnitude = sqrt(dx * dx + dy * dy)
        
        // Нормализуем вектор и умножаем на силу удара
        let impulseStrength: CGFloat = 20.0
        let impulse = CGVector(dx: (dx / magnitude) * impulseStrength,
                               dy: (dy / magnitude) * impulseStrength)
        
        // Применяем импульс к шашке ИИ
        randomChecker.physicsBody?.applyImpulse(impulse)
        
        // Завершаем ход через 0.5 секунды
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.switchPlayer()
        }
    }
    
    func restartGame() {
        // 1. Удаляем всех шашки со сцены
        for checker in player1Checkers + player2Checkers {
            checker.removeFromParent()
        }
        
        // 2. Очищаем массивы шашек
        player1Checkers.removeAll()
        player2Checkers.removeAll()
        
        // 3. Удаляем все текстовые надписи (например, "Игрок X выиграл!")
        for node in children {
            if let label = node as? SKLabelNode {
                label.removeFromParent()
            }
        }

        // 4. Сбрасываем текущего игрока
        
        self.currentPlayer = 1
        self.currentPlayerHandle?(self.currentPlayer)
        

        // 5. Добавляем шашки заново
        addCheckers()

        // 6. Убираем паузу
        isPaused = false
        
        if opponentState == .ai {
            if currentPlayer == 2 {
                    self.aiMove()
                
            }
        }
        
        print("Игра перезапущена!")
    }
    
    func playSound(named name: String) {
        run(SKAction.playSoundFileNamed(name, waitForCompletion: false))
        
    }
}
