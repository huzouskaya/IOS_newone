import UIKit
import SnapKit

final class CatalogViewController: UIViewController {
    
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
    
    private let products: [Product] = [
        Product(
            name: "Блейзер прямого кроя",
            description: """
            Двубортный блейзер прямого кроя из ткани на основе лиоцелла и вискозы.
            Отложной воротник с заостренными лацканами.
            Длинные рукава с пуговицами на манжетах, подплечники.
            Передние карманы с клапанами.
            Нагрудный прорезной карман.
            Внутренние карманы.
            Подкладка в тон.
            Застежка на пуговицы.
            """,
            price: 2970,
            imageName: "blazer",
            sizes: ["XXS", "XS", "S", "M", "L", "XL", "XXL"],
            specs: """
        Материал: 65% лиоцелл, 35% вискоза (плотность 280 г/м²)
        Подкладка: 100% вискоза (атласное плетение)
        Конструкция: полуприлегающий силуэт с подплечниками
        Детали:
        - 2 внутренних кармана (один с клапаном)
        - Нагрудный карман для платка
        - 4 функциональные пуговицы на рукавах
        Фурнитура: пуговицы из рога буйвала
        Цвет: глубокий синий (цвет midnight blue)
        Уход: только химчистка
        Производство: Италия (ручная сборка)
        Артикул: BL-7742-500
        """
        ),
        Product(
            name: "Брюки из лиоцелла",
            description: "Брюки прямого кроя из ткани на основе лиоцелла и вискозы. Защипы под поясом. Передние классические карманы и прорезные карманы сзади. Застежка на молнию, внешнюю и внутреннюю пуговицы.",
            price: 7500,
            imageName: "trousers",
            sizes: ["XXS", "XS", "S", "M", "L", "XL", "XXL"],
            specs: """
        Материал: 70% лиоцелл, 30% вискоза (плотность 240 г/м²)
        Подкладка: 100% вискоза (в области пояса и карманов)
        Особенности: защипы под поясом для идеальной посадки
        Карманы: 2 передних классических + 2 прорезных сзади
        Застежка: молния + пуговица (внешняя и внутренняя)
        Цвет: угольно-черный (стойкое окрашивание)
        Уход: химчистка или деликатная стирка при 30°C
        Длина: стандартная (возможен подгиб)
        Производство: Португалия
        Артикул: TR-8891-100
        """
        ),
        Product(
            name: "Кардиган из хлопка",
            description: """
        Уютный кардиган из плотного хлопка с короткими рукавами и застежкой на пуговицы.
        Классический прямой крой подходит для любого типа фигуры.
        Универсальная модель для создания многослойных образов.
        Идеально сочетается с футболками, рубашками и блузами.
        """,
            price: 14999,
            imageName: "cardigan",
            sizes: ["XXS", "XS", "S", "M", "L", "XL", "XXL"],
            specs: """
        Материал: 100% хлопок (плотность 280 г/м²)
        Уход: машинная стирка при 30°C, глажка на средней температуре
        Цвет: черный (не линяет)
        Фурнитура: пуговицы из натурального перламутра
        Производство: Италия
        Сезон: весна/лето
        Артикул: CW-2294-001
        """
        ),
        Product(
            name: "Джинсы straight fit",
            description: """
        Классические прямые джинсы универсального кроя из плотного хлопка.
        Модель с пятью карманами: два передних, два задних и маленький
        карман для монет. Удобная посадка по фигуре без стягивания.
        Металлическая фурнитура и прочные двойные строчки для долговечности.
        """,
            price: 6750,
            imageName: "jeans",
            sizes: ["XXS", "XS", "S", "M", "L", "XL", "XXL"],
            specs: """
        Материал: 98% хлопок, 2% эластан (плотность 12 oz)
        Посадка: универсальный straight fit (прямой крой)
        Детали: 5 карманов (включая маленький для монет), металлическая фурнитура
        Цвет: классический синий (не выцветает)
        Уход: стирка при 30°C, избегайте отбеливания
        Длина: стандартная (подходит для роста 170-190 см)
        Производство: Турция
        Артикул: DN-4567-301
        """
        ),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.reuseID, for: indexPath) as! ProductCell
        cell.configure(with: products[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let totalWidth = view.frame.width
            let padding: CGFloat = 16 * 2
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

