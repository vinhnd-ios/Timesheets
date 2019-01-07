//
//  TimesheetsHeaderView.swift
//  Timesheets
//
//  Created by VINHND on 1/5/19.
//  Copyright © 2019 VINHND. All rights reserved.
//

import UIKit

@objc protocol TimesheetsHeaderViewDelegate {
    func timesheetsHeaderViewDidChangeDateToPast(_ timesheetsHeaderView: TimesheetsHeaderView)
    func timesheetsHeaderViewDidChangeDateToFutute(_ timesheetsHeaderView: TimesheetsHeaderView)
    func timesheetsHeaderViewDidTapTitle(_ timesheetsHeaderView: TimesheetsHeaderView)
}

class TimesheetsHeaderView: UIView {
    weak var delegate: TimesheetsHeaderViewDelegate?
    
    public lazy var previousButton: UIButton = { [weak self] in
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(previousHandler), for: .touchUpInside)
        return button
    }()
    
    public lazy var nextButton: UIButton = { [weak self] in
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "next"), for: .normal)
        button.addTarget(self, action: #selector(nextHandler), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 19)
        
        return label
    }()
    
    private lazy var buttonTitle: UIButton = { [weak self] in
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self?.didTapTitle), for: .touchUpInside)
        return button
    }()
    
    @objc private func previousHandler() {
        delegate?.timesheetsHeaderViewDidChangeDateToPast(self)
    }
    
    @objc private func nextHandler() {
        delegate?.timesheetsHeaderViewDidChangeDateToFutute(self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(previousButton)
        addSubview(nextButton)
        addSubview(titleLabel)
        addSubview(buttonTitle)
        
        //add contraints
        NSLayoutConstraint.activate([
            previousButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            previousButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            previousButton.widthAnchor.constraint(equalToConstant: 25.5),
            previousButton.heightAnchor.constraint(equalToConstant: 44),
            
            titleLabel.leftAnchor.constraint(equalTo: previousButton.rightAnchor, constant: 30),
            titleLabel.rightAnchor.constraint(equalTo: nextButton.leftAnchor, constant: -30),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            buttonTitle.leftAnchor.constraint(equalTo: previousButton.rightAnchor, constant: 30),
            buttonTitle.rightAnchor.constraint(equalTo: nextButton.leftAnchor, constant: -30),
            buttonTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            nextButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nextButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            nextButton.widthAnchor.constraint(equalToConstant: 25.5),
            nextButton.heightAnchor.constraint(equalToConstant: 44)
            ])
    }
    
    @objc private func didTapTitle() {
        self.delegate?.timesheetsHeaderViewDidTapTitle(self)
    }
    
    public func updateTitleLbl(_ attribute: NSAttributedString) {
        titleLabel.attributedText = attribute
    }
    
    func enablePreviousButton(_ isEnable: Bool) {
        previousButton.isEnabled = isEnable
    }
}
