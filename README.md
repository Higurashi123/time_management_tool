# time_management_tool
## これ何
作業時間を計測するツールです。

## 使用方法
引数に{start 作業のタイトル}で作業の開始時間の打刻をします。<br>
引数に{finish_work}で作業の終了時間の打刻をします。<br>
引数に{finish_day}で1日のトータルの作業時間を計算します。<br>

```
ruby time_management_tool.rb start Rubyの学習
ruby time_management_tool.rb finish_work
ruby time_management_tool.rb start Pythonの学習
ruby time_management_tool.rb finish_work
ruby time_management_tool.rb finish_day
```
