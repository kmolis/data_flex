示例代码 会为这个类自动加上toJson函数 返回值是一个JsonObject对象

```
import data_flex.*

import encoding.json.*

@DataClass
public class User{
    public var name:String = "" 
}
```
