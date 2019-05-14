//
//  IBADesignableViews.swift
//  Elite
//
//  Created by Manny Yusuf on 4/3/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

@IBDesignable
class CircularButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.contentMode = .scaleAspectFill
        layer.cornerRadius = bounds.width / 2.0
        //layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        layer.borderWidth = 5
        clipsToBounds = true
    }
}

@IBDesignable
class RoundedButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.contentMode = .scaleAspectFill
        layer.cornerRadius = 5
        clipsToBounds = true
    }
}

@IBDesignable
class CircularImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        contentMode = .scaleAspectFill
        layer.cornerRadius = bounds.width / 2.0
        // layer.borderColor = UIColor.lightGray.cgColor
        //layer.borderWidth = 5
        backgroundColor = .clear
        clipsToBounds = true
    }
}
@IBDesignable
class CircularRedImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        contentMode = .scaleAspectFill
        layer.cornerRadius = bounds.width / 2.0
        layer.borderColor = #colorLiteral(red: 0.995932281, green: 0.2765177786, blue: 0.3620784283, alpha: 1)
        layer.borderWidth = 5
        backgroundColor = .clear
        clipsToBounds = true
    }
}

@IBDesignable
class versusRight: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let corners = UIRectCorner(arrayLiteral: .topRight, .bottomRight)
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: 50, height: 50))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
@IBDesignable
class versusLeft: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let corners = UIRectCorner(arrayLiteral: .topLeft, .bottomLeft)
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: 50, height: 50))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

@IBDesignable
class topSemiCircle: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let corners = UIRectCorner(arrayLiteral: .topLeft, .topRight)
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: 150, height: 150))
        let mask = CAShapeLayer()
        layer.borderColor = #colorLiteral(red: 0.9725490196, green: 0.6078431373, blue: 0.1450980392, alpha: 1)
        layer.borderWidth = 3
        mask.path = path.cgPath
        layer.mask?.borderWidth = 3
        layer.mask = mask

    }
}
@IBDesignable
class CircularBlueImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        contentMode = .scaleAspectFill
        layer.cornerRadius = bounds.width / 2.0
        layer.borderColor = #colorLiteral(red: 0.2274509804, green: 0.4392156863, blue: 0.6549019608, alpha: 1)
        layer.borderWidth = 5
        backgroundColor = .clear
        clipsToBounds = true
    }
}

@IBDesignable
class CircularBlueButton: UIButton{
    override func layoutSubviews() {
        super.layoutSubviews()
        contentMode = .scaleAspectFill
        layer.cornerRadius = bounds.width / 2.0
        layer.borderColor = #colorLiteral(red: 0.2274509804, green: 0.4392156863, blue: 0.6549019608, alpha: 1)
        layer.borderWidth = 5
        backgroundColor = .clear
        clipsToBounds = true
    }
}

@IBDesignable
class CircularRedButton: UIButton{
    override func layoutSubviews() {
        super.layoutSubviews()
        contentMode = .scaleAspectFill
        layer.cornerRadius = bounds.width / 2.0
        layer.borderColor = #colorLiteral(red: 0.995932281, green: 0.2765177786, blue: 0.3620784283, alpha: 1)
        layer.borderWidth = 5
        backgroundColor = .clear
        clipsToBounds = true
    }
}
@IBDesignable
class CornerImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        contentMode = .scaleAspectFill
        layer.cornerRadius = 12.0
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        clipsToBounds = true
    }
}

@IBDesignable
class CircularViewBlue: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        contentMode = .scaleAspectFill
        layer.cornerRadius = bounds.width / 2.0
        layer.borderColor = #colorLiteral(red: 0.2274509804, green: 0.4392156863, blue: 0.6549019608, alpha: 1)
        layer.borderWidth = 5
        backgroundColor = .clear
        clipsToBounds = true
    }
}

@IBDesignable
class CircularViewRed: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        contentMode = .scaleAspectFill
        layer.cornerRadius = bounds.width / 2.0
        layer.borderColor = #colorLiteral(red: 0.995932281, green: 0.2765177786, blue: 0.3620784283, alpha: 1)
        layer.borderWidth = 5
        backgroundColor = .clear
        clipsToBounds = true
    }
}
@IBDesignable
class CircularView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2.0
        clipsToBounds = true
    }
}


@IBDesignable
class RoundedView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 20.0
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        clipsToBounds = true
    }
}

@IBDesignable
class RankingView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let corners = UIRectCorner(arrayLiteral: .bottomRight, .bottomLeft)
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: 20, height: 20))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}




