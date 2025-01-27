import SpriteKit

class GameScene: SKScene {
    override func didMove(to view: SKView) {
        // Настройка доски
        let board = SKShapeNode(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        board.fillColor = .brown
        board.position = CGPoint(x: frame.midX - board.frame.width / 2, y: frame.midY - board.frame.height / 2)
        addChild(board)

        // Добавляем шашки
        for i in 0..<8 {
            let checker = SKShapeNode(circleOfRadius: 20) // Шашка радиусом 20
            checker.fillColor = .black
            checker.position = CGPoint(x: CGFloat(i) * 60 + 50, y: 100)
            checker.physicsBody = SKPhysicsBody(circleOfRadius: 20)
            checker.physicsBody?.isDynamic = true
            checker.physicsBody?.restitution = 0.8 // Эластичность
            addChild(checker)
        }
    }
}