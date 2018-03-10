/*
 * Structures.swift
 * Copyright (c) 2017 Nordstrom, Inc. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation

/**
 Defines keywords used to derive values from SourceKitten dictionaries.
 */
enum MethodKind: String {
    case Instance = "source.lang.swift.decl.function.method.instance"
    case Class = "source.lang.swift.decl.function.method.class"
    case Static = "source.lang.swift.decl.function.method.static"
    case InstanceVar = "source.lang.swift.decl.var.instance"
    case Call = "source.lang.swift.expr.call"
    case StaticVar = "source.lang.swift.decl.var.static"
    case ClassVar = "source.land.swift.decl.var.class"
}

enum MethodAccessibility: String {
    case Internal = "source.lang.swift.accessibility.internal"
    case Private = "source.lang.swift.accessibility.private"
    case Fileprivate = "source.lang.swift.accessibility.fileprivate"
    case Public = "source.lang.swift.accessibility.public"
    case Open = "source.lang.swift.accessibility.open"
}

enum ClassKind: String {
    case ClassKind = "source.lang.swift.decl.class"
    case ProtocolKind = "source.lang.swift.decl.protocol"
    case StructKind = "source.lang.swift.decl.struct"
    case Unknown
}

/**
 Defines the structure of a Swift method.
 */
struct Method {
    let name: String
    let nameWithExternalNames: String
    let kind: MethodKind
    let accessibility: MethodAccessibility
    let argumentNames: [String]
    let externalArgumentNames: [String]
    let argumentTypes: [String]
    let returnType: String?
    let kindString: String
    let nameWithoutArguments: String
    
    init(name: String,
         nameWithExternalNames: String,
          kind: MethodKind,
    accessibility: MethodAccessibility,
    argumentNames: [String],
    externalArgumentNames: [String],
    argumentTypes: [String],
    returnType: String?) {
        self.name = name
        self.nameWithExternalNames = nameWithExternalNames
        self.kind = kind
        self.accessibility = accessibility
        self.argumentNames = argumentNames
        self.externalArgumentNames = externalArgumentNames
        self.argumentTypes = argumentTypes
        self.returnType = returnType
        self.nameWithoutArguments = String(name.split(separator: "(", maxSplits: 1, omittingEmptySubsequences: true).first!)
        self.kindString = stringForMethodKind(methodKind: kind)
    }
}

func stringForMethodKind(methodKind: MethodKind) -> String {
    switch methodKind {
    case .Class: return "class func"
    case .Instance: return "func"
    case .Static: return "static func"
    case .InstanceVar: return "var"
    case .Call: return ""
    case .StaticVar: return "static var"
    case .ClassVar: return ""
    }
}

/**
 Defines the structure of a Swift class/protocol.
 */
struct Class {
    let kind: ClassKind
    let name: String
    let kindString: String
    
    private var _methods: [Method]?
    internal var methods: [Method] {
        return _methods ?? []
    }
    
    internal var enumName: String {
        return "\(name)Method"
    }
    
    internal var classMethods: [Method] {
        return methods.filter {
            $0.kind == .Class || $0.kind == .Static
        }
    }
    
    internal var instanceMethods: [Method] {
        return methods.filter {
            return $0.kind == .Instance
        }
    }
    
    init(kind: ClassKind, name: String, methods: [Method]) {
        self.kind = kind
        self.name = name
        self.kindString = kind.rawValue
        self._methods = onlyRealMethods(methods: methods)
    }
    
    private func onlyRealMethods(methods: [Method]) -> [Method] {
        return methods.filter { (method: Method) -> Bool in
            if method.name.contains("init(") {
                return false
            }
            
            return true
        }
    }
}
