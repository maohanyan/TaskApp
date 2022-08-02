//
//  UserProtocol.swift
//  TaskApp
//
//  Created by Mariam Ohanyan on 02.08.22.
//

import Foundation

protocol UserProtocol {
    func title() -> String
    func info() -> String
    func identifier() -> String
    func coordinates() -> (Double, Double)
    func mediumPicURL() -> String
    func largePicURL() -> String
}
