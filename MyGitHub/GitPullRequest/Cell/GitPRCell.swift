//
//  GitPRCell.swift
//  MyGitHub
//
//  Created by Vaibhav Singh on 06/08/22.
//

import UIKit

class GitPRCell: UICollectionViewCell {
    static let identifier = "GitPRCell"

    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 15)
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    lazy var createdOnLabel: UILabel = {
        let l = UILabel()
        l.text = "Created: "
        l.font = .systemFont(ofSize: 12)
        l.numberOfLines = 0

        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    lazy var closedOnLabel: UILabel = {
        let l = UILabel()
        l.text = "Closed: "
        l.font = .systemFont(ofSize: 12)
        l.numberOfLines = 0

        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    lazy var dateStackView: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.translatesAutoresizingMaskIntoConstraints = false
        s.alignment = .fill
        s.spacing = 5
        s.widthAnchor.constraint(equalToConstant: 70).isActive = true
        return s
    }()

    lazy var contentStackView: UIStackView = {
        let s = UIStackView()
        s.axis = .horizontal
        s.translatesAutoresizingMaskIntoConstraints = false
        s.alignment = .center
        s.spacing = 10
        return s
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {
        self.backgroundColor = .secondarySystemBackground
        self.layer.cornerRadius = 5
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(dateStackView)
        dateStackView.addArrangedSubview(createdOnLabel)
        dateStackView.addArrangedSubview(closedOnLabel)
        self.addSubview(contentStackView)
        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalToConstant: 200),
            contentStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            contentStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            contentStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor,  constant: -10),
            contentStackView.topAnchor.constraint(equalTo: self.topAnchor,  constant: 10)
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        closedOnLabel.text = "Closed: "
        createdOnLabel.text = "Created: "
        titleLabel.text = nil
    }

    func cellHeight() -> CGFloat {
        return max(150, titleLabel.textHeight())
    }
}

extension UILabel {
    func textHeight(withWidth width: CGFloat = UIScreen.main.bounds.width) -> CGFloat {
        return self.frame.height
    }
}
