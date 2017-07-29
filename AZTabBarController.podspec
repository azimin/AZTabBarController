Pod::Spec.new do |s|
  s.name         = "AZTabBarController"
  s.version      = "1.0.1"
  s.summary      = "Framework that helps you to work with custom tab bar controller."
  s.description  = <<-DESC
                    With this framework can easily work with custom views of default tab bar controller.
                   DESC
  s.homepage     = "https://github.com/azimin/AZTabBarController"
  s.license      = "MIT"
  s.author             = { "Alexander Zimin" => "azimin@me.com" }

  s.ios.deployment_target = '9.0'
  s.source   = {
    :git => 'https://github.com/azimin/AZTabBarController.git',
    :tag => s.version
  }
  s.source_files  = 'Source/*.swift'
end
