import UIKit

class BottomSheetViewController: UIViewController {
    
    // Constants for bottom sheet height
    let defaultSheetHeight: CGFloat = 300
    let maximumSheetHeight: CGFloat = UIScreen.main.bounds.height - 100
    
    // Constants for animation duration
    let animationDuration: TimeInterval = 0.3
    
    // Views
    let bottomSheetView = UIView()
    let contentView = UIView()
    let handleView = UIView()
    
    // Constraints
    var bottomSheetViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
//        setupBottomSheet()
//        addPanGesture()
    }
    
    func setupBottomSheet() {
        bottomSheetView.backgroundColor = .white
        bottomSheetView.layer.cornerRadius = 12
        bottomSheetView.clipsToBounds = true
        bottomSheetView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomSheetView)
        
        // Content View
        contentView.backgroundColor = .clear
        contentView.translatesAutoresizingMaskIntoConstraints = false
        bottomSheetView.addSubview(contentView)
        
        // Handle View
        handleView.backgroundColor = .lightGray
        handleView.layer.cornerRadius = 3
        handleView.translatesAutoresizingMaskIntoConstraints = false
        bottomSheetView.addSubview(handleView)
        
        // Constraints
        NSLayoutConstraint.activate([
            bottomSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSheetView.heightAnchor.constraint(equalToConstant: defaultSheetHeight),
            
            handleView.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 8),
            handleView.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor),
            handleView.widthAnchor.constraint(equalToConstant: 40),
            handleView.heightAnchor.constraint(equalToConstant: 6),
            
            contentView.topAnchor.constraint(equalTo: handleView.bottomAnchor, constant: 8),
            contentView.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomSheetView.bottomAnchor)
        ])
        
        bottomSheetViewBottomConstraint = bottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultSheetHeight)
        bottomSheetViewBottomConstraint.isActive = true
    }
    
    func addPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        bottomSheetView.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        let velocity = recognizer.velocity(in: view)
        
        switch recognizer.state {
        case .changed:
            bottomSheetViewBottomConstraint.constant -= translation.y
            recognizer.setTranslation(.zero, in: view)
        case .ended:
            if velocity.y < 0 {
                bottomSheetViewBottomConstraint.constant = -maximumSheetHeight
            } else {
                bottomSheetViewBottomConstraint.constant = 0
            }
            
            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
            }
        default:
            break
        }
    }
}
