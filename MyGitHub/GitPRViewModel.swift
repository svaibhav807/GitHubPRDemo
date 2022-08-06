//
//  GitPRViewModel.swift
//  MyGitHub
//
//  Created by Vaibhav Singh on 06/08/22.
//

import Foundation
import UIKit
import Alamofire

final class GitPRViewModel: NSObject {
    var prDetailModel: [GitPRModel] = []
    var collectionView: UICollectionView?
    private var cellViewModels: [GitPRCellViewModel] = []


    var numberOfItems: Int {
        return  cellViewModels.count
    }

    func cellViewModel(at index: Int) -> GitPRCellViewModel? {
        guard cellViewModels.indices.contains(index) else {
            return nil
        }
        return cellViewModels[index]
    }

//    let networkHandler: NetworkClien
    override init() {
        super.init()
//        prDetailModel = nil
//        self.networkHandler = NetworkHandler()

//        networkHandler.fetch(urlRequest:, completion: )

        fetchFilms()

    }

    func fetchFilms() {
        let request = AF.request("https://api.github.com/repos/svaibhav807/Socialize/pulls")

        print("sdc")
            request.responseDecodable(of: [GitPRModel].self) { [weak self] (response) in
              guard let items = response.value else { return }
                self?.prDetailModel.append(contentsOf: items)
                for _ in 0...30 {

                    for item in items {
                        let item1 = item
                        item1.title = "sameplaijsbdfuchavfdukgcvakusdvckuavsdhjkgcvkausdvcgvashkdvchkasvdcghvaskdhbcahjksdvc"
                        let cvm = GitPRCellViewModel(item: item1)
                        self?.cellViewModels.append(cvm)
                    }
                    self?.collectionView?.reloadData()
                }
            }
    }
}


extension GitPRViewModel {
    func configure(collectionView: UICollectionView) {
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = .vertical
        layout?.minimumInteritemSpacing = 15
        layout?.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 72)

        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)

        collectionView.dataSource = self
//        collectionView.delegate = self
        self.collectionView = collectionView
    }

}

extension GitPRViewModel: UICollectionViewDataSource {
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
