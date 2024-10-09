//
//  TodoDetailView.swift
//  basics
//
//  Created by Linus Widing on 07.10.24.
//

import SwiftUI

protocol TodoDeleteButtonDelegate: AnyObject{
    func onDeleteClick()
}

struct TodoDeleteButton: View {
    
    weak var delegate: TodoDeleteButtonDelegate?
    
    var body: some View {
        Button(action: {
            delegate?.onDeleteClick()
        }, label: {
            Text(BasicStrings.deleteTodo.localized)
                .frame(maxWidth: .infinity)
                .padding(.vertical, BasicsSizes.paddingSmall)
        })
        .buttonStyle(.borderedProminent)
        .tint(.red)
    }
}

#Preview {
    TodoDeleteButton()
}
