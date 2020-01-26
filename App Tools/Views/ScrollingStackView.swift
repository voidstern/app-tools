//
//  ScrollingStackView.swift
//  Dozzzer 4
//
//  Created by Lukas Burgstaller on 27/10/2016.
//  Copyright © 2016 Lukas Burgstaller. All rights reserved.
//

import Foundation
import UIKit

public class ScrollingStackView: UIScrollView {

    public var arrangedViews: [UIView] = [] {
        didSet { layoutSubviews() }
    }

    public var spacing: CGFloat = 10 {
        didSet { layoutSubviews() }
    }
    public var stackInset: UIEdgeInsets = UIEdgeInsets.zero {
        didSet { layoutSubviews() }
    }

    public var colums: [UIView: Int] = [:] {
        didSet { layoutSubviews() }
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public func addArrangedSubview(view: UIView, column: Int = 0) {
        arrangedViews.append(view)
        colums[view] = column
        addSubview(view)
    }
    
    public func removeArrangedSubview(view: UIView) {
        view.removeFromSuperview()
        arrangedViews.remove(view)
    }

    @discardableResult public func removeAllArrangedSubviews() -> [UIView] {
        let views = arrangedViews

        arrangedViews.forEach { (view) in
            view.removeFromSuperview()
        }

        arrangedViews.removeAll()

        return views
    }

    // Calculate Height

    func updateContentSize() {
        var height: CGFloat = 0
        for column in 0...(colums.values.reduce(0, { return max($0, $1)}) + 1) {
            let columnHeight = neededHeight(forViews: arrangedViews.filter({ self.colums[$0] == column }))
            height = max(height, columnHeight)
        }

        contentSize = CGSize(width: frame.width, height: height + stackInset.top + stackInset.bottom)
    }

    func neededHeight(forViews: [UIView]) -> CGFloat {
        var neededHeight = forViews
            .filter{ return !$0.isHidden && $0.alpha > 0 }
            .reduce(0) { return $0 + $1.intrinsicContentSize.height }

        if forViews.count > 0 {
            neededHeight += (spacing * CGFloat(arrangedViews.count - 1))
        }

        return neededHeight + stackInset.top + stackInset.bottom
    }

    // Layout Views

    override public func layoutSubviews() {
        updateContentSize()
        super.layoutSubviews()

        for column in 0...colums.values.reduce(0, { return max($0, $1)}) {
            layout(views: arrangedViews.filter({ self.colums[$0] == column }), forColumn: column)
        }
    }

    func layout(views: [UIView], forColumn: Int) {

        let numberOfColumns: Int = colums.values.reduce(0, { return max($0, $1)}) + 1
        let x = ((frame.width / numberOfColumns.cgFloat) * forColumn.cgFloat) + stackInset.left
        let width = (frame.width / numberOfColumns.cgFloat) - stackInset.left - stackInset.right

        var y = stackInset.top
        for view in views {
            if !view.isHidden && view.alpha > 0 {
                let height = view.intrinsicContentSize.height
                view.frame = CGRect(x: x, y: y, width: width, height: height)
                y += height
                y += spacing
            } else {
                view.frame = CGRect(x: stackInset.left, y: y, width: width, height: 0)
            }
        }
    }
}
