//
//  GitPRViewModel.swift
//  MyGitHub
//
//  Created by Vaibhav Singh on 06/08/22.
//

import Foundation
import UIKit

protocol GitPRViewModelDelegate: AnyObject {
    func loadUserData()
    func showLoadingIndicator()
    func removeLoadingIndicator()
    func showErrorView(with error: APIError)
    func removeErrorView()
    func reloadCollectionView()
}

final class GitPRViewModel: NSObject {
    // weak vars
    weak var delegate: GitPRViewModelDelegate?

    // public vars
    var userName: String? = nil
    var gitUserModel: GitUserModel? = nil
    var collectionView: UICollectionView?

    // private vars
    private var cellViewModels: [GitPRCellViewModel] = []
    private var prDetailModel: [GitPRModel] = []
    private var numberOfItems: Int {
        return  cellViewModels.count
    }
    private let networkClient: GitPRAPIClient

    func cellViewModel(at index: Int) -> GitPRCellViewModel? {
        guard cellViewModels.indices.contains(index) else {
            return nil
        }
        return cellViewModels[index]
    }

    override init() {
        networkClient = GitPRAPIClient()
        super.init()
        fetchFirstPage()
        fetchUser()
    }
}

// MARK: Networking
extension GitPRViewModel {
    func fetchFirstPage(showLoadingIndicator: Bool = true) {
        if showLoadingIndicator {
            delegate?.showLoadingIndicator()
        }
        delegate?.removeErrorView()
        networkClient.fetchPRs(state: .closed) { [weak self] (result) in
            if showLoadingIndicator {
                self?.delegate?.removeLoadingIndicator()
            }

            switch result {
            case.failure(_):
                self?.delegate?.showErrorView(with: .requestFailed)
                return
            case .success(let items):
                if(!items.isEmpty) {
                    self?.networkClient.hasNextPage = false
                    self?.delegate?.showErrorView(with: .noData)
                    return 
                }
                self?.networkClient.pageToFetch += 1

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

    private func fetchNextPage() {
        networkClient.fetchPRs(state: .closed) { [weak self] (result) in
            switch result {
            case.failure(_):
                self?.delegate?.reloadCollectionView()
                return
            case .success(let items):
                if(items.isEmpty) { self?.networkClient.hasNextPage = false }
                self?.networkClient.pageToFetch += 1

                self?.prDetailModel.append(contentsOf: items)
                for item in items {
                    let cvm = GitPRCellViewModel(item: item)
                    self?.cellViewModels.append(cvm)
                }
                self?.delegate?.reloadCollectionView()
                self?.collectionView?.reloadData()
            }
        }
    }

    private func fetchUser() {
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
        networkClient.pageToFetch = 1
        fetchFirstPage(showLoadingIndicator: false)
    }
}

// MARK: CollectionView
extension GitPRViewModel {
    func configure(collectionView: UICollectionView) {
        let layout = collectionView.collectionViewLayout as? GitPRCollectionViewFlowLayout
        layout?.scrollDirection = .vertical
        layout?.minimumInteritemSpacing = 15
        collectionView.register(GitPRCell.self, forCellWithReuseIdentifier: GitPRCell.identifier)

        layout?.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 150)
        collectionView.prefetchDataSource = self
        collectionView.isPrefetchingEnabled = true
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
        let cell: GitPRCell = collectionView.dequeueReusableCell(withReuseIdentifier: GitPRCell.identifier, for: indexPath) as! GitPRCell
        cellViewModel.configure(cell: cell)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension GitPRViewModel: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    /// commenting this as dynamic cell sizes arent supported with prefetchDataSource.
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        var cellHeight: CGFloat = 150;
//        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GitPRCell.identifier, for: indexPath as IndexPath) as? GitPRCell {
//            cellHeight = cell.cellHeight()
//        }
//        return CGSize(width: UIScreen.main.bounds.width , height: cellHeight)
//    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension GitPRViewModel: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard indexPaths.contains(where: { $0.item == numberOfItems - 1 }) else { return }
        fetchNextPage()
    }
}
