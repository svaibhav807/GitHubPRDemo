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
    var userName: String? = nil

    private var prDetailModel: [GitPRModel] = []
    var gitUserModel: GitUserModel? = nil

    var collectionView: UICollectionView?
    private var cellViewModels: [GitPRCellViewModel] = []
    weak var delegate: GitPRViewModelDelegate?

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
        super.init()
        fetchPRs()
        fetchUser()
    }

    func fetchPRs(showLoadingIndicator: Bool = true) {
        if showLoadingIndicator {
            delegate?.showLoadingIndicator()
        }
        let completeURL = Constants.APIBaseURL + Constants.Paths.pullRequestPath
        var parameters: [String: String] = [:]
        parameters["state"] = "open"
        let request = AF.request("https://api.github.com/repos/johnsundell/ShellOut/pulls?state=closed", parameters: parameters, encoder: URLEncodedFormParameterEncoder.default) { request in

        }
        request.responseDecodable(of: [GitPRModel].self) { [weak self] (response) in
            if showLoadingIndicator {
                self?.delegate?.removeLoadingIndicator()
            }
            if let error = response.error {
                self?.delegate?.showErrorView(with: .requestFailed)
                self?.delegate?.reloadCollectionView()

                return
            }

            guard let items = response.value else { return }
            self?.prDetailModel.append(contentsOf: items)
            self?.cellViewModels = []
            //            for _ in 0...5 {
            for item in items {
                let cvm = GitPRCellViewModel(item: item)
                print(item.closedDate,"10101")
                self?.cellViewModels.append(cvm)
            }
            //            }
            self?.delegate?.reloadCollectionView()
            self?.collectionView?.reloadData()
        }
    }

    func fetchUser() {
        let completeURL = Constants.APIBaseURL + Constants.Paths.userProfilePath
        let request = AF.request(completeURL)

        request.responseDecodable(of: GitUserModel.self) { [weak self] (response) in
            guard let item = response.value else { return }
            self?.gitUserModel = item
            print(item)
            self?.delegate?.loadUserData()
        }
    }

    func handlePullToRefresh() {
        prDetailModel = []
        fetchPRs(showLoadingIndicator: false)
    }
}

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

extension GitPRViewModel: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var labelHeight: CGFloat = 0;
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath as IndexPath) as? CollectionViewCell {
            labelHeight = cell.cellHeight()
        }
        return CGSize(width: UIScreen.main.bounds.width , height: labelHeight)
    }
}
