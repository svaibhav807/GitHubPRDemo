//
//  GitPRViewController.swift
//  MyGitHub
//
//  Created by Vaibhav Singh on 06/08/22.
//

import UIKit
import Kingfisher

class GitPRViewController: UIViewController {
    private var viewModel: GitPRViewModel
    private var errorView: ErrorView?

    private lazy var userTitle: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.font = .systemFont(ofSize: 25, weight: .semibold)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private lazy var locationLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.font = .systemFont(ofSize: 16, weight: .semibold)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private lazy var companyTitle: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.font = .systemFont(ofSize: 16, weight: .semibold)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private lazy var labelStackView: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.translatesAutoresizingMaskIntoConstraints = false
        s.alignment = .fill
        s.spacing = 5
        return s
    }()

    private var contentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .systemBackground
        v.layer.cornerRadius = 7
        return v
    }()

    private var userImageView: UIImageView = {
        let i = UIImageView()
        i.heightAnchor.constraint(equalTo: i.widthAnchor).isActive = true
        i.contentMode = .scaleAspectFill
        i.clipsToBounds = true
        i.translatesAutoresizingMaskIntoConstraints = false
        return i
    }()

    private lazy var collectionView: UICollectionView = {
        let l = GitPRCollectionViewFlowLayout()
        let c = UICollectionView(frame: .zero, collectionViewLayout: l)
        c.backgroundColor = .systemBackground
        c.layer.cornerRadius = 5
        c.translatesAutoresizingMaskIntoConstraints = false
        return c
    }()

    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let l = UIActivityIndicatorView(style: .medium)
        return l
    }()

    private let refreshControl = UIRefreshControl()

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
    }

    init() {
        self.viewModel = GitPRViewModel()
        super.init(nibName: String(describing: GitPRViewController.self), bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        self.viewModel = GitPRViewModel()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "GitHub Pull Requests"

        addContentView()
        addCollectionView()
        showLoadingIndicator()

        viewModel.delegate = self
        viewModel.configure(collectionView: collectionView)
    }

    private func addContentView() {
        contentView.addSubview(userImageView)
        contentView.addSubview(labelStackView)
        labelStackView.addArrangedSubview(userTitle)
        labelStackView.addArrangedSubview(companyTitle)
        labelStackView.addArrangedSubview(locationLabel)
        self.view.addSubview(contentView)

        NSLayoutConstraint.activate([
            labelStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            labelStackView.bottomAnchor.constraint(equalTo:  contentView.bottomAnchor),
            labelStackView.topAnchor.constraint(equalTo:  contentView.topAnchor),
            userImageView.leftAnchor.constraint(equalTo:  labelStackView.rightAnchor, constant: 10),
            userImageView.rightAnchor.constraint(equalTo:  contentView.rightAnchor, constant: -25),
            userImageView.bottomAnchor.constraint(equalTo:  contentView.bottomAnchor, constant: -5),
            userImageView.topAnchor.constraint(equalTo:  contentView.topAnchor, constant: 5),
            contentView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 100),
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
        ])
    }

    private func addCollectionView() {
        //Add some extra bottom spacing
        collectionView.contentInset.bottom = 15
        refreshControl.tintColor = .label
        refreshControl.addTarget(self, action: #selector(handlePullToRefresh), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
        
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 30)
        ])
    }
}

// MARK: GitPRViewModelDelegate
extension GitPRViewController: GitPRViewModelDelegate {
    func loadUserData() {
        if let user = viewModel.gitUserModel  {
            let url = URL(string: user.imageURL )
            userImageView.kf.setImage(with: url)
            userImageView.layer.cornerRadius = userImageView.frame.size.width/2
            self.userTitle.text = user.name

            if let location = user.location {
                self.locationLabel.text = location
                self.locationLabel.isHidden = false
            } else {
                self.locationLabel.isHidden = true
            }

            if let company = user.company {
                self.companyTitle.text = company
                self.companyTitle.isHidden = false
            } else {
                self.companyTitle.isHidden = true
            }
        } else {
            contentView.isHidden = true
        }
    }

    func showLoadingIndicator() {
        activityIndicatorView.startAnimating()
        activityIndicatorView.fillIn(container: self.view)
    }

    func removeLoadingIndicator() {
        activityIndicatorView.removeFromSuperview()
    }

    func showErrorView(with error: APIError) {
        hideContent()
        if errorView == nil {
            let e = ErrorView()
            e.setErrorMessage(error: error)
            e.retryButton.addTarget(self, action: #selector(errorViewRetryPressed(_:)), for: .touchUpInside)
            errorView = e
        }
        errorView?.fillIn(container: self.view)
    }

    func removeErrorView() {
        errorView?.removeFromSuperview()
    }

    func reloadCollectionView() {
        collectionView.reloadData()
        refreshControl.endRefreshing()
    }
}

extension GitPRViewController {
    @objc
    func handlePullToRefresh() {
        viewModel.handlePullToRefresh()
    }

    @objc
    func errorViewRetryPressed(_ sender: UIButton) {
        showContent()
        errorView?.removeFromSuperview()
        viewModel.fetchFirstPage()
    }

    private func showContent() {
        collectionView.isHidden = false
        contentView.isHidden = false
    }

    private func hideContent() {
        collectionView.isHidden = true
        contentView.isHidden = true
    }
}
