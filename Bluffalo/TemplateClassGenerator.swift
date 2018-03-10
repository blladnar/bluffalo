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
    init(classStruct: Class, nimble: Bool?) {
        self.classStruct = classStruct
    }
    
    func makeFakeClass() -> String {
        let template = Template(templateString: """

        class Fake{{ class.name }}: {{ class.name }}, Spryable {
            enum Function: String, StringRepresentable {
                {% for method in methods %}
                case {{ method.name | method }} = "{{ method.name | method }}"
                {% endfor %}
            }

            {% for method in methods %}
            func {{ method.nameWithExternalNames }}{% if method.returnType %}-> {{ method.returnType }}{% endif %} {
                return spryify({% if method.externalArgumentNames.count > 0 %}arguments: {{ method.externalArgumentNames|join:", "}}{% endif %})
            }
            {% endfor %}
        }

        """)
        
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
