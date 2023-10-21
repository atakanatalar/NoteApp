//
//  ToastMessageHelper.swift
//  NoteApp
//
//  Created by Atakan Atalar on 21.10.2023.
//

import ToastViewSwift

enum ToastMessageType {
    case success, failure
}

class ToastMessageHelper {
    func createToastMessage(toastMessageType: ToastMessageType, message: String) {
        var image = UIImage()

        switch toastMessageType {
        case .success:
            image = UIImage(systemName: "checkmark.circle")!.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
        case .failure:
            image = UIImage(systemName: "exclamationmark.triangle")!.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        }

        let config = ToastConfiguration(direction: .bottom, dismissBy: [.time(time: 4.0), .swipe(direction: .natural), .longPress], animationTime: 0.2, enteringAnimation: .default, exitingAnimation: .default)

        let toast = Toast.default(
            image: image,
            title: message,
            config: config
        )

        toast.show()
    }
}
