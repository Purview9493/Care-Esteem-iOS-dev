//
//  InfoAboutStackTableViewCell.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 09/03/25.
//



import UIKit
class InfoAboutStackTableViewCell:UITableViewCell{
    
    @IBOutlet weak var stack: UIStackView!
    
        override func prepareForReuse() {
            super.prepareForReuse()
            stack.arrangedSubviews.forEach { $0.removeFromSuperview() }
            stack.layer.borderWidth = 0
           
        }

        // MARK: - Risk Data
        func setupData(riskModel: [RiskAssesstment], title: String? = nil) {
            resetStack()

            if let title = title {
                stack.addArrangedSubview(makeTitleLabel(text: title))
            }

            for model in riskModel {
                setupDataRisk(model: model)
            }

            stack.addArrangedSubview(createBottomSeparator())
            applyBorder()
        }

        // MARK: - Popup Data
        func setupData(model: [MyPopupListModel], border: Bool? = false, title: String? = nil) {
            resetStack()

            if let title = title {
                stack.addArrangedSubview(makeTitleLabel(text: title))
            }

            for (index, item) in model.enumerated() {
                stack.addArrangedSubview(createRow(title: item.title, value: item.value))
                if index < model.count - 1 {
                    stack.addArrangedSubview(createSeparator())
                }
            }

            if border ?? false {
                stack.addArrangedSubview(createBottomSeparator())
                applyBorder()
            }
        }

        // MARK: - Helpers

        private func resetStack() {
            stack.arrangedSubviews.forEach { $0.removeFromSuperview() }
            stack.layer.borderWidth = 0
        }

        private func applyBorder() {
            stack.layer.borderColor = UIColor(named: "appGreen")?.cgColor
            stack.layer.borderWidth = 1
            stack.layer.cornerRadius = 10
            stack.clipsToBounds = true
        }

        private func makeTitleLabel(text: String) -> UILabel {
            let titleLabel = UILabel()
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.text = text
            titleLabel.numberOfLines = 0
            titleLabel.font = UIFont.loraFont(size: 15, weight: .Bold)
            titleLabel.textColor = .black
            titleLabel.textAlignment = .center
            return titleLabel
        }

//        func createRow(title: String, value: String) -> UIStackView {
//            let rowStack = UIStackView()
//            rowStack.axis = .horizontal
//            rowStack.alignment = .fill
//            rowStack.distribution = .fill
//            rowStack.spacing = 25
//
//            let titleLabel = UILabel()
//            titleLabel.translatesAutoresizingMaskIntoConstraints = false
//            titleLabel.text = title
//            titleLabel.font = UIFont.loraFont(size: 13, weight: .Regular)
//            titleLabel.textColor = .black
//            titleLabel.numberOfLines = 0
//            titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//
//            let dotLabel = UILabel()
//            dotLabel.translatesAutoresizingMaskIntoConstraints = false
//            dotLabel.text = ":"
//            dotLabel.font = UIFont.loraFont(size: 15, weight: .Regular)
//            dotLabel.textColor = .black
//            dotLabel.setContentHuggingPriority(.required, for: .horizontal)
//
//            let valueLabel = UILabel()
//            valueLabel.translatesAutoresizingMaskIntoConstraints = false
//            valueLabel.text = value
//            valueLabel.font = UIFont(name: "RobotoSlab-Regular", size: 13)
//            valueLabel.textColor = .black
//            valueLabel.numberOfLines = 0
//            valueLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
//
//            rowStack.addArrangedSubview(titleLabel)
//            rowStack.addArrangedSubview(dotLabel)
//            rowStack.addArrangedSubview(valueLabel)
//
//            return rowStack
//        }
    func createRow(title: String, value: String) -> UIStackView {
        let rowStack = UIStackView()
        rowStack.axis = .horizontal
        rowStack.alignment = .center
        rowStack.distribution = .fill
        rowStack.spacing = 0  // Hum custom spacing denge

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = UIFont.loraFont(size: 13, weight: .Regular)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        let dotLabel = UILabel()
        dotLabel.translatesAutoresizingMaskIntoConstraints = false
        dotLabel.text = ":"
        dotLabel.font = UIFont.loraFont(size: 15, weight: .Regular)
        dotLabel.textColor = .black
        dotLabel.setContentHuggingPriority(.required, for: .horizontal)

        let valueLabel = UILabel()
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.text = value
        valueLabel.font = UIFont(name: "RobotoSlab-Regular", size: 13)
        valueLabel.textColor = .black
        valueLabel.numberOfLines = 0
        valueLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

        rowStack.addArrangedSubview(titleLabel)
        rowStack.addArrangedSubview(dotLabel)
        rowStack.addArrangedSubview(valueLabel)

        // 👉 Title → Colon = 40pt (spacing between title and colon)
        rowStack.setCustomSpacing(40, after: titleLabel)

        // 👉 Value → Next element = 20pt (spacing after the value)
        rowStack.setCustomSpacing(20, after: valueLabel)

        return rowStack
    }



        func createSeparator() -> UIView {
            let separator = UIView()
            separator.translatesAutoresizingMaskIntoConstraints = false
            separator.backgroundColor = UIColor(named: "appGreen")!.withAlphaComponent(0.3)
            separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
            return separator
        }

        func createBottomSeparator() -> UIView {
            let separator = UIView()
            separator.translatesAutoresizingMaskIntoConstraints = false
            separator.backgroundColor = .white
            separator.heightAnchor.constraint(equalToConstant: 5).isActive = true
            return separator
        }
    }

    // MARK: - RiskAssesstment Extension
    extension InfoAboutStackTableViewCell {
        func setupDataRisk(model: RiskAssesstment) {
            let stack1 = UIStackView()
            stack1.axis = .vertical
            stack1.spacing = 10
            stack1.alignment = .fill
            stack1.distribution = .fill

            if !model.isBottom {
                for (index, item) in model.value.enumerated() {
                    if model.isListItem, index == 0 {
                        let titleLabel = UILabel()
                        titleLabel.translatesAutoresizingMaskIntoConstraints = false
                        titleLabel.text = item.title
                        titleLabel.textAlignment = .center
                        titleLabel.numberOfLines = 0
                        titleLabel.font = UIFont.loraFont(size: 13, weight: .Regular)
                        titleLabel.textColor = .black
                        stack1.addArrangedSubview(titleLabel)
                    } else {
                        stack1.addArrangedSubview(createRow(title: item.title, value: item.value))
                    }
                }
            }

            if model.isBottom {
                let vStack = UIStackView()
                vStack.axis = .vertical
                vStack.spacing = 10

                let titleLabel = UILabel()
                titleLabel.translatesAutoresizingMaskIntoConstraints = false
                titleLabel.text = "Signatures of All Involved Admins in the Assessment"
                titleLabel.numberOfLines = 0
                titleLabel.font = UIFont.loraFont(size: 13, weight: .Regular)
                titleLabel.textColor = .black
                vStack.addArrangedSubview(titleLabel)
                vStack.addArrangedSubview(createNameAndDate(model: model))

                stack1.addArrangedSubview(vStack)
            }

            stack.addArrangedSubview(stack1)
        }

        func createNameAndDate(model: RiskAssesstment) -> UIStackView {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 10
            rowStack.alignment = .leading
            rowStack.distribution = .fillEqually

            let data: [(title: String, value: String)] = [
                ("Name", model.name),
                ("Date", model.date)
            ]

            for item in data {
                let colStack = UIStackView()
                colStack.axis = .vertical
                colStack.spacing = 5

                let titleLabel = UILabel()
                titleLabel.translatesAutoresizingMaskIntoConstraints = false
                titleLabel.text = item.title
                titleLabel.font = UIFont.loraFont(size: 13, weight: .Regular)
                titleLabel.textColor = .black

                let valueLabel = UILabel()
                valueLabel.translatesAutoresizingMaskIntoConstraints = false
                valueLabel.text = item.value
                valueLabel.font = UIFont.loraFont(size: 13, weight: .Regular)
                valueLabel.textColor = .black
                valueLabel.numberOfLines = 0

                colStack.addArrangedSubview(titleLabel)
                colStack.addArrangedSubview(valueLabel)
                rowStack.addArrangedSubview(colStack)
            }

            return rowStack
        }
    }








