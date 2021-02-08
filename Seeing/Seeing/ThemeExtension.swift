//
//  ThemeExtension.swift
//  Seeing
//
//  Created by shutingqiang on 2021/2/7.
//

import UIKit

public extension UIColor {
    /// 主题色 比如一些按钮的颜色
    @objc static let themeTintColor: UIColor = UIColor.dynamicColor(#colorLiteral(red: 0.1607843137, green: 0.5019607843, blue: 1, alpha: 1), darkColor: #colorLiteral(red: 0.1607843137, green: 0.5019607843, blue: 1, alpha: 1))

    /// 按钮点击的颜色
    @objc static let themeHighlightedTintColor: UIColor = UIColor.dynamicColor(#colorLiteral(red: 0.1607843137, green: 0.5019607843, blue: 1, alpha: 0.5), darkColor: #colorLiteral(red: 0.1529411765, green: 0.7529411765, blue: 0.9529411765, alpha: 0.5))

    /// 默认界面背景色，类似 Grouped 类型的列表的背景
    @objc static let themeBackgroundColor: UIColor = UIColor.dynamicColor(#colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1), darkColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))

    /// 默认的cell背景色，主要用于设置页
    @objc static let themeCellBackgroundColor: UIColor = UIColor.dynamicColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), darkColor: #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.1215686275, alpha: 1))

    /// item背景色，主要用于非设置页 （目前是纯白纯黑）
    @objc static let themeItemBackgroundColor: UIColor = UIColor.dynamicColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), darkColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))

    /// Cell选中颜色，不知道为啥这个颜色不管是否暗黑模式，都是第一个颜色生效
    @objc static let themeCellSelectedColor: UIColor = UIColor.dynamicColor(#colorLiteral(red: 0.4901960784, green: 0.4901960784, blue: 0.4901960784, alpha: 0.1584706763), darkColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1639554794))

    /// 最深的文字颜色，可用于标题或者输入框文字
    @objc static let themeTextColor: UIColor = UIColor.dynamicColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), darkColor: #colorLiteral(red: 0.8549019608, green: 0.862745098, blue: 0.8784313725, alpha: 0.8041523973))

    /// 主要内容的文字颜色，颜色不是很深，例如列表的 textLabel
    @objc static let themeMainTextColor: UIColor = UIColor.dynamicColor(#colorLiteral(red: 0.4666666667, green: 0.4666666667, blue: 0.4666666667, alpha: 1), darkColor: #colorLiteral(red: 0.4666666667, green: 0.4666666667, blue: 0.4666666667, alpha: 1))

    /// 界面上一些附属说明的小字颜色
    @objc static let themeDescriptionTextColor: UIColor = UIColor.dynamicColor(#colorLiteral(red: 0.6, green: 0.6274509804, blue: 0.6666666667, alpha: 1), darkColor: #colorLiteral(red: 0.462745098, green: 0.4705882353, blue: 0.4862745098, alpha: 1))

    /// 输入框 placeholder 的颜色
    @objc static let themePlaceholderColor: UIColor = UIColor.dynamicColor(#colorLiteral(red: 0.768627451, green: 0.7843137255, blue: 0.8156862745, alpha: 1), darkColor: #colorLiteral(red: 0.3058823529, green: 0.3137254902, blue: 0.3294117647, alpha: 1))

    /// 分隔线颜色，例如 tableViewSeparator
    @objc static let themeSeparatorColor: UIColor = UIColor.dynamicColor(#colorLiteral(red: 0.8705882353, green: 0.8784313725, blue: 0.8862745098, alpha: 1), darkColor: #colorLiteral(red: 0.1803921569, green: 0.1960784314, blue: 0.2117647059, alpha: 1))

    /// 导航栏上的按钮和标题颜色
    @objc static let themeNavigationBarTitleColor: UIColor = UIColor.dynamicColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), darkColor: #colorLiteral(red: 0.8549019608, green: 0.862745098, blue: 0.8784313725, alpha: 1))

    /// 一些错误提示的颜色，比如删除
    @objc static let themeWarnningColor: UIColor = UIColor.dynamicColor(#colorLiteral(red: 1, green: 0.2588235294, blue: 0.1333333333, alpha: 1), darkColor: #colorLiteral(red: 1, green: 0.2588235294, blue: 0.1333333333, alpha: 1))

    /// 超级会员的主题色，土豪金
    @objc static let themeSuperVipTintColor: UIColor = UIColor.dynamicColor(#colorLiteral(red: 0.7098039216, green: 0.5333333333, blue: 0.3921568627, alpha: 1), darkColor: #colorLiteral(red: 0.7098039216, green: 0.5333333333, blue: 0.3921568627, alpha: 1))

    /// 蒙层的颜色，比如非全屏窗口弹出时，Mask背景颜色
    @objc static let themeMaskBackgroundColor: UIColor = UIColor.dynamicColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.403425285), darkColor: #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.4041887215))

    /// Tips的背景色. 比如小蓝条. 未备份提示条.
    @objc static let themeTipsBackgroundColor: UIColor = UIColor.dynamicColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), darkColor: #colorLiteral(red: 0.1607843137, green: 0.5019607843, blue: 1, alpha: 0.2001016695))

    /// 导航条背景色
    @objc static let themeNavBarBackgroundColor: UIColor = UIColor.dynamicColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), darkColor: #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.1215686275, alpha: 0.8))

    /// 导航条半透明背景色 (translucent)
    @objc static let themeNavBarTranslucentColor: UIColor = UIColor.dynamicColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), darkColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8))

    /// Toast的背景色. 比如删除成功.
    @objc static let themeToastBackgroundColor: UIColor = UIColor.dynamicColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), darkColor: #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1))

    /// Toast的文字颜色.
    @objc static let themeToastTextColor: UIColor = UIColor.dynamicColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), darkColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))

    /// 大导航条的背景色动画专用.
    @objc static let themeLargeTitleBgColor: UIColor = UIColor.dynamicColor(.clear, darkColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))

    /// 分享弹窗的文字颜色.
    @objc static let themeAlertTextColor: UIColor = UIColor.dynamicColor( #colorLiteral(red: 0.3747478724, green: 0.3747574091, blue: 0.3747522831, alpha: 1), darkColor: #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1))

    /// 后续用下面的方式实现动态颜色，QMUI的会造成其他影响
    @objc static func dynamicColor(_ lightColor: UIColor, darkColor: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (trait) -> UIColor in
                if trait.userInterfaceStyle == .dark {
                    return darkColor
                } else {
                    return lightColor
                }
            }
        } else {
            return lightColor
        }
    }

    /// 获取相反的颜色，alpha不变
    var adverseColor: UIColor {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        if getRed(&r, green: &g, blue: &b, alpha: &a) {
            return UIColor(red: 1 - r, green: 1 - g, blue: 1 - b, alpha: a)
        }

        var w: CGFloat = 0
        if getWhite(&w, alpha: &a) {
            return UIColor(white: 1 - w, alpha: a)
        }

        return self
    }

    func toRGBA() -> Int {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        guard getRed(&r, green: &g, blue: &b, alpha: &a) == false else {
            return (Int)(r * 255) << 24 | (Int)(g * 255) << 16 | (Int)(b * 255) << 8 | (Int)(a * 255) << 0
        }

        var w: CGFloat = 0
        guard getWhite(&w, alpha: &a) == false else {
            return (Int)(w * 255) << 24 | (Int)(w * 255) << 16 | (Int)(w * 255) << 8 | (Int)(a * 255) << 0
        }

        return 0
    }
}
