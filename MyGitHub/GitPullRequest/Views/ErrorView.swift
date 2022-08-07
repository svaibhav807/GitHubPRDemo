//
//  ErrorView.swift
//  MyGitHub
//
//  Created by Vaibhav Singh on 07/08/22.
//

import UIKit

class ErrorView: UIView {
    lazy var retryButton: UIButton = {
        let b = UIButton()
        b.setTitle("Retry", for: .normal)
        b.backgroundColor = .systemBlue
        let color = UIColor.white
        b.setTitleColor(color, for: .normal)
        b.layer.cornerRadius = 18
        b.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            b.widthAnchor.constraint(equalToConstant: 140),
            b.heightAnchor.constraint(equalToConstant: 36)
        ])
        return b
    }()

    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 18, weight: .semibold)
        l.textColor = .label
        l.textAlignment = .center
        l.numberOfLines = 0
        return l
    }()

    private lazy var messageLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13, weight: .medium)
        l.textColor = .label
        l.textAlignment = .center
        l.numberOfLines = 0
        return l
    }()

    private lazy var contentStack: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.alignment = .center
        s.distribution = .fill
        s.spacing = 20
        s.translatesAutoresizingMaskIntoConstraints = false
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

    private func commonInit() {
        self.backgroundColor = .systemBackground
        self.addSubview(contentStack)
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(messageLabel)
        contentStack.addArrangedSubview(retryButton)
        let guide = self.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            contentStack.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
            contentStack.topAnchor.constraint(greaterThanOrEqualTo: guide.topAnchor, constant: 50),
            contentStack.leadingAnchor.constraint(lessThanOrEqualTo: guide.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(lessThanOrEqualTo: guide.trailingAnchor, constant: -20)
        ])
    }

    func setErrorMessage(error: APIError) {
        titleLabel.text = "Uh oh!"
        messageLabel.text = error.description
    }
}
