import UIKit
import SnapKit

class ProductCell: UICollectionViewCell {
    static let reuseID = "ProductCell"

    private let productImageView = UIImageView()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let priceButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(productImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(priceButton)

        productImageView.contentMode = .scaleAspectFit
        productImageView.clipsToBounds = true
        productImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width / 3)
        }

        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.numberOfLines = 1
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalTo(productImageView.snp.trailing).offset(11)
            make.trailing.equalToSuperview().offset(-11)
        }

        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 3
        descriptionLabel.textColor = .gray
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.equalTo(productImageView.snp.trailing).offset(11)
            make.trailing.equalToSuperview().offset(-11)
        }

        priceButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        priceButton.setTitleColor(UIColor(named: "MediumDark"), for: .normal)
        priceButton.backgroundColor = UIColor(named: "Light")
        priceButton.layer.cornerRadius = 4
        priceButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.leading.equalTo(productImageView.snp.trailing).offset(11)
            make.height.equalTo(40)
            make.width.equalTo(96)
            make.bottom.equalToSuperview().offset(-8)
        }
    }

    func configure(with product: Product) {
        nameLabel.text = product.name
        descriptionLabel.text = product.description
        let priceFormatted = String(format: "%.0f", product.price)
        priceButton.setTitle("\(priceFormatted) ₽", for: .normal)
        productImageView.image = UIImage(named: product.imageName)
    }
}
