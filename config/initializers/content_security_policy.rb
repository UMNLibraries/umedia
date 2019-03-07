# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy
# For further information see the following documentation
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy

# Rails.application.config.content_security_policy do |policy|
#   policy.default_src :self, :https
#   policy.font_src    :self, :https, :data
#   policy.img_src     :self, :https, :data
#   policy.object_src  :none
#   policy.script_src  :self, :https
#   policy.style_src   :self, :https

#   # Specify URI for violation reports
#   # policy.report_uri "/csp-violation-report-endpoint"
# end

# If you are using UJS then enable automatic nonce generation
# Rails.application.config.content_security_policy_nonce_generator = -> request { SecureRandom.base64(16) }

# Report CSP violations to a specified URI
# For further information see the following documentation:
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy-Report-Only
# Rails.application.config.content_security_policy_report_only = true


Rails.application.config.content_security_policy do |policy|
  policy.default_src :self, :https, :blob
  policy.font_src    :self, :https, :data, 'fonts.googleapis.com', 'cdnapi.kaltura.com', 'fonts.gstatic.com'
  policy.img_src     :self, :https, :data, ENV['UMEDIA_NAILER_CDN_URI'], 'www.lib.umn.edu', 'cfvod.kaltura.com', 'http://www.google-analytics.com', 'd1rxd8nozvj6aj.cloudfront.net', 'www.googletagmanager.com'
  policy.object_src  :self, 'cdm16022.contentdm.oclc.org', 'cdnapisec.kaltura.com', 'cdnapi.kaltura.com', 'cfvod.kaltura.com'
  policy.script_src  :self, :https, :unsafe_inline, :unsafe_eval, 'cdnapi.kaltura.com', 'google-analytics.com', 'www.google-analytics.com', 'localhost:3000', 'cdnsecakmi.kaltura.com'
  policy.style_src   :self, :https, :unsafe_inline, 'fonts.googleapis.com'
  policy.connect_src :self, :https, 'cdm16022.contentdm.oclc.org', 'http://0.0.0.0:3035', 'ws://0.0.0.0:3035'
  policy.worker_src  :self, :blob
end