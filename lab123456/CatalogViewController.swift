import UIKit
import SnapKit

final class CatalogViewController: UIViewController {
    
    private let products: [Product] = [
        Product(
            name: "Кожаные лоферы",
            description: "Лоферы из натуральной кожи. Фигурная союзка с фактурным швом по контуру.",
            price: 14999,
            imageName: "lofer",
            sizes: ["XXS", "XS", "S", "M", "L", "XL", "XXL"],
            specs: "Материал: натуральная кожа\nЦвет: черный"
        ),
        Product(
            name: "Кожаные лоферы",
            description: "Лоферы из натуральной кожи. Фигурная союзка с фактурным швом по контуру.",
            price: 14999,
            imageName: "lofer",
            sizes: ["38", "39", "40", "41", "42"],
            specs: "Материал: натуральная кожа\nЦвет: черный"
        ),
        Product(
            name: "Кожаные лоферы",
            description: "Лоферы из натуральной кожи. Фигурная союзка с фактурным швом по контуру.",
            price: 14999,
            imageName: "lofer",
            sizes: ["38", "39", "40", "41", "42"],
            specs: "Материал: натуральная кожа\nЦвет: черный"
        ),
    ]
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 11, bottom: 16, right: 11) // Отступы
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1)
        cv.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.reuseID)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        title = "Каталог"
        navigationItem.backButtonTitle = ""
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1)
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension CatalogViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.reuseID, for: indexPath) as! ProductCell
        cell.configure(with: products[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let totalWidth = view.frame.width
            let padding: CGFloat = 11 * 2
            let itemWidth = totalWidth - padding
            let itemHeight: CGFloat = 166
            return CGSize(width: itemWidth, height: itemHeight)
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = products[indexPath.item]
        let detailVC = ProductDetailViewController()
     
        detailVC.productName = product.name
        detailVC.productDescription = product.description
        detailVC.productImage = UIImage(named: product.imageName)
        detailVC.productPrice = product.price
        detailVC.availableSizes = product.sizes
        detailVC.productSpecs = product.specs
        
        
        if let sheet = detailVC.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
        }
        
        present(detailVC, animated: true)
    
    }
}

