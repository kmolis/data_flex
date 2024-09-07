macro package data_flex

import std.ast.*

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
            println("变量")
            a.append(
                quote(
                    jsonObj.put($(decl.identifier.value),JsonString(this.$(decl.identifier)))
                )
            )
        }else{
            println("非变量")
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
