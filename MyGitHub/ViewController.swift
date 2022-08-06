//
//  ViewController.swift
//  MyGitHub
//
//  Created by Vaibhav Singh on 06/08/22.
//

import UIKit

class ViewController: UIViewController {
    private var viewModel = GitPRViewModel()
    private lazy var UserTitle: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    private lazy var collectionView: UICollectionView = {
        let l = UICollectionViewFlowLayout()
        let c = UICollectionView(frame: .zero, collectionViewLayout: l)
        c.backgroundColor = .systemBackground
        c.translatesAutoresizingMaskIntoConstraints = false
        return c
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addCollectionView()
        viewModel.configure(collectionView: collectionView)
    }
    private func addCollectionView() {
        //Add some extra bottom spacing
        collectionView.contentInset.bottom = 15

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100)
        ])
    }
}
