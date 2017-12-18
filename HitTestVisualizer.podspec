Pod::Spec.new do |s|

  s.name         = "HitTestVisualizer"
  s.version      = "0.0.1"
  s.summary      = "Hit-Test Visualizer for ARKit extracted as a portable framework"

  s.description  = <<-DESC
  Small util that can help visualize what's going on behind hit-test process in ARKit session
                   DESC

  s.homepage     = "https://github.com/s1ddok/HitTestVisualizer"

  s.license      = { :type => 'BSD-2', :file => 'LICENSE' }

  s.author           = { "Andrey Volodin" => "siddok@gmail.com" }
  s.social_media_url = "http://twitter.com/s1ddok"

  #  When using multiple platforms
  s.ios.deployment_target = "11.0"
  # s.osx.deployment_target = "10.11"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"
  s.source        = { :git => "https://github.com/s1ddok/HitTestVisualizer.git", :tag => "#{s.version}" }
  s.source_files  = "ARKitHitTestVisualizer/*.swift"
end
