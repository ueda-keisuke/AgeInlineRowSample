# AgeInlineRowSample

日本語の記述は後半にあります。

## What is this?
This is a custom inline row for Eureka 1.5.0 or newer. The default `PickerInlineRow` has only one component because

    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

in the `public class PickerCell<T where T: Equatable>` class.

I have implemented a custom inline picker row with four components. 

![image.png](https://github.com/ueda-keisuke/AgeInlineRowSample/blob/screenshot/e093df26-21fe-11e6-8e3f-89a3ae58770e.png)


## 説明
簡単に多機能なテーブルビューを作れるEurekaというライブラリのカスタムRowです。`PickerInlineRow`は中で使われている`PickerCell`の`numberOfComponentsInPickerView`が常に1を返すように固定されているのでカスタマイズできません。このため、`PickerInlineRow`を参考にしてカスタムRowを作ってみました。

AgeInlineRowは○歳○ヶ月という形の子供の年齢を選択できます。
