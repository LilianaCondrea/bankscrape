require 'watir'
#`login` page.

class Login
browser = Watir::Browser.new(:chrome,'goog:chromeOptions' => {detach: true})

browser.goto("https://demo.bendigobank.com.au")
#sign in script
browser.button(:tabindex => "4", :class => "input_submit", :name => "customer_type",
  :value=>"personal").click
end
