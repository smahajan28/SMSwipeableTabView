#
# Be sure to run `pod lib lint SMSwipeableTabView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = "SMSwipeableTabView"
s.version          = "0.1.0"
s.summary          = "Swipeable Views with Tabs (Like Android SwipeView With Tabs Layout)"
s.description      = <<-DESC
It is a custom swipeable viewcontroller library same as Android Swipe view with Tabs Layout(In Lollipop). This control contains UIPageviewController and Scrollable SegmentBar/TabBar. This type of control can be seen in Spotify app, Twitter app and in many more. User can add as many swipeable ViewController and SegmentBar Buttons. The whole control is customizable. User can easily customize the size of Button (Fixed or variable), Size, Color, Font, Height of Tabs/Segments. For more details, You can go through the example of this project.
DESC
s.homepage         = "https://github.com/smahajan28/SMSwipeableTabView"
s.license          = 'MIT'
s.author           = { "Sahil Mahajan" => "sahilrameshmahajan@gmail.com" }
s.source           = { :git => "https://github.com/smahajan28/SMSwipeableTabView.git", :tag => s.version.to_s }
s.platform         = :ios, '8.0'
s.requires_arc     = true

s.source_files     = 'Pod/Classes/**/*'
s.resource_bundles = {
'SMSwipeableTabView' => ['Pod/Assets/*.png']
}

end
