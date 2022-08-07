//
//  ViewController.swift
//  MyGitHub
//
//  Created by Vaibhav Singh on 06/08/22.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
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

    lazy var labelStackView: UIStackView = {
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
        c.backgroundColor = .tertiarySystemBackground
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
        super.init(nibName: String(describing: ViewController.self), bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        self.viewModel = GitPRViewModel()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "GitHub Pull Requests"
        //        contentView.addSubview(userTitle)
        viewModel.delegate = self

        contentView.addSubview(userImageView)
        contentView.addSubview(labelStackView)
        labelStackView.addArrangedSubview(userTitle)
        labelStackView.addArrangedSubview(companyTitle)
        labelStackView.addArrangedSubview(locationLabel)

        self.view.addSubview(contentView)
        addCollectionView()

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
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])

        viewModel.configure(collectionView: collectionView)
    }
    private func addCollectionView() {
        //Add some extra bottom spacing
        collectionView.contentInset.bottom = 15
        //        refreshControl = UIRefreshControl()
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

    @objc
    func handlePullToRefresh() {
        viewModel.handlePullToRefresh()
    }
}

extension ViewController: GitPRViewModelDelegate {
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
        activityIndicatorView.fillIn(container: collectionView)
    }

    func removeLoadingIndicator() {
        activityIndicatorView.removeFromSuperview()
    }

    func showErrorView(with error: APIError) {
        if errorView == nil {
            let e = ErrorView()
            e.setErrorMessage(error: error)
//            e.addRetryAction { [weak self] in
//                self?.viewModel.loadData()
//            }
            errorView = e
        }
//        removeLoading()
//        hideContent()
//        let state = ErrorUIState(from: error)
//        errorView?.render(with: state)
        errorView?.fillIn(container: collectionView)
    }

    func removeErrorView() {
        errorView?.removeFromSuperview()
    }

    func reloadCollectionView() {
        collectionView.reloadData()
        refreshControl.endRefreshing()
    }
}
