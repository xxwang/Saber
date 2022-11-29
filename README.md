# Saber

#### 简介
```
Swift(日常开发工具包)
 - Exs: 扩展
 - Shared: 共享
 - Utils: 工具
 
本工具目前仅供作者使用,因为修改频繁,不建议生产项目使用.
```
#### SPM方式安装
```
dependencies: [
    .package(url: "github.com/xxwang/sb1.git", branch: "master")
]
```

### 导入方式
```
// 单文件引入
import Saber

// 全局引入
@_exported import Saber
```

### 生成xcodeproj文件
```
swift package generate-xcodeproj
```
