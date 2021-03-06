# need to have the capability to calculate for a year and for one month
# Build expenses from a expense language
module ProjectionRuleBuilder

  # need some way to reference income
  # maybe use visitor pattern
  # maybe execute block inside the context of an income statement  (which includes expenses and income)
  # attr_accessor :budget_builder #ref to parent, be careful here
  # maybe shadow all expense fields to make them available to blocks
   attr_accessor :rule_list
   attr_accessor :period 
   attr_accessor :start_date
   attr_accessor :end_date
   attr_accessor :ranged
   attr_accessor :range_start_date
   attr_accessor :range_end_date
   attr_accessor :one_time_date
   attr_accessor :increment
   attr_accessor :time
   
  #  #length of the projection. Could be a budget cycle, a calendar year, or a couple months
  #  attr_accessor :duration
  #  attr_accessor :cost
  #  attr_accessor :chance
  #  attr_accessor :date_type

  # def cost(tempcost)
  #    #debugger
  #    @expense_list.last.amount=tempcost
  #    #should raise an error if no expense exists
  #  end

  # at some point make = work
  # def cost=(tempcost)
  #   cost(tempcost)
  # end

  # def chance(chance)
  #    #debugger
  #    @expense_list.last.chance=chance
  #    #should raise an error if no expense exists
  #  end

  # def add_expense(name, amount=0, &block)
  #     expense = Expense.new
  #     expense.name = name
  #   expense.amount = amount
  #   expense.period = @period
  # 
  #   case @period
  #   when :one_time
  #     #debugger
  #     expense.date=@one_time_date
  #   when :incremental
  #     expense.date=@increment
  #   # when :ranged
  #   #      # fix this to create expenses per period type for the range
  #   #      expense.date=@ranged_start_date
  #   end
  #   expense.range_start_date=@range_start_date
  #   expense.range_end_date=@range_end_date
  #   expense.ranged=@ranged
  # 
  #   @expense_list.push(expense)
  #   # run block before adding that code to the expense
  #   yield if block_given?
  #   @expense_list.last.custom_code=block
  # end

  # def total
  #     @expense_list.inject(0) do |result, expense| 
  #       if expense.chance
  #         #debugger
  #         result + expense.amount.to_i * (expense.chance.to_f/100)
  #       else
  #         result + expense.amount.to_i
  #       end  
  #     end
  #   end

  # set up an incremental projection rule
  def every (date, &block)
    #debugger
    # need a way to differentiate monthly from weekly (e.g. every monday)
    # need a way to designate once a month (e.g. first monday or third monday)    @period=:incremental
    if (date == :monthly) or (date == :month)
      # need a way to reconcile incremental/monthly/duration
      #@period = :monthly
      @increment=1.month
    else
      #@period=:incremental
      @increment=date
    end
    instance_eval &block
    cleanup
  end

  def from (start_date, end_date, &block)
    #debugger
    @period=:ranged
    @ranged=true
    @range_start_date=Date.strptime(start_date, @date_type)
    @range_end_date=Date.strptime(end_date, @date_type)
    instance_eval &block
    cleanup
  end

  def on (date, &block)
    #debugger
    # something totally hosed here... need to make sure a new expense builder not created
    #  period is getting lost when the block is executed.
    @period=:one_time
    @one_time_date=Date.strptime(date, @date_type)
    instance_eval &block
    cleanup
  end

  def at (time, &block)
    #debugger
    # something totally hosed here... need to make sure a new expense builder not created
    #  period is getting lost when the block is executed.
    #@period=:one_time
    @one_time_date=Date.strptime(date, @date_type)
    @time = time #.strptime(date, time)
    instance_eval &block
    cleanup
  end

  # # dynamically define expenses
  #  def method_missing(methId, *args, &block)
  #    #debugger
  #    # maybe make more secure/easier to debug by requiring method to have 
  #    # prefix of exp_ or rev_
  #    str = methId.id2name
  #    #debugger
  #    #debugger if str == 'taxes'
  #    #need to ensure 1 variable
  #    if args.count == 0 
  #      #debugger
  #      add_expense(str)
  #      instance_eval &block
  #    elsif args.count == 1 
  #      #debugger
  #      add_expense(str, args[0], &block)
  #    end
  #    #add define method here
  #  end
  
  # replace the rule list's tasks with 
  def replace(from,to)
    #debugger
    if from == :all
      rule_list.each {|rule| rule.name = to.to_s} 
    else
      rule_list.each do |rule|
        rule.name = to.to_s if rule.name == from
      end
    end
  end
  
  # Add a rule for the projection
  def add(&block) 
    #debugger
    #@expense_list = []
    #myexp = Expense.new
    #Expenses.class_eval &block
    # need to set period to default every time a new rule is made
    @period = :monthly
    @ranged = nil
    self.instance_eval &block
    cleanup
  end
  # when a rule is done executing we need to clean up the context
  # we need to assume that when an internal block is finally done executing
  # the external calling blocks dont need the context's variables i.e. @period anymore
  def cleanup
    @period = :monthly
    @ranged = nil
    @range_start_date = nil
    @range_end_date = nil
    @one_time_date = nil
    @increment = nil
  end
  
  def load_file(filelocation="rule_list.rb")
    @period = :monthly
    @ranged = nil
    contents = File.open(filelocation, 'rb') { |f| f.read }
    self.instance_eval contents
  end   

  def initialize
	  #debugger
    #@expense_list = []
    @period = :monthly
	  @start_date = Time.now
	  @duration = 1.year # not used yet
	  @end_date = @start_date + 11.months # 1 year default
	  @date_type = '%m/%d/%Y'
  end

end