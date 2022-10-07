Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.name         = 'OSLogger'
  spec.version      = '0.1'
  spec.summary      = 'Logger tool combind os.log and OSLog SDK frameworks. Depends on the deployment target it used one of library.'

  spec.description  = <<-DESC
  Logger tool combind os.log and OSLog SDK frameworks. Depends on the deployment target it used one of library.

  On devices with iOS 15+ logger tool stored data into device console.
  Alternative storage could be memory or file on the disk.
  It depends on the tool configurations.

  On the version 0.1 default memory is default storage.
                   DESC

  spec.homepage     = 'http://onsightteam.com/'


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.license      = 'MIT (example)'
  spec.license      = { :type => 'MIT', :text => <<-LICENSE
                        Copyright © 2022 OnSightTeam. All rights reserved.
                        LICENSE
                      }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.author             = { 'Nikolay Chaban' => 'nchaban.kh@gmail.com' }
  #spec.social_media_url   = 'https://twitter.com/OxidBurn'

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.ios.deployment_target = '13.0'
  spec.swift_version         = '5.5'


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.source       = { :git => 'https://github.com/OnSightTeam/OSLogger.git', :tag => spec.version }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.source_files = 'OSLogger/Source/**/*.swift'

end
