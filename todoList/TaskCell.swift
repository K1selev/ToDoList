//
//  TaskCell.swift
//  todoList
//
//  Created by Сергей Киселев on 29.01.2025.
//

import UIKit

class TaskCell: UITableViewCell {
    
    private let checkmarkView = UIView()
    private let checkmarkLabel = UILabel()
    private let titleLabel = UILabel()
    
    var onCheckmarkTap: (() -> Void)?
    var onLongPress: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress))
        self.addGestureRecognizer(longPressGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .black
        selectionStyle = .none
        
        checkmarkView.layer.cornerRadius = 15
        checkmarkView.layer.borderWidth = 2
        checkmarkView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(checkmarkView)
        
        checkmarkLabel.textColor = .yellow
        checkmarkLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        checkmarkLabel.textAlignment = .center
        checkmarkLabel.translatesAutoresizingMaskIntoConstraints = false
        checkmarkView.addSubview(checkmarkLabel)
        
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            checkmarkView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            checkmarkView.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkmarkView.widthAnchor.constraint(equalToConstant: 30),
            checkmarkView.heightAnchor.constraint(equalToConstant: 30),
            
            checkmarkLabel.centerXAnchor.constraint(equalTo: checkmarkView.centerXAnchor),
            checkmarkLabel.centerYAnchor.constraint(equalTo: checkmarkView.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: checkmarkView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        checkmarkView.isUserInteractionEnabled = true
    }
    
    @objc private func didLongPress() {
        onLongPress?()
    }

    func configure(with taskEntity: TaskEntity) {
        titleLabel.attributedText = nil
        guard let title = taskEntity.title else { return }
        
        let isCompleted = taskEntity.isCompleted
        
        if isCompleted {
            checkmarkView.layer.borderColor = UIColor.yellow.cgColor
            checkmarkView.backgroundColor = .clear
            checkmarkLabel.text = "✓"
            checkmarkLabel.textColor = .yellow

            titleLabel.textColor = .gray
            let attributeString = NSMutableAttributedString(string: title)
            attributeString.addAttribute(.strikethroughStyle,
                                         value: NSUnderlineStyle.single.rawValue,
                                         range: NSRange(location: 0, length: title.count))
            titleLabel.attributedText = attributeString
        } else {
            checkmarkView.layer.borderColor = UIColor.gray.cgColor
            checkmarkView.backgroundColor = .clear
            checkmarkLabel.text = ""
            titleLabel.text = title
            titleLabel.textColor = .white
        }
    }
}
