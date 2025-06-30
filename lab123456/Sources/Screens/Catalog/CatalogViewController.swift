import UIKit
import SnapKit

final class CatalogViewController: UIViewController {
    private let viewModel = CatalogViewModel()
        private var tableView: UITableView!
    
    private let categoriesScrollView = UIScrollView()
        private let categoriesStackView = UIStackView()
        private let collectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 32
            layout.minimumInteritemSpacing = 32
            let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
            cv.backgroundColor = UIColor(named: "White")
            cv.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.reuseID)
            return cv
        }()
        private let bottomMenuView = UIView()
        private let menuButton = UIButton()
        private let cartButton = UIButton()
        
        private let categories = ["Новинки", "Одежда", "Обувь", "Аксессуары"]
        private var selectedCategoryIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
    
    private func loadData() {
        viewModel.fetchProducts { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "White")
        
        setupCategories()
        
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(categoriesScrollView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-60)
        }
        
        setupTabBar()
    }
 
        private func setupCategories() {
            let categoriesContainer = UIView()
            categoriesContainer.backgroundColor = UIColor(named: "White")
            categoriesContainer.layer.shadowColor = UIColor.black.cgColor
            categoriesContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
            categoriesContainer.layer.shadowOpacity = 0.1
            categoriesContainer.layer.shadowRadius = 4
            categoriesContainer.layer.masksToBounds = false
            
            view.addSubview(categoriesContainer)
            categoriesContainer.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(50)
            }
            categoriesScrollView.showsHorizontalScrollIndicator = false
            view.addSubview(categoriesScrollView)
            categoriesScrollView.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(50)
            }
            
            categoriesStackView.axis = .horizontal
            categoriesStackView.spacing = 20
            categoriesStackView.alignment = .center
            categoriesScrollView.addSubview(categoriesStackView)
            categoriesStackView.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
                make.height.equalToSuperview()
            }
            
            for (index, category) in categories.enumerated() {
                let button = UIButton(type: .system)
                button.setTitle(category, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
                button.setTitleColor(index == 0 ? .white : .darkGray, for: .normal)
                button.backgroundColor = index == 0 ? UIColor(named: "ExtraDark") : UIColor(named: "Gray")
                button.layer.cornerRadius = 16
                button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
                button.tag = index
                button.addTarget(self, action: #selector(categoryTapped(_:)), for: .touchUpInside)
                categoriesStackView.addArrangedSubview(button)
            }
        }
        
        private func setupTabBar() {
            let tabBar = UITabBar()
            view.addSubview(tabBar)
            
            // Создаем элементы таббара
            let menuItem = UITabBarItem(title: "Меню", image: UIImage(named: "menu")?.withRenderingMode(.alwaysTemplate), tag: 0)
            let cartItem = UITabBarItem(title: "Корзина", image: UIImage(named: "cart")?.withRenderingMode(.alwaysTemplate), tag: 1)
            
            // Настройка внешнего вида
            tabBar.items = [menuItem, cartItem]
            tabBar.backgroundColor = UIColor(named: "White")
            tabBar.tintColor = .black
            tabBar.unselectedItemTintColor = .gray
            
            // Позиционирование
            tabBar.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(view.safeAreaLayoutGuide)
                $0.height.equalTo(48)
            }
            
            // Центрирование иконок с разными отступами
            DispatchQueue.main.async {
                guard let items = tabBar.items, items.count == 2 else { return }
                
                // Для левой иконки (Меню) - положительный отступ справа
                items[0].titlePositionAdjustment = UIOffset(horizontal: 60, vertical: 0)
                
                // Для правой иконки (Корзина) - положительный отступ слева
                items[1].titlePositionAdjustment = UIOffset(horizontal: -60, vertical: 0)
            }
        }
        
        @objc private func categoryTapped(_ sender: UIButton) {
            categoriesStackView.arrangedSubviews.forEach { view in
                guard let button = view as? UIButton else { return }
                button.backgroundColor = UIColor(named: "Gray")
                button.setTitleColor(UIColor(named: "Black"), for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            }
            
            sender.backgroundColor = UIColor(named: "ExtraDark")
            sender.setTitleColor(.white, for: .normal)
            sender.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            
            selectedCategoryIndex = sender.tag
            print("Выбрана категория:", categories[sender.tag])
        }
    }


extension CatalogViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductCell.reuseID,
            for: indexPath
        ) as? ProductCell else {
            fatalError("Не удалось создать ячейку ProductCell")
        }
        
        cell.configure(with: viewModel.products[indexPath.item])
        return cell // Теперь возвращает UICollectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let totalWidth = view.frame.width
            let padding: CGFloat = 16 * 2
            let itemWidth = totalWidth - padding
            let itemHeight: CGFloat = 166
            return CGSize(width: itemWidth, height: itemHeight)
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = viewModel.products[indexPath.item]
        let detailVC = ProductDetailViewController()
        
        detailVC.productName = product.title
        detailVC.productDescription = product.description
        detailVC.productPrice = product.price
        detailVC.productImageURL = product.image  // Передаём URL
        
        present(detailVC, animated: true)
    }
}

