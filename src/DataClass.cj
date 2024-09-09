macro package data_flex

import std.ast.*
import encoding.json.*

public macro DataClass(input: Tokens) {
    // 创建类定义节点
    let classDecl = ClassDecl(input)

    // 获取类体，确保非空
    let body = classDecl.body
    var jsonAssignment: Tokens = Tokens()
    var strInitAssignment: Tokens = Tokens()

    // 遍历类体中的声明，处理 VarDecl 类型
    for (decl in body.decls) {
        if (decl is VarDecl) {
            // 将 VarDecl 的类型转换为VarDecl
            var VarDecl = decl as VarDecl
            var vd = VarDecl.getOrThrow()

            var inputValueTypeToken = vd.declType.toTokens()
            var inputValueTypeString = vd.declType.toTokens().get(0).value
            var outValueTypeToken: Tokens = Tokens()
            var jsonChangeFunc: Tokens = Tokens()

            // 根据变量类型映射对应的 JSON 类型
            if (inputValueTypeString == "String") {
                outValueTypeToken = quote(JsonString)
                jsonChangeFunc = quote(asString())
            } else if (inputValueTypeString.contains("Int")) {
                outValueTypeToken = quote(JsonInt)
                jsonChangeFunc = quote(asInt())
            } else if (inputValueTypeString == "Bool") {
                outValueTypeToken = quote(JsonBool)
                jsonChangeFunc = quote(asBool())
            } else if (inputValueTypeString == "Float64") {
                outValueTypeToken = quote(JsonFloat)
                jsonChangeFunc = quote(asFloat())
            }

            // println("${decl.identifier.value}")

            // 生成 JSON 序列化代码
            jsonAssignment.append(
                quote(
                    jsonObj.put($(decl.identifier.value), $(outValueTypeToken)(this.$(decl.identifier)))
                )
            )
            strInitAssignment.append(
                quote(
                    $(decl.identifier) = json.asObject().get($(decl.identifier.value)).getOrThrow().$(jsonChangeFunc).getValue()
                )
            )
        }
    }

    let initStr: Decl = FuncDecl(
        quote(
        public init(jsonStr: String) {
            var json:JsonObject = JsonValue.fromStr(jsonStr).asObject();
            $(strInitAssignment)
        }
    )
    )

    // 生成 toJson 方法，返回 JSON 对象
    let toJson: Decl = FuncDecl(
        quote(
        public func toJson(): JsonObject {
            var jsonObj = JsonObject()
            $(jsonAssignment)
            jsonObj
        }
    )
    )

    let initFunc: Decl = FuncDecl(quote(
        public init() {
            
        }
    ))
    // 将生成的 toJson 方法添加到类体中
    body.decls.append(initFunc)
    body.decls.append(initStr)
    body.decls.append(toJson)

    return classDecl.toTokens()
}
