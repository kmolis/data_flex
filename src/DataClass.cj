macro package data_flex

import std.ast.*
import encoding.json.*

public macro DataClass(input: Tokens) {
    // 创建类定义节点
    let classDecl = ClassDecl(input)

    // 获取类体
    let body = classDecl.body
    // 判断body空

    var a: Tokens = Tokens()

    // 给我添加decl匹配类型 必须为VarDecl
    for (decl in body.decls) {
        if (decl is VarDecl) {
            // println("变量")
            var VarDecl = decl as VarDecl
            // println("${VarDecl?.declType.typeParameterName.dump()}")

            var inputValueType = VarDecl?.declType.toTokens().get(0).value
            // println("${(VarDecl?.declType.toTokens().get(0) == Option()}")
            
            var outValueType: Tokens = Tokens()

            // VarDecl?.declType.dump()
            println("${VarDecl?.declType.typeParameterName.value}")
            if (inputValueType == "String") {
                outValueType = quote(JsonString)
            } else if (inputValueType == "Int" || inputValueType == "Int64") {
                outValueType = quote(JsonInt)
            }else if (inputValueType == "Bool"){
                outValueType = quote(JsonBool)
            }else if (inputValueType == "Float64"){
                outValueType = quote(JsonFloat)
            }
            // var  a :Float = 
            a.append(
                quote(
                    jsonObj.put($(decl.identifier.value),$(outValueType)(this.$(decl.identifier)))
                )
            )
        } else {
            // println("非变量")
        }
    }
    var keyValuesDecl: VarDecl = VarDecl(quote(
        var jsonObj = JsonObject()
    ))

    // 生成输出方法
    let toJson: Decl = FuncDecl(
        quote(
        public func toJson():JsonObject{
            $(keyValuesDecl)
            $(a)
            jsonObj
        }
    )
    )
    body.decls.append(toJson)
    return classDecl.toTokens()
}
