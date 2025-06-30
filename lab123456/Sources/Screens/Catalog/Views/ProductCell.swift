import UIKit
import SnapKit
import Kingfisher

final class ProductCell: UICollectionViewCell {
    static let reuseID = "ProductCell"
    
    // MARK: - UI Elements
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        label.textColor = .darkText
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.textColor = .gray
        return label
    }()
    
    private let priceButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 6
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        return button
    }()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    func configure(with product: Product) {
        titleLabel.text = product.title
        descriptionLabel.text = product.description
        
        let priceFormatted = String(format: "%.2f", product.price)
        priceButton.setTitle("\(priceFormatted) ₽", for: .normal)
        
        if let imageUrl = product.image {
            productImageView.kf.setImage(
                with: imageUrl,
                options: [
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]
            )
        }
        else {productImageView.image = UIImage(named: "placeholder")}
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.kf.cancelDownloadTask()
        productImageView.image = nil
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        
        [productImageView, titleLabel, descriptionLabel, priceButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        productImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(12)
            make.width.height.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalTo(productImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        priceButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel)
            make.height.equalTo(32)
            make.bottom.lessThanOrEqualToSuperview().offset(-12)
        }
    }
}
