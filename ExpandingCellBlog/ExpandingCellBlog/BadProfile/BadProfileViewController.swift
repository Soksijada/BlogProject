//
//  BadProfileViewController.swift
//  ExpandingCellBlog
//
//  Created by Krešimir Baković on 01/12/2020.
//

import UIKit
import RxSwift

class BadProfileViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: BadProfileViewModel
    
    // MARK: - Views
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .white
        tableView.register(PersonalCell.self, forCellReuseIdentifier: PersonalCell.identity)
        tableView.register(PayMethodCell.self, forCellReuseIdentifier: PayMethodCell.identity)
        tableView.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.identity)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        return tableView
    }()
    
    var dataSource = BadProfileDataSource()
    
    init(viewModel: BadProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
        setConstraints()
        observe()
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
        
    }
    
    private func setConstraints() {
        tableView.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func observe() {
        
    }
    
    private func indexPathOfHeader(header: BadProfileHeaderViewModel) -> Int {
        for (index, dataSourceHeader) in dataSource.data.enumerated() {
            if header == dataSourceHeader {
                return index
            }
        }
        return 0
    }
}

// MARK: - UITableViewDelegate

extension BadProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch dataSource.data[indexPath.section].cells[indexPath.row] {
        case.notification(let viewModel):
            let clickedCell = tableView.cellForRow(at: indexPath) as? NotificationCell
            viewModel.isEnabled.toggle()
            clickedCell?.update(viewModel: viewModel)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

// MARK: - UITableViewDataSource

extension BadProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource.data[section].isExpanded {
            return dataSource.data[section].cells.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = BadProfileHeader()
        header.delegate = self
        header.update(viewModel: dataSource.data[section])
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch dataSource.data[indexPath.section].cells[indexPath.row] {
        case .notification(let viewModel):
            let cell: NotificationCell = tableView.dequeueCellAtIndexPath(indexPath: indexPath)
            cell.update(viewModel: viewModel)
            return cell
        case .payMethod(let viewModel):
            let cell: PayMethodCell = tableView.dequeueCellAtIndexPath(indexPath: indexPath)
            cell.update(viewModel: viewModel)
            return cell
        case .personal(let viewModel):
            let cell: PersonalCell = tableView.dequeueCellAtIndexPath(indexPath: indexPath)
            cell.update(viewModel: viewModel)
            return cell
        }
    }
}

// MARK: - Views

extension BadProfileViewController: BadProfileHeaderDelegate {
    func toggleSection(header: BadProfileHeader) {
        guard let viewModel = header.viewModel else { return }
        let headerIndexPath = indexPathOfHeader(header: viewModel)
        dataSource.data[headerIndexPath].isExpanded = !dataSource.data[headerIndexPath].isExpanded
        let sections = IndexSet.init(integer: headerIndexPath)
        tableView.reloadSections(sections, with: .fade)
    }
}
