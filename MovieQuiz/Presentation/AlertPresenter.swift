//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Aleksey Kosichenko on 14.04.2026.
//

import Foundation
import UIKit

//MARK: - AlertPresenter

final class AlertPresenter {
    
    // MARK: - Methods
    
    func show(alertModel: AlertModel, controller: UIViewController, accessibilityId: String) {
        
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert
        )
        
        alert.view.accessibilityIdentifier = accessibilityId
        let action = UIAlertAction(title: alertModel.buttonText, style: .default){ _ in
            alertModel.completion()
        }
            alert.addAction(action)
            controller.present(alert, animated: true, completion: nil)
    }
}
