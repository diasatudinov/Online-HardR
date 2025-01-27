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
    
    var playerChecks: [String] = ["inst1", "inst2", "inst3", "inst4", "instEmpty","inst5", "inst6", "inst7"]
    var opponentChecks: [String] = ["inst1", "inst2", "inst3", "inst4", "instEmpty","inst5", "inst6", "inst7"]
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
    
    var firstPlayerMove = true
    var secondPlayerMove = false
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.categoryBitMask = 1
        
        backgroundColor = .systemGray
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
        let topRow = boardSize - 1
        for col in 0..<boardSize {
            createChecker(row: topRow, col: col, imageName: opponentChecks[col % opponentChecks.count])
        }

        // Нижний ряд (синие шашки, игрок)
        let bottomRow = 0
        for col in 0..<boardSize {
            createChecker(row: bottomRow, col: col, imageName: playerChecks[col % playerChecks.count])
        }
    }
    
    func createChecker(row: Int, col: Int, imageName: String) {
        let boardWidth = CGFloat(boardSize) * cellSize
        let boardHeight = CGFloat(boardSize) * cellSize

        // Рассчитываем начальные координаты для центрирования доски
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
        checker.name = "checker"
        checker.zPosition = 1 // Установите zPosition шашек выше клеток

        addChild(checker)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        // Check if the node at the touch location is an SKSpriteNode with the name "checker"
        if let node = nodes(at: location).first(where: { $0.name == "checker" }) as? SKSpriteNode {
            if node.physicsBody?.velocity == CGVectorMake(0, 0) {
                selectedChecker = node
                showArrow(at: location)
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let arrow = directionArrow, let checker = selectedChecker else { return }
        let location = touch.location(in: self)
        let checkerPosition = checker.position
        
        // Calculate the direction vector
        let dx = location.x - checkerPosition.x
        let dy = location.y - checkerPosition.y
        let distance = hypot(dx, dy)
        
        // Set the arrow's rotation based on the swipe direction, with an adjustment of -π/2 radians
        let angle = atan2(dy, dx) - .pi / 2
        arrow.zRotation = angle
        arrow.setScale(min(distance / 100, 2)) // Limit the arrow's maximum length
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let checker = selectedChecker, let arrow = directionArrow else { return }
        let location = touch.location(in: self)
        let checkerPosition = checker.position
        
        // Вычисляем вектор направления
        let dx = location.x - checkerPosition.x
        let dy = location.y - checkerPosition.y
        
        // Применяем импульс к шашке
        checker.physicsBody?.applyImpulse(CGVector(dx: dx / 10, dy: dy / 10))
        
        // Удаляем стрелку и сбрасываем выбор
        arrow.removeFromParent()
        directionArrow = nil
        selectedChecker = nil
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
            if let checker = node as? SKSpriteNode, checker.name == "checker" {
                if checker.position.x < startX ||
                    checker.position.x > endX ||
                    checker.position.y < startY ||
                    checker.position.y > endY {
                    checker.removeFromParent()
                }
            }
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
}
