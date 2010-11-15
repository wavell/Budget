# We need a better way to track budgets within organizations
# As expenditures roll their way up through organizations they need to be tracked
# At each phase of the roll up there needs to be a spot for calculations to be made
# We need to allow for percentage based budgets
# This in the end should be a budget framework, not a budget application.  
# This is meant to be shared with others as an example
# export to excel
# Budgeting involves a dialog between a submitter and a reviewer/approver
# One goal in budgeting is avoiding asymmetric information between the one submitting a budget
# and the one reviewing the budget for approval

class SourceOfFunds
	attr: StartDate
	attr: EndDate
	#maybe do a grant mixin
end
alias :SourceOfFunds :Grant

class BudgetObject
	attr: Name
	attr: Description
end
class Dollars
end
class Expenditures
  attr :Dollars
end
#extend number to allow for year mean budget year.  Allow budgets per year and rolling forward per year 
class Year
	#roll forward
end
#Name of bucket where money is collected
class Account
  #kind of thing the money is spent on e.g. chairs.  Maybe should be a list
	attr :BudgetObject 
	#rollup account
	attr :Account 
	attr :Dollars
end
class Organization
	attr :DefaultOrganizationParent
	attr :Name
	attr :LevelName
	# rolls up everything to this org using the strategy of this org and the orgs below it.  
	# returns money
	def rollup 
	end
	# runs calculations to see if the org is balanced.  Need  a smart way to return why not balanced
	def balance
	end
end
#A complete list of rules for determining a budget
#Can be all inclusive, per year, per org
class Budget
  def submit
  end
  def review
  end
end
#collection of schedules that make a funding distribution stragety.  e.g. default general revenu distribution
class Strategy
  #decriptive name here helps to know the manner you are assigning percentages e.g. 
  attr: Name
end
#schedule is a percentage tied to a source of funds for an org
class Schedule
  attr: Strategy
  attr: Percentage
  attr: SourceOfFunds
end
# should also be able to freely compose adhoc orgs LevelName +  _ + Name 
#  e.g. division_1  +  division_2
# and have it use their rollups
class OrgRollupStrategy
	attr: OrganizationGraph  #what orgs roll up into other orgs
	attr: OrgExclusionList  #what orgs to excluded from a rollup
end
class BudgetObjectRollupStrategy # master list or optional tie to Org or a Source of funds
	attr: BudgetObjectExclusion #exclude budget objects out of the rollup
end
class SourceOfFundRollupStrategy # master list or optional tie to Org
	attr: SourceOfFundRedirect # redirect anything coming from a source of funds to another source
end
alias :OrgRollupStrategy :RollupStrategy :EarMark, :Appropriation
#  Rollups that aren't persistantly located in the target accounts
class DerivedDollars
end
class User
end
class Submitter extend User
end
class Reviewer extend User
end
alias :Approver :Reviewer