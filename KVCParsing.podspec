Pod::Spec.new do |s|

  s.name         = "KVCParsing"
  s.version      = "0.0.1"
  s.summary      = "Easy JSON parsing using the built-in Key Value Coding (KVC) layer."

  s.description  = <<-DESC
                   Parse and set your JSON objects to objective-C objects using cocoa Key-Value-Coding!
				   
				   This category sets a minimalist set of methods to map the JSON keys into class properties and parse and set your JSON objects into NSObjects subclasses. Easy and fast!
                   DESC

  s.homepage     = "https://github.com/mobilejazz/KVCParsing"
  s.license      = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.author             = { "Joan Martin" => "vilanovi@gmail.com" }
  s.social_media_url = "http://twitter.com/joan_mh"
  s.platform     = :ios
  s.source       = { :git => "https://github.com/mobilejazz/KVCParsing.git", :tag => "0.0.1" }
  s.source_files = 'NSObject+KVCParsing.{h,m}'
  s.framework  = 'Foundation'
  s.requires_arc = true
  
end