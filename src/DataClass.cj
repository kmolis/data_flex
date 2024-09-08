macro package data_flex

import std.ast.*
import encoding.json.*

public macro DataClass(input: Tokens) {
    // 创建类定义节点
    let classDecl = ClassDecl(input)

    // 获取类体，确保非空
    let body = classDecl.body
    var jsonAssignment: Tokens = Tokens()

    // 遍历类体中的声明，处理 VarDecl 类型
    for (decl in body.decls) {
        if (decl is VarDecl) {
            // 将 VarDecl 的类型转换为字符串
            var VarDecl = decl as VarDecl
            var inputValueType = VarDecl?.declType.toTokens().get(0).value
            var outValueType: Tokens = Tokens()

            // 根据变量类型映射对应的 JSON 类型
            if (inputValueType == "String") {
                outValueType = quote(JsonString)
            } else if (inputValueType.getOrThrow().contains("Int")) {
                outValueType = quote(JsonInt)
            } else if (inputValueType == "Bool") {
                outValueType = quote(JsonBool)
            } else if (inputValueType == "Float64") {
                outValueType = quote(JsonFloat)
            }

            // 生成 JSON 序列化代码
            jsonAssignment.append(
                quote(
                    jsonObj.put($(decl.identifier.value), $(outValueType)(this.$(decl.identifier)))
                )
            )
        }
    }

    // 初始化 JSON 对象
    var keyValuesDecl: VarDecl = VarDecl(quote(
        var jsonObj = JsonObject()
    ))

    // 生成 toJson 方法，返回 JSON 对象
    let toJson: Decl = FuncDecl(
        quote(
        public func toJson(): JsonObject {
            $(keyValuesDecl)
            $(jsonAssignment)
            jsonObj
        }
    )
    )

    // 将生成的 toJson 方法添加到类体中
    body.decls.append(toJson)

    return classDecl.toTokens()
}
