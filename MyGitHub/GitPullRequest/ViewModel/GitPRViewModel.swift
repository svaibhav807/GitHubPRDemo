//
//  GitPRViewModel.swift
//  MyGitHub
//
//  Created by Vaibhav Singh on 06/08/22.
//

import Foundation
import UIKit
import Alamofire

protocol GitPRViewModelDelegate: AnyObject {
    func loadUserData()
    func showLoadingIndicator()
    func removeLoadingIndicator()
    func showErrorView(with error: APIError)
    func removeErrorView()
    func reloadCollectionView()
}

final class GitPRViewModel: NSObject {
    // weak
    weak var delegate: GitPRViewModelDelegate?

    var userName: String? = nil
    var gitUserModel: GitUserModel? = nil
    var collectionView: UICollectionView?

    // private
    private var cellViewModels: [GitPRCellViewModel] = []
    private var prDetailModel: [GitPRModel] = []
    private let networkClient: GitPRAPIClient
    private var numberOfItems: Int {
        return  cellViewModels.count
    }

    func cellViewModel(at index: Int) -> GitPRCellViewModel? {
        guard cellViewModels.indices.contains(index) else {
            return nil
        }
        return cellViewModels[index]
    }

    override init() {
        networkClient = GitPRAPIClient()
        super.init()
        fetchPRs()
        fetchUser()
    }
}

// MARK: Networking
extension GitPRViewModel {
    func fetchPRs(showLoadingIndicator: Bool = true) {
        if showLoadingIndicator {
            delegate?.showLoadingIndicator()
        }
        networkClient.fetchPRs(state: .closed) { [weak self] (result) in
            if showLoadingIndicator {
                self?.delegate?.removeLoadingIndicator()
            }

            switch result {
            case.failure(_):
                self?.delegate?.showErrorView(with: .requestFailed)
                self?.delegate?.reloadCollectionView()
                return
            case .success(let items):
                self?.prDetailModel.append(contentsOf: items)
                self?.cellViewModels = []
                for item in items {
                    let cvm = GitPRCellViewModel(item: item)
                    self?.cellViewModels.append(cvm)
                }
                self?.delegate?.reloadCollectionView()
                self?.collectionView?.reloadData()
            }
        }
    }

    func fetchUser() {
        networkClient.fetchUser() {  [weak self] (result) in
            switch result {
            case .success(let model):
                self?.gitUserModel = model
                self?.delegate?.loadUserData()
            case .failure(_):
                print("Profle API failed.")
            }
        }
    }

    func handlePullToRefresh() {
        prDetailModel = []
        fetchPRs(showLoadingIndicator: false)
    }
}

// MARK: CollectionView
extension GitPRViewModel {
    func configure(collectionView: UICollectionView) {
        let layout = collectionView.collectionViewLayout as? GitPRCollectionViewFlowLayout
        layout?.scrollDirection = .vertical
        layout?.minimumInteritemSpacing = 15
        //        layout?.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
        layout?.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)

        collectionView.dataSource = self
        collectionView.delegate = self
        self.collectionView = collectionView
    }
}

// MARK: UICollectionViewDataSource
extension GitPRViewModel: UICollectionViewDataSource  {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellViewModel = cellViewModel(at: indexPath.row) else {
            fatalError("Unknown index passed")
        }
        let cell: CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        cellViewModel.configure(cell: cell)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension GitPRViewModel: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var labelHeight: CGFloat = 0;
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath as IndexPath) as? CollectionViewCell {
            labelHeight = cell.cellHeight()
        }
        return CGSize(width: UIScreen.main.bounds.width , height: labelHeight)
    }
}
