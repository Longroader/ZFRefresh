# ZFRefresh

个人开源项目，基于系统UIRefreshControl的自定义下拉刷新控件，极易上手。

## 使用方法，导入ZFRefresh文件夹，在tableViewController中写如下三行代码：
```swift
class ViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.创建刷新控件，添加下拉监听
        refreshControl = ZFRefreshControl(navBar: (navigationController?.navigationBar)!)
        refreshControl?.addTarget(self, action: "loadData", forControlEvents: .ValueChanged)
    }
    
    @objc private func loadData() {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            
	    // 2.网络请求成功或者失败后，结束刷新
            self.refreshControl?.zf_endRefreshing(10)
        }
    }
}
```
## 示例效果
<img src="https://cdn.rawgit.com/lkzhao/Hero/bff6d87907006d1847ed0b7121e9fb4ac4d68320/Resources/Hero.svg" width="388"/>#

## Thanks

受到@极客江南的启发，感谢！

## Contribute

We welcome any contributions. 

## License

Hero is available under the MIT license. See the LICENSE file for more info.
