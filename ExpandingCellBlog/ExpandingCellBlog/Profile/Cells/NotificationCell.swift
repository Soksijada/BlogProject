//
//  NotificationCell.swift
//  ExpandingCellBlog
//
//  Created by Krešimir Baković on 30/11/2020.
//

import UIKit

struct NotificationCellViewModel {
    let titleText: String
    var isEnabled: Bool
}

class NotificationCell: UITableViewCell {
    lazy var checkBoxImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        
        return label
    }()
    
    private var viewModel: NotificationCellViewModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        backgroundColor = .white
        selectionStyle = .none
        addSubviews()
        setConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addSubviews() {
        contentView.addSubview(checkBoxImageView)
        contentView.addSubview(titleLabel)
    }

    func setConstraints() {
        checkBoxImageView.snp.remakeConstraints {
            $0.leading.equalToSuperview().offset(25)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(20)
        }
        
        titleLabel.snp.remakeConstraints {
            $0.leading.equalTo(checkBoxImageView.snp.trailing).offset(6)
            $0.top.bottom.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }

    func update(viewModel: NotificationCellViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.titleText
        let image: UIImage? = viewModel.isEnabled ? AppAssets.circleSelected.image : AppAssets.circleDeselected.image
        checkBoxImageView.image = image
    }
    
    func toggleSelection() {
        viewModel?.isEnabled.toggle()
        let image: UIImage? = viewModel?.isEnabled ?? true ? AppAssets.circleSelected.image : AppAssets.circleDeselected.image
        checkBoxImageView.image = image
    }
}
