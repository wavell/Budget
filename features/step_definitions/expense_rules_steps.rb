my = Expenses.new
Given /^I have a monthly expense of "([^"]*)" that is \$(\d+)$/ do |arg1, arg2|
   #pending # express the regexp above with the code you wish you had
   # try instance eval
  my.mybills do
	    #arg1.to_sym arg2.to_sym	 
	    telephone arg2	 
		#arg1 arg2
 end
end

When /^I ask for my total monthly expenses$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^total of the monthly expenses should be \$(\d+)$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end