import UIKit
import SnapKit

class ProductDetailViewController: UIViewController {
    
    // MARK: - UI Elements
    let productImageView = UIImageView()
    let productNameLabel = UILabel()
    let infoButton = UIButton(type: .system)
    let productDescriptionLabel = UILabel()
    let addToCartButton = UIButton(type: .system)
    let buttonContainerView = UIView()
    let sizesScrollView = UIScrollView()
    let sizesStackView = UIStackView()
    
    // MARK: - Properties
    var productName: String = ""
    var productDescription: String = ""
    var productImage: UIImage?
    var productPrice: Double = 0.0
    var availableSizes: [String] = []
    var productSpecs: String = ""
    private var selectedSize: String?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        view.addSubview(buttonContainerView)
        
        setupScrollView()
        setupProductImage()
        setupProductTitle()
        setupProductDescription()
        setupFixedButtonWithSizes()
    }

    private func setupScrollView() {
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(buttonContainerView.snp.top)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
    }
    
    private func setupProductImage() {
        productImageView.image = productImage
        productImageView.contentMode = .scaleAspectFit
        productImageView.backgroundColor = .white
        productImageView.clipsToBounds = true
        contentView.addSubview(productImageView)
        
        productImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(productImageView.snp.width).multipliedBy(0.67)
        }
    }
    
    private func setupProductTitle() {
        let titleStack = UIStackView()
        titleStack.axis = .horizontal
        titleStack.spacing = 8
        titleStack.alignment = .center
        contentView.addSubview(titleStack)
        
        productNameLabel.text = productName
        productNameLabel.numberOfLines = 2
        productNameLabel.textColor = UIColor(named: "Black")
        productNameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleStack.addArrangedSubview(productNameLabel)
        
        infoButton.setImage(UIImage(named: "infoButton"), for: .normal)
        infoButton.addTarget(self, action: #selector(showProductSpecs), for: .touchUpInside)
        titleStack.addArrangedSubview(infoButton)
        
        titleStack.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        infoButton.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
    }
    
    private func setupProductDescription() {
        productDescriptionLabel.text = productDescription
        productDescriptionLabel.numberOfLines = 0
        productDescriptionLabel.textColor = UIColor(named: "Black")
        productDescriptionLabel.font = UIFont.systemFont(ofSize: 17, weight: .light)
        contentView.addSubview(productDescriptionLabel)
        
        productDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(productNameLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.lessThanOrEqualToSuperview().offset(-16)
        }
    }
    
    private func setupFixedButtonWithSizes() {
        buttonContainerView.backgroundColor = .white
        buttonContainerView.layer.shadowColor = UIColor.black.cgColor
        buttonContainerView.layer.shadowOffset = CGSize(width: 0, height: -2)
        buttonContainerView.layer.shadowOpacity = 0.1
        buttonContainerView.layer.shadowRadius = 4
        
        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.spacing = 8
        buttonContainerView.addSubview(mainStack)
  
        sizesScrollView.showsHorizontalScrollIndicator = false
        
        sizesStackView.axis = .horizontal
        sizesStackView.spacing = 8
        sizesStackView.alignment = .center
        
        let scrollContainer = UIView()
        sizesScrollView.addSubview(scrollContainer)
        scrollContainer.addSubview(sizesStackView)
      
        for size in availableSizes {
            let sizeButton = createSizeButton(title: size)
            sizesStackView.addArrangedSubview(sizeButton)
        }
        
        let separatorLine = UIView()
        separatorLine.backgroundColor = UIColor(named: "Gray")
        separatorLine.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        
        let priceFormatted = String(format: "%.0f", productPrice)
        addToCartButton.setTitle("В корзину • \(priceFormatted) ₽", for: .normal)
        addToCartButton.backgroundColor = UIColor(named: "Dark")
        addToCartButton.setTitleColor(.white, for: .normal)
        addToCartButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        addToCartButton.layer.cornerRadius = 8
        addToCartButton.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
        
        mainStack.addArrangedSubview(sizesScrollView)
        mainStack.addArrangedSubview(separatorLine)
        mainStack.addArrangedSubview(addToCartButton)
        
        buttonContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(126) // Общая высота
        }
        
        mainStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        sizesScrollView.snp.makeConstraints { make in
            make.height.equalTo(34) // Высота блока размеров
        }
        
        scrollContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        sizesStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18))
            make.height.equalTo(34)
        }
        
        addToCartButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }

    private func createSizeButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor(named: "Black"), for: .normal)
        button.backgroundColor = UIColor(named: "Gray")
        button.layer.cornerRadius = 17
        button.contentEdgeInsets = UIEdgeInsets(top: 8.5, left: 18, bottom: 8.5, right: 18)
        button.snp.makeConstraints { make in
            make.height.equalTo(34)
        }
        button.addTarget(self, action: #selector(sizeSelected(_:)), for: .touchUpInside)
        return button
    }
    
    // MARK: - Actions
    @objc private func sizeSelected(_ sender: UIButton) {
        sizesStackView.arrangedSubviews.forEach {
            ($0 as? UIButton)?.backgroundColor = UIColor(named: "Gray")
            ($0 as? UIButton)?.setTitleColor(UIColor(named: "Black"), for: .normal)
        }
        sender.backgroundColor = UIColor(named: "ExtraDark")
        sender.setTitleColor(.white, for: .normal)
        selectedSize = sender.titleLabel?.text
    }
    
    @objc private func showProductSpecs() {
        let specsVC = UIViewController()
        specsVC.view.backgroundColor = .white
        
        let navController = UINavigationController(rootViewController: specsVC)
        navController.modalPresentationStyle = .pageSheet
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close,
                                        target: self,
                                        action: #selector(dismissSpecsVC))
        specsVC.navigationItem.rightBarButtonItem = closeButton
        
        let textView = UITextView()
        textView.text = productSpecs.isEmpty ? "Характеристики отсутствуют" : productSpecs
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isEditable = false
        textView.isScrollEnabled = true
        specsVC.view.addSubview(textView)
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(specsVC.view.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(specsVC.view.safeAreaLayoutGuide).offset(-16)
        }
        
        present(navController, animated: true)
    }

    @objc private func dismissSpecsVC() {
        dismiss(animated: true)
    }
    
    @objc private func addToCartTapped() {
        guard let size = selectedSize else {
            showSizeSelectionAlert()
            return
        }
        
        let alert = UIAlertController(
            title: "",
            message: "\(productName) (размер: \(size)) теперь в корзине",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Продолжить покупки", style: .default))
        alert.addAction(UIAlertAction(title: "Перейти в корзину", style: .default) { _ in
            self.navigateToCart()
        })
        
        alert.view.tintColor = UIColor(named: "Dark")
        present(alert, animated: true)
    }
    
    private func showSizeSelectionAlert() {
        let alert = UIAlertController(
            title: "Выберите размер",
            message: "Сначала выберите размер товара",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        alert.view.tintColor = UIColor(named: "Dark")
        present(alert, animated: true)
    }
    
    func navigateToCart() {
        print("Переход в корзину")
    }
}

extension ProductDetailViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
