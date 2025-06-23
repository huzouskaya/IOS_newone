import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private let catalogButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Перейти в каталог", for: .normal)
        button.backgroundColor = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(openCatalog), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(catalogButton)
        
        catalogButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }
    
    @objc private func openCatalog() {
        let catalogVC = CatalogViewController()
        let navController = UINavigationController(rootViewController: catalogVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
}
