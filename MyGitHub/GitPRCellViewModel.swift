//
//  GitPRCellViewModel.swift
//  MyGitHub
//
//  Created by Vaibhav Singh on 06/08/22.
//

import Foundation


final class GitPRCellViewModel {
    let item: GitPRModel
    let title: String
    let createdDate: String
    let closedDate: String?
    private lazy var dateFormatter = GitFormatters.Dates()

    init(item: GitPRModel) {
        self.item = item
        self.title = item.title
        self.createdDate = item.createdDate
        self.closedDate = item.closedDate
    }

    func configure(cell: CollectionViewCell) {
            cell.titleLabel.text = title
        if let createdDateString = dateFormatter.string(from: createdDate) {
        cell.createdOnLabel.text = (cell.createdOnLabel.text ?? "") + createdDateString
            cell.createdOnLabel.isHidden = false
        } else {
            cell.createdOnLabel.isHidden = true
        }
//        let closedDate = closedDate,
        if  let closedDateString = dateFormatter.string(from: createdDate) {
            cell.closedOnLabel.isHidden = false
            cell.closedOnLabel.text = (cell.closedOnLabel.text ?? "") + closedDateString
        } else {
            cell.closedOnLabel.isHidden = true
        }
    }
}
