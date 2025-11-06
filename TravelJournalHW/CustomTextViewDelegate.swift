//
//  CustomTextViewDelegate.swift
//  TravelJournalHW
//
//  Created by Артём Сноегин on 05.11.2025.
//

protocol CustomTextViewDelegate: AnyObject {
    
    func titleDidChange(text: String)
    
    func bodyDidChange(text: String)
}
