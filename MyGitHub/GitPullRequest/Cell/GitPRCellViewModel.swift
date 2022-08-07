//
//  GitPRCellViewModel.swift
//  MyGitHub
//
//  Created by Vaibhav Singh on 06/08/22.
//

import Foundation


final class GitPRCellViewModel {
    private let item: GitPRModel
    private let title: String
    private let createdDate: String
    private let closedDate: String?
    private lazy var dateFormatter = GitFormatters.Dates()

    init(item: GitPRModel) {
        self.item = item
        self.title = item.title
        self.createdDate = item.createdDate
        self.closedDate = item.closedDate
    }

    func configure(cell: GitPRCell) {
        cell.titleLabel.text = title
        if let createdDateString = dateFormatter.string(from: createdDate) {
            cell.createdOnLabel.text = (cell.createdOnLabel.text ?? "") + "\n" + createdDateString
            cell.createdOnLabel.isHidden = false
        } else {
            cell.createdOnLabel.isHidden = true
        }
        if let closedDate = item.closedDate {
            if let closedDateString = dateFormatter.string(from: closedDate)  {
                cell.closedOnLabel.isHidden = false
                cell.closedOnLabel.text = (cell.closedOnLabel.text ?? "") + "\n" + closedDateString
            }

        } else {
            cell.closedOnLabel.isHidden = true
        }
    }
}
