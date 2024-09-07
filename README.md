示例代码 会为这个类自动加上toJson函数 返回值是一个JsonObject对象

```
import data_flex.*

import encoding.json.*

@DataClass
public class User{
    public var name:String = "" 
}
```


许多个小目标：

1.修复宏内无法过滤非变量的Token

2.增加类型匹配 如String对应JsonString Int对应JsonInt

3.增加可选则引入文件来加入函数 比如引用json库则加入toJson函数 引用yaml就加入toYaml函数
