<h5>宏介绍：</h5>

本仓库项目基于仓颉语言 编译器版本0.54.3

为开发者简化序列化与反序列化 提高开发效率

为类添加方法

- init(jsonStr:String)   ---   通过json字符串初始化类 键值对应数据自动填入
- toJson():JsonObject   ---   将类中数据全部转换为Json对象 无需额外实现

示例代码

```
import data_flex.*
import encoding.json.*

@DataClass
public class User {
    public var name: String = ""
    public var age: Int64 = 0
    public var die: Bool = false
    public var height: Float64 = 60.0
}

```

<h4>许多个小目标:<h4>

1.修复类中存在非变量的成员时报错的情况 加入模式匹配（√）

2.加入自动类型匹配 如 String类型则转换为JsonString Int则是JsonInt（部分）

3.加入可选引用库 如引用Json库则 加入toJson函数 引用yaml库则加入toYaml函数 等

4.加入 init(json:JsonObject)

5.待投稿

<h5>类中支持的数据类型：<h5>

- String   ---   字符串
- Int/Int64   ---   整数
- Bool   ---   布尔值
- Float64   ---   小数

需要额外功能联系qq:2310046309投稿
