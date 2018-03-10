//
//  TemplateClassGenerator.swift
//  Bluffalo
//
//  Created by RBrown on 3/5/18.
//  Copyright © 2018 pair. All rights reserved.
//

import Foundation

class TemplateClassGenerator: ClassGenerator {
    let classStruct: Class
    let templateString: String
    init(classStruct: Class, nimble: Bool?, templatePath: String) {
        self.classStruct = classStruct
        templateString = try! String(contentsOfFile: templatePath, encoding: String.Encoding.ascii)
    }

    
    func makeFakeClass() -> String {
        let template = Template(templateString: templateString)
        let context = [
            "class": classStruct,
            "methods": classStruct.methods
            ] as [String : Any]
        
        guard let code = try? template.render(context) else {
            return "Failed"
        }
        
        return code
    }
}
