//
//  Header.swift
//  ParallaxScrollView
//
//  Created by Felix Hedlund on 2018-11-08.
//  Copyright © 2018 Jayway AB. All rights reserved.
//

import UIKit

class Header: UIView, ParallaxHeaderViewType {
    var view: UIView {
        return self
    }

    private lazy var backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "pattern")
        view.contentMode = .scaleAspectFill
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return view
    }()

    private lazy var centerImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "apple")
        view.contentMode = .scaleAspectFit
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
        setupLayout()
    }

    private func loadView(){
        addSubview(backgroundImageView)
        addSubview(centerImageView)
    }

    private func setupLayout(){
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ])

        let appleHeight: CGFloat = 100
        centerImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            centerImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            centerImageView.widthAnchor.constraint(equalTo: centerImageView.heightAnchor),
            centerImageView.heightAnchor.constraint(equalToConstant: appleHeight),
            ])
    }

    func configureWithInitialHeightReference(heightReferenceView: UIView) {
//        let heightConstraint = centerImageView.topAnchor.constraint(equalTo: heightReferenceView.topAnchor, constant: 0.8)
//        heightConstraint.priority = .defaultHigh
//        NSLayoutConstraint.activate([
//            heightConstraint
//            ])
    }

}
