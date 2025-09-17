//
//  AboutStackTableViewCell.swift
//  CareEsteem
//
//  Created by Nitin Chauhan on 23/06/25.
//

import UIKit
import SDWebImage

class AboutStackTableViewCell: UITableViewCell {

    @IBOutlet weak var view: AGView!
    @IBOutlet weak var stack: UIStackView!
    override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }
    func setupData(
        model: [MyPopupListModel],
        imageUrl: String? = nil,
        initials: String? = nil,
        border: Bool = false
    ) {
        // 🔹 Clear old stack
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // 🔹 Top image section
        let topStack = UIStackView()
        topStack.axis = .vertical
        topStack.spacing = 10
        topStack.alignment = .center
        topStack.distribution = .fill
        topStack.isLayoutMarginsRelativeArrangement = true
        topStack.addArrangedSubview(getVerticalspace(hight: 15))

        let iv = AGImageView()
        iv.clipsToBounds = true
        iv.isCircle = true
        iv.heightAnchor.constraint(equalToConstant: 90).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 90).isActive = true

        if let imageUrl = imageUrl, !imageUrl.isEmpty {
            iv.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "logo1"))
        } else if let initials = initials {
            iv.image = initialsImage(initials: initials)
        }
        topStack.addArrangedSubview(iv)
        stack.addArrangedSubview(topStack)

        // 🔹 First 3 fields → Titles in one row, Values in next row
        if model.count >= 3 {
            let threeColSection = createThreeColSection(model: model)
            stack.addArrangedSubview(threeColSection)
            stack.addArrangedSubview(getVerticalspace(hight: 5))
        }

        // 🔹 Remaining fields → Show as rows
        for (index, item) in model.enumerated() {
            if index >= 3 {
                let rowStack = createRow(title: item.title, value: item.value)
                stack.addArrangedSubview(rowStack)
            }
        }

        // 🔹 Shadow
        view.shadowOffset = CGSize(width: 0, height: -2)
        view.shadowRadius = 5
        view.shadowColor = UIColor.black
        view.shadowOpacity = 0.80
    }

    
    
//    func setupData(model: [MyPopupListModel], border: Bool? = false, imageUrl: String?, initials: String? = nil) {
//            let theSubviews : [UIView] = stack.subviews
//            for view in theSubviews {
//                view.removeFromSuperview()
//            }
//            
//            let rowStack = UIStackView()
//            rowStack.axis = .vertical
//            rowStack.spacing = 10
//            rowStack.alignment = .center
//            rowStack.distribution = .fill
//            rowStack.isLayoutMarginsRelativeArrangement = true
//            rowStack.addArrangedSubview(getVerticalspace(hight: 15))
//
//            let iv: AGImageView = AGImageView()
//            iv.clipsToBounds = true
//            iv.isCircle = true
//            iv.heightAnchor.constraint(equalToConstant: 90).isActive = true
//            iv.widthAnchor.constraint(equalToConstant: 90).isActive = true
//            
//            if let imageUrl = imageUrl, !imageUrl.isEmpty {
//                iv.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "logo1"))
//                rowStack.addArrangedSubview(iv)
//            } else if let initials = initials {
//                iv.image = initialsImage(initials: initials)
//                rowStack.addArrangedSubview(iv)
//            }
//            
//            stack.addArrangedSubview(rowStack)
//
//           
//            let hStack = UIStackView()
//            hStack.axis = .horizontal
//            hStack.alignment = .center
//            hStack.distribution = .fillEqually
//            for (index,item) in model.enumerated() {
//                if index < 3 {
//                    let rowStack = createCol(title: item.title, value: item.value)
//                    hStack.addArrangedSubview(rowStack)
//                    if index == 2 {
//                        stack.addArrangedSubview(hStack)
//                        stack.addArrangedSubview(getVerticalspace(hight: 5))
//                    }
//                } else {
//                    let rowStack = createRow(title: item.title, value: item.value)
//                    stack.addArrangedSubview(rowStack)
//                }
//            }
//            view.shadowOffset = CGSize(width: 0, height: -2)
//            view.shadowRadius = 5
//            view.shadowColor = UIColor.black
//            view.shadowOpacity = 0.80
//        }
    func initialsImage(initials: String, size: CGSize = CGSize(width: 90, height: 90)) -> UIImage {
            let renderer = UIGraphicsImageRenderer(size: size)
            return renderer.image { context in
                // 🔹 Background color = appGreen
                (UIColor(named: "appGreen") ?? UIColor.systemGreen).setFill()
                context.fill(CGRect(origin: .zero, size: size))
                
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont(name: "RobotoSlab-Bold", size: size.width / 2) ?? UIFont.systemFont(ofSize: size.width / 2),
                    .foregroundColor: UIColor.white
                ]
                
                let textSize = initials.size(withAttributes: attributes)
                let rect = CGRect(
                    x: (size.width - textSize.width) / 2,
                    y: (size.height - textSize.height) / 2,
                    width: textSize.width,
                    height: textSize.height
                )
                initials.draw(in: rect, withAttributes: attributes)
            }
        }
        
        func getVerticalspace(hight: Int) -> UILabel {
            let titleLabel = UILabel()
            titleLabel.text = ""
            titleLabel.numberOfLines = 0
            titleLabel.font = UIFont.loraFont(size: 15, weight: .Bold)
            titleLabel.textColor = .black
            titleLabel.textAlignment = .center
            titleLabel.heightAnchor.constraint(equalToConstant: CGFloat(hight)).isActive = true
            titleLabel.widthAnchor.constraint(equalToConstant: self.frame.width - 20).isActive = true
            return titleLabel
        }
        
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }
        
        func createbottomSeparator() -> UIView {
            let separator = UIView()
            separator.backgroundColor = .white
            separator.heightAnchor.constraint(equalToConstant: 5).isActive = true
            return separator
        }
    func createThreeColSection(model: [MyPopupListModel]) -> UIStackView {
        // Titles Row
        let titleRow = UIStackView()
        titleRow.axis = .horizontal
        titleRow.alignment = .fill
        titleRow.distribution = .fillEqually
        titleRow.spacing = 8

        // Values Row
        let valueRow = UIStackView()
        valueRow.axis = .horizontal
        valueRow.alignment = .top   // 👈 important: values expand only downward
        valueRow.distribution = .fillEqually
        valueRow.spacing = 8

        for (index, item) in model.enumerated() where index < 3 {
            // Title
            let titleLabel = UILabel()
            titleLabel.text = item.title
            titleLabel.font = UIFont.loraFont(size: 13, weight: .Regular)
            titleLabel.textColor = .gray
            titleLabel.textAlignment = .center
            titleLabel.numberOfLines = 1
            titleRow.addArrangedSubview(titleLabel)

            // Value box
            let container = UIView()
            container.backgroundColor = UIColor(hex: "#E9F9F7")
            container.layer.borderColor = UIColor(named: "appGreen")?.cgColor
            container.layer.borderWidth = 1
            container.layer.cornerRadius = 15
            container.translatesAutoresizingMaskIntoConstraints = false

            let valueLabel = UILabel()
            valueLabel.text = item.value.isEmpty ? "NA" : item.value
            valueLabel.font = UIFont.loraFont(size: 13, weight: .Bold)
            valueLabel.textColor = UIColor(named: "appGreen")
            valueLabel.textAlignment = .center
            valueLabel.numberOfLines = 0
            valueLabel.lineBreakMode = .byWordWrapping
            valueLabel.translatesAutoresizingMaskIntoConstraints = false

            container.addSubview(valueLabel)
            NSLayoutConstraint.activate([
                valueLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 6),
                valueLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
                valueLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
                valueLabel.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: -6)
            ])

            valueRow.addArrangedSubview(container)
        }

        // Combine into vertical stack
        let mainStack = UIStackView(arrangedSubviews: [titleRow, valueRow])
        mainStack.axis = .vertical
        mainStack.spacing = 4
        return mainStack
    }

        
//        func createCol(title: String, value: String) -> UIStackView {
//            let rowStack = UIStackView()
//            rowStack.axis = .vertical
//            rowStack.spacing = 0
//            rowStack.alignment = .center
//            rowStack.distribution = .fill
//            rowStack.isLayoutMarginsRelativeArrangement = true
//
//            let titleLabel = UILabel()
//            titleLabel.text = title
//            titleLabel.numberOfLines = 0
//            titleLabel.font = UIFont.loraFont(size: 13, weight: .Regular)
//            titleLabel.textColor = .gray
//            titleLabel.textAlignment = .center
//            titleLabel.widthAnchor.constraint(equalToConstant: self.frame.width/3).isActive = true
//            titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
//            
//            let valueLabel = UILabel()
//            valueLabel.text = value.count > 0 ? value : "NA"
//            valueLabel.font = UIFont.loraFont(size: 13, weight: .Bold)
//            valueLabel.textColor = UIColor(named: "appGreen")
//            valueLabel.clipsToBounds = true
//            valueLabel.textAlignment = .center
//            valueLabel.widthAnchor.constraint(equalToConstant: self.frame.width/4).isActive = true
//            valueLabel.numberOfLines = 0
//            valueLabel.layer.borderColor = UIColor(named: "appGreen")?.cgColor
//            valueLabel.layer.borderWidth = 1
//            valueLabel.layer.cornerRadius = 15
//            valueLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
//            valueLabel.backgroundColor = UIColor(hex: "#E9F9F7")
//
//
//            rowStack.addArrangedSubview(titleLabel)
//            rowStack.addArrangedSubview(valueLabel)
//            
//            return rowStack
//        }

        
        func createRow(title: String, value: String) -> UIStackView {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 10
            rowStack.alignment = .fill
            rowStack.distribution = .fillEqually
            rowStack.isLayoutMarginsRelativeArrangement = true
            
            let space = UILabel()
            space.text = " "
            space.textAlignment = .center
            space.numberOfLines = 0
            space.font = UIFont.loraFont(size: 20, weight: .Bold)
            space.textColor = UIColor(named: "appGreen")
            space.widthAnchor.constraint(equalToConstant: 10).isActive = true
            
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.numberOfLines = 0
            titleLabel.textAlignment = .left
            titleLabel.textAlignment = .left
       
            titleLabel.font = UIFont.loraFont(size: 13, weight: .Regular)
            titleLabel.textColor = UIColor(named: "appGreen")
            titleLabel.widthAnchor.constraint(equalToConstant: self.frame.width/2).isActive = true
            
            let dotLabel = UILabel()
            dotLabel.text = ":"
            dotLabel.textAlignment = .center
            dotLabel.numberOfLines = 0
            dotLabel.font = UIFont.loraFont(size: 20, weight: .Regular)
            dotLabel.textColor = .black
            dotLabel.widthAnchor.constraint(equalToConstant: 10).isActive = true
            
            let valueLabel = UILabel()
            valueLabel.text = value
            valueLabel.font = UIFont.loraFont(size: 13, weight: .Regular)
            valueLabel.textColor = .black
            valueLabel.numberOfLines = 0
    //        rowStack.addArrangedSubview(space)
            rowStack.addArrangedSubview(titleLabel)
            rowStack.addArrangedSubview(dotLabel)
            rowStack.addArrangedSubview(valueLabel)
            
            return rowStack
        }

        func createSeparator() -> UIView {
            let separator = UIView()
            separator.backgroundColor = UIColor(named: "appGreen")!.withAlphaComponent(0.3)
            separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
            return separator
        }
    }

    extension UIView {

        func generateOuterShadow() {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.layer.cornerRadius = layer.cornerRadius
            view.layer.shadowRadius = layer.shadowRadius
            view.layer.shadowOpacity = 0.5
            view.layer.shadowColor = layer.shadowColor
            view.layer.shadowOffset = CGSize.zero
            view.clipsToBounds = false
            view.backgroundColor = .red

            superview?.insertSubview(view, belowSubview: self)

            let constraints = [
                NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            ]
            superview?.addConstraints(constraints)
        }
        
        func addShadow(cornerRadius: CGFloat, color: UIColor, offset: CGSize, opacity: Float, shadowRadius: CGFloat) {
                self.layer.cornerRadius = cornerRadius
    //            self.layer.maskedCorners = maskedCorners
                self.layer.shadowColor = color.cgColor
                self.layer.shadowOffset = offset
                self.layer.shadowOpacity = opacity
                self.layer.shadowRadius = shadowRadius
            }
    }
