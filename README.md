示例代码 会为这个类自动加上toJson函数 返回值是一个JsonObject对象

```
import data_flex.*

import encoding.json.*

@DataClass
public class User{
    public var name:String = "" 
}
```

<h4>许多个小目标:<h4>

1.修复类中存在非变量的成员时报错的情况 加入模式匹配（√）

2.加入自动类型匹配 如 String类型则转换为JsonString Int则是JsonInt（部分）

3.加入可选引用库 如引用Json库则 加入toJson函数 引用yaml库则加入toYaml函数 等

4.待定


目前支持的数据类型：

String Int Int64 Bool Float


需要功能联系qq:2310046309投稿
