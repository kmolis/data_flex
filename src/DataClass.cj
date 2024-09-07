macro package data_flex

import std.ast.*

public macro DataClass(input: Tokens) {
    // 创建类定义节点
    let classDecl = ClassDecl(input)
    
    // 获取类体
    let body = classDecl.body
    // if (body == None) {
    //     diagReport(DiagReportLevel.ERROR, input, "Class body is empty", "Expected class body")
    // }


    // 遍历 Body 的声明节点
    // for (decl in body.decls) { // Body 的 decls 属性
    //     // 使用通用的方式识别字段声明（假设字段声明是某种特定的 Decl 类型）
    //     if (decl is VarDecl) { // Replace this with the actual condition for field declaration
    //         // 从 decl 中提取字段名
    //         // 假设字段名可以通过某种方式获取，例如通过某个属性
    //         let fieldName = decl.identifier // Adjust this line based on actual field name extraction method
    //         fields.append(fieldName)
    //     }
    // }
    // println("a${body.decls.get(0).getOrThrow().identifier.value}")
    var a:Tokens = Tokens()

    for (decl in body.decls) {
        match(decl.modifiers){
            case 
        }
        a.append(quote(
            jsonObj.put($(decl.identifier.value),JsonString(this.$(decl.identifier)))
        ))
    }
var keyValuesDecl:VarDecl = VarDecl(quote(
     var jsonObj = JsonObject()
))

    var s = "${body.decls.get(0).getOrThrow().identifier.value}"
    var i = body.decls.get(0).getOrThrow().identifier
    // 生成输出方法
    let toJson:Decl = FuncDecl(quote(
        public func toJson():JsonObject{
            $(keyValuesDecl)
            $(a)
            // $(keyValues)
            // println("${keyValues.get(0).key}")
            jsonObj
        }
    ))
    body.decls.append(toJson)
    return classDecl.toTokens()
}
