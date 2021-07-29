### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 1907ec31-4b3f-4db6-a42f-fffb3b722d7e
using Dates, Random, Statistics

# ╔═╡ 0c9c629c-cb43-4fa7-8322-0b47718f2a9a
using Plots

# ╔═╡ af508570-b20f-4dd3-a995-36c79fc41823
using PlutoUI, PlutoTeachingTools, PlutoTest

# ╔═╡ 27667e0a-8ebc-4397-8ac3-33a0f19f6987
md"""
#  Astro 528, Lab 1, Exercise 2
## Introduction to Julia & Floating Point Arithmetic
"""

# ╔═╡ 1f304a1e-935c-4ccc-8331-6f389ae3c7b2
md"""
## Calling Functions
A key principle of writing code for non-trivial tasks is to organize one's code into many small functions, each of which do one thing (hopefully well).  High-level languages typically come with numerous functions that allow developers to accomplish common tasks without reinventing the wheel.  For example, the function `sqrt(x)` computes the square root of `x`.  
"""

# ╔═╡ 4697b219-94a8-4053-9ab6-35875c05b55c
sqrt(4)

# ╔═╡ 9ad35a1b-3cc1-475a-afd6-8f340a86cdd0
md"""
## Using Packages
The Julia language includes many powerful features.  While many of the most commonly used functions and macros are available by default (such as `sqrt` above), other functions are only avaliable if you "import" a module.  For the first part of this exercise, we'll be using the Dates, Random and Statistics modules.  (The Dates, Random, and Statistics are part of Julia's standard library, a set of modules that are distributed with Julia.)

To be able to access functions in a  module, you execute `import MyModule` and then execute `MyModule.fn(x)` to call a function named `fn` with parameter `x`.
Alternatively, `using MyModule` will import all the functions that the Module module has specified for being "exported" into the current namespace.  Basically, this means you don't have to write `MyModule.` before every call to a function provided by `MyModule.`  Sometimes that is very convenient.  Other times that risks creating confusion about which module is being reference.
"""

# ╔═╡ 60dc2204-db4f-4038-8158-d0694dd720ba
md"""
The first time you execute any command in Julia (or start up a notebook), you'll notice a delay while the Julia kernel starts.  Then, the first time you import a module, Julia will parse the code in the module and compile some functions.  The next you import the same module it will be faster, as it won't need to reparse and recompile some of that module's code (as long as the module hasn't changed, e.g., you modify the module's code directly or due to the package being updated).
"""

# ╔═╡ f16fa36b-9bed-4a37-a424-a56c717eaf9a

md"""
Next, I'd like to compute the corresponding [Julian date](https://en.wikipedia.org/wiki/Julian_day).  The `Dates` module provides a function, `datetime2julian` to do that for us.  Let's check how to call that function.
"""

# ╔═╡ de8df98a-48ce-4f6f-b725-880dfaf445b9
Docs.doc(datetime2julian)

# ╔═╡ 71829343-22e9-4f5f-8c54-afd4dffa826a

md"""
We see that the `datetime2julian` function takes a single input parameter of *type* `DateTime` object (provided by the `Dates` module) and returns a variable of type `Float64`.  
How do we make a `DateTime` object?   
Pluto offers a convenient way to view the documentation for a function (or type, module, etc.).  Click on the `DateTime` in the cell below and then open the *Live Docs* panel (probably in the bottom right of your browser). 
"""



# ╔═╡ a1699fca-90ec-418b-a675-3982dd4c11ff
DateTime;

# ╔═╡ 838f871a-2346-4d27-a6a1-1705c9b3b833

md"""
We see that there are several different *constructors* to construct a DateTime object.  We'll pick one below.
"""

# ╔═╡ 7c0b516d-4e98-452e-8203-7d5988631af6
sept1_2021 = DateTime(2021, 09, 1) 

# ╔═╡ 8b757575-9b7e-4154-8222-d024cb62f08f
jd_sept1_2021 = datetime2julian(sept1_2021)

# ╔═╡ 29ab9da1-2130-4ea1-aa4d-af08f8011bd0
md"""
It's often good to double check the return type of a function you call to make sure it's what you expected.  For functions in Base Julia, this can usually be looked up in the function documentation, either in the [Julia manual](https://docs.julialang.org/en/v1/) or using the Live Docs feature of Pluto.  If you want to check a variable's type, the `typeof` function is quite useful."""

# ╔═╡ 9f4c6a89-754d-4dee-813f-b2d902439ea1
typeof(jd_sept1_2021)

# ╔═╡ 98861118-c1c1-48d3-bb7b-1dc8f8e52604
md"""
## Writing Functions
It will be very useful to write and organize your code as functions.  I strongly recommend you develop a habit of writing code in the form of functions.  A good rule of thumb is that each function should do one specific thing.  Another rule of thumb is to try to keep each function to no more than one page of paper.  While the code for most functions is considerably smaller, but sometimes a hard scientific problem demands a longer function.  Often, after writing a complex function, one can refactor the code into multiple smaller functions, resulting in code that is easier to read, debug, maintain and optimize.  Julia provides multiple syntaxes for writing functions, [as described in the Julia manual](https://docs.julialang.org/en/v1/manual/functions/index.html). (I suggest stopping before the subsection on "Operators Are Functions" for now.)
"""

# ╔═╡ 65190391-e0fc-4db0-8fdd-092bcd58a588
md"""
### Example Function
Consider an astronomer analyzing data from a large survey or simulation.  A common task is to compute the mean value ($m$) and sample variance ($s^2$) of a data set ($y_i$) with $i=1...N$.  The data might be of observations of some quantity or the results of performing a Monte Carlo integration.  In principle, this seems very simple.  In practice, floating point arithmetic can result in some suprising behavior.  In this example, you will investigate some of the potential complications of performing even basic mathematical calculations.
"""

# ╔═╡ c9b2756d-46cf-43a1-81a7-2aecf50fd69e
md"""
### Generate an array of simulated data using the following function:
"""

# ╔═╡ 6cc68a61-2c5a-4870-848d-122ac388daf1
"Generate a reproducible sample of N random variables from a Normal distribution with specified true mean."
function generate_sample(N::Integer, true_mean = 0.0)
   Random.seed!(42) # reseed the pseudo-random number generator
                    # so that results will be reproducible
   sample = true_mean .+ randn(N)
   return sample
end;

# ╔═╡ 441d3823-5003-4e48-b24f-ba09e10735ff
md"""
First, let's review the code in the cell above.  The first line is a "docstring", it describes what the function below does
both for developers reading the code and for users who might get the
same information from Pluto's LiveDocs featuore or a website with documentation automatically extracted from the package's docstrings (using the Documenter.jl package and a GitHub Action).

The rest of the cell defines a function that takes two input parameters and returns a 1-d array of random variables.
The first parameter (`N`) is required and must be some form of an integer.
The second parameter (`true_mean`) could have any type and has a default value of zero.

Each time the function is called, it will begin by seeding a pseudo-random number generator with the value 42.
This is important so that results will be reproducible when run multiple times.
The function `randn` returns a 1-d array of standard random variables (i.e.,
drawn from a normal distribution with zero mean and unit variance) drawn
using Julia's default pseudo-random number generator.
Then the function returns the variable `sample`.

When you execute the code block above, julia parses the function, but does not compile or execute the code.  That will only happen once the function is called.  Since the last line of the cell is the end of the function, the output of the cell is the function.  By ending the line with a `;`, we tell Julia not to display the output.  Now let's try out using this function.
"""

# ╔═╡ 1d44aa99-26b1-47cd-9d19-64f4d0daf0fc
generate_sample(10, jd_sept1_2021)

# ╔═╡ 66a5de37-ff4c-40f6-99fc-624ca571b881
md"""The above code calls the function generate_sample, asking it to compute 10
random variables with true mean equal to the julian date for September 1, 2021.  The output will be a list of floating point numbers enclosed in square brackets to denote that it's a vector, which is equivalent to a 1-dimensional array.

Look at the results above.  Are the output consistent with your expectations?  (If not, then try changing the inputs to `generate_sample` to see what happens.)   Write your responce as Markdown text in the cell below and store the result as a variable named `response_1a`.
"""

# ╔═╡ ca9cf926-0102-4d89-875d-8c86ec841794
response_1a = md"""
INSERT RESPONSE
"""

# ╔═╡ b4d6143c-42ad-460d-8af3-a36dae1a8879
md"""
### Broadcasting
Look more closely at the function `generate_sample` above.
Note the syntax `.+` that tells julia the programmer wants to "broadcast" the scalar `true_mean` to have the same dimensions as the result of `randn(...)`.  What do you think would happen if you replaced this with `true_mean+randn(N)`?  Try it. How does the behavior compare to what you expected?

Restore the code in `generate_sample` and execute the cell again, so the
rest of the lab works as intended.

b. What is the advantage of julia having different syntax for arithmetic on variables with compatible dimensions from arithmetic on variables with different dimensions?
"""

# ╔═╡ 8c2cddbf-3a02-4969-952e-4d76ca23f95b
response_1b = md"""
INSERT RESPONSE
"""

# ╔═╡ 61503eb8-8a70-4ff7-b5bb-0a73c501d6c7
md"""
### Calculating basic summary statistics
Now, we're going to generate a much larger sample of numbers and compute their
mean and standard deviations using multiple different methods.  You will compare the results.  The goal is to help you to understand when floating point arithmetic is likely to be problematic, so you can anticipate potential pitfalls that might affect your own research.
"""

# ╔═╡ ba1bac88-5b7d-4b21-991e-948fb00fc2bb
num_obs = 100

# ╔═╡ 3cb23c2a-2611-47e6-9ee5-4d1d4f0a84dc
begin
	y = generate_sample(num_obs, jd_sept1_2021)
	(μ = mean(y), σ = std(y))
end

# ╔═╡ 32831892-6da7-4f85-80ff-73c60a638382
md"""The cell above assigns multiple variables.  When writing Pluto notebooks, any cell that assigns multiple variables must be wrapped inside a `begin`...`end` block (or split into multiple cells).  Note that this is different from Jupyter notebooks.   The final line calls the functions `mean` and `std` (that were exported by the Statistics package) to compute the mean and standard deviation of our sample.  
"""

# ╔═╡ a4a9b516-5473-478e-a390-9e4f715310eb
tip(md"Note the cell above returns a [`NamedTuple`](https://docs.julialang.org/en/v1/base/base/#Core.NamedTuple) that contains two Float64's.  Naming the two elements of the [`Tuple`](https://docs.julialang.org/en/v1/manual/types/#Tuple-Types) can be useful for preventing silly mistakes when order is the only way to distinguish the two numbers.  
")

# ╔═╡ a6cfeba5-d7c7-4493-aeae-379569932ef0
tip(md"Julia allows unicode characters for variable and function names.  This can be very useful for mathematical work.  However, some programs don't display unicode characters correctly.")

# ╔═╡ 37b12cb7-377b-48ba-b3ff-2457aa2c44a9
md"""
## Finite precision arithmetic

By default, Julia uses 64 bits of memory to store each floating point value.  Often this is referred to as "double precission" (for historical reasons, although technically this is machine dependent and thus less precise) to differentiate it from "single precission" floating point values typically stored with 32 bits.  To explore the effects of floating point arithmetic, let us convert the array of y values into arrays of floating point values that use fewer bits to store each value using the following code."""

# ╔═╡ 691632b7-3435-4c0d-aff4-3bdc87d77e7b
y_32bit = Float32.(y)

# ╔═╡ 84f0ce6c-9ae0-4016-91e2-d436d4385366
md"Using the same mean and std function as before, compute (and report) the sample mean and sample variance for each of these arrays.  Compare the results by subtracting each of the results computed using Float64's and Float32's"

# ╔═╡ 5bcf3076-f31b-47e8-8297-8cf406ff71ab
m_64bit = mean(y)

# ╔═╡ da5572db-5df8-4753-876f-e1b3a186f8a8
m_32bit = mean(y_32bit)

# ╔═╡ 0f7fb357-e4db-41bd-a24f-e156fcb9016a
Δm = m_64bit - m_32bit

# ╔═╡ 2ca37a14-1e12-41ab-b85a-b8d6e9a28ab6
s_64bit = std(y)

# ╔═╡ 217e0561-9724-4fd2-ab8c-e19d767ed305
s_32bit = std(y_32bit)

# ╔═╡ ca8166f2-fd5b-4915-b856-c1d32a3cd5ee
Δs = s_64bit - s_32bit

# ╔═╡ 1313e06f-4e28-402c-b29f-04d97cca66c1
md"c. How large are the differences?  Are they significant relative to the true values?  Why is the difference for one quantity a larger fraction of its true value than the other?"

# ╔═╡ fe4601cb-0cc3-4ac1-ae18-aa5fc7c35bb5
response_1c = md"""
INSERT RESPONSE
"""

# ╔═╡ 731f047f-0f26-4ab7-8810-398659642b0c
md"""
Change the value of the variable `num_obs` defined in a cell above to smaller and larger values.  
How does the mangitude of the differnces depend on the number of observation dates?"""

# ╔═╡ 29637138-4260-4fba-9258-dfa62c214088
response_1d = md"""
INSERT RESPONSE
"""

# ╔═╡ fd31f33f-641c-47a1-9ad8-fbfb728959c2
md"e. What lessons does this exercise illustrate that could be important when writing similar code for your research?"

# ╔═╡ 6347a9de-1795-4980-be61-ec83f7b6c95a
response_1e = md"""
INSERT RESPONSE
"""

# ╔═╡ e0f22e5f-ce24-4d78-8b21-d5ba9b31d536
md"""
### Computing Variances

Next, you will compute the variance of the above data using multiple algorithms and compare their relative merits.  Algebraically, the sample mean is calculated via
$m = 1/N \times \sum_{i=1}^{N} y_i$ and the sample variance can be written two ways
$$s^2 = 1/(N-1) \times \sum_{i=1}^N (y_i-m)^2 = 1/(N-1)  \times \left[ \left( \sum_{i=1}^N y_i^2 \right) - N m^2 \right]$$.
In this exercise, you will consider how to calculate the sample variance accurately and efficiently.  First, start to try writing a function yourself.  When you're ready for some help, you can hover your mouse over the following tip boxes.  
The example in the first hint box demonstrates how to write a function with a simple for loop and how to access elements of an array in Julia.  The second hint box demonstrates using a two function calls.
"""

# ╔═╡ 610f1c19-a2ea-40b1-9faa-d47ed60d17b1
hint(md"""
```julia
"Calculate mean value of an array using a simple for loop."
function mean_demo_verbose(y::Array)  # the syntax ::Array specifies that this function can only be applied if argument is an array.
   n = length(y)              # get the number of elements in the array y
   sum = zero(first(y))       # set sum to zero.  Using zero(first(y)) makes sum have the same data type as the first element of y
   for i in 1:n               # In Julia and Fortran, arrays start a 1, not 0 (like in C arrays and Python lists)
      sum += y[i]             # Short-hand for sum += sum + y[i]
   end
   return sum/n               # return isn't necessary since functions return the last value by default
```
""")

# ╔═╡ 0b768a24-e97a-47e8-925f-b9e75601ceae
hint(md"""
The above could also be written more succinctly as
```julia
"Calculate mean value of an array using sum and length functions."
mean_demo_concise(y::Array) = sum(y)/length(y);
``` 
Indeed, Julia's function `Statistics.mean()` that is written almost identically to this.
""")	

# ╔═╡ c337d59a-cb1c-4542-ae16-830bf8a2afc5
md"""a.  Write a function named `var_one_pass` that takes inputs similar to `mean_demo_verbose` and provides a one-pass algorithm to calculate the variance using a single loop."""

# ╔═╡ 4ab6efe2-271c-4574-898e-ce0817fc5033
# INSERT CODE for var_one_pass

# ╔═╡ 72474fca-4bc7-471e-9116-c48023f147dd
md"""
Your code should pass the following tests.  If it doesn't, fix your code so it does.
"""

# ╔═╡ 47104686-c7f2-44c1-be4c-7bb2497aafbf
@test @isdefined var_one_pass

# ╔═╡ 51ced48f-0aab-47fd-ab59-7b0acea6097a
@test length(methods(var_one_pass,[Array])) >= 1

# ╔═╡ 192e6360-5eba-4a4d-b203-363caba8af64
@test var_one_pass(ones(10)) ≈ 0

# ╔═╡ a83d07b9-d7b7-4274-929a-9a3474e44f08
@test var_one_pass([0,1,2,3,4,5,6,7,8,9,10]) ≈ 11

# ╔═╡ 723c95f7-b751-490d-968a-fe15559416dd
if !@isdefined(var_one_pass)
   func_not_defined(:var_one_pass)
else
	let
		if length(methods(var_one_pass,[Array])) >= 1 &&
			var_one_pass(ones(10)) ≈ 0 &&
		 	var_one_pass([0,1,2,3,4,5,6,7,8,9,10]) ≈ 11
			correct()
		else
			keep_working()	
		end
	end
end

# ╔═╡ 58d0e74a-d4f6-4aab-97aa-18d305e888e1
md"""b.  Write a function named `var_two_pass` take takes input similar to `mean_demo_verbose` and provides a two-pass algorithm to calculate the variance more accurately than the one pass algoritihm by using two loops over the $y_i$'s."""

# ╔═╡ 86a442a6-fb6e-45c7-9ab9-83aee71b028c
# INSERT CODE for var_two_pass

# ╔═╡ d7e3e30e-e46c-498f-8ec3-0ba403e03f15
if !@isdefined(var_two_pass)
   func_not_defined(:var_two_pass)
else
	let
		if length(methods(var_two_pass,[Array])) >= 1 &&
			var_two_pass(ones(10)) ≈ 0 &&
		 	var_two_pass([0,1,2,3,4,5,6,7,8,9,10]) ≈ 11
			correct()
		else
			keep_working()	
		end
	end
end

# ╔═╡ 398433fa-69a1-497b-8248-041a180596e0
md"""
### Visualizing the Results
Now, we'd like to compare the results of the two algorithms.  It will be helpful to visualize the difference as a function of the number of samples.  Therefore, we'll make a function to generate a random data set with `N` samples and a specified `true_mean` for the distribution the samples are drawn from.  Here `true_mean` is an optional, named arguement that defaults to zero.  
"""

# ╔═╡ 8b3572b8-e571-43b7-ab45-68eabecace69
function compare_var_calcs(N::Integer, true_mean::Real = 0.0)
	@assert N > 2
	@assert !isnan(true_mean)
	@assert !isinf(true_mean)
	input_data = generate_sample(N,true_mean)
	Δvar = abs(var_one_pass(input_data) - var_two_pass(input_data))
end;

# ╔═╡ 43f717de-f5c8-43b5-9229-254b9cb89ca7
md"To make Plots we'll import the `Plots` package.  (If you're interested, you can click the eyeball to the left of the plot cells to see the plotting code.)"

# ╔═╡ bfca0183-ef43-4858-8305-2e669ba14d94
md"""If you suceeded above, then Pluto will soon display a plot showing the absolute value of the difference between the two variance estimates below as a function of the number of observation dates in the sample.  First, make a prediction for what you expect such a plot to look like. """

# ╔═╡ 76cd6fbe-9be4-4e29-a3e9-4fac87d1a0c8
md"Once you've made your prediction, click this box: $(@bind ready_to_plot CheckBox())"

# ╔═╡ 119e51ef-ed7b-4f9b-b7dd-67ae70bf934a
if ready_to_plot
	local N_list = [2^n for n in 2:20]
	local plt = plot()
	local true_mean = jd_sept1_2021
	for i in 1:8
		scatter!(plt,N_list, compare_var_calcs.(N_list,true_mean), x_scale=:log10, legend=:none)
	end
	xlabel!(plt,"Number of observation dates")
	ylabel!(plt,"|Δ Estimated Sample Var| (days²)")
	title!(plt,"Sample mean = $true_mean (Static Plot)")
end

# ╔═╡ 65ef6abf-460d-49ac-80e1-1ecc1d0250dd
md"""
### Pluto: A **Reactive** Notebook Experience
Some of you may have experience using Jupyter notebooks.  Indeed, Jupyter notebooks are a useful and commonly used for small Astronomy and Data Science projects.  One big disadvantage of Jupyter notebooks is that the notebook doesn't provide a complete description of the kernel state.  That's a fancy way of saying that you can run cells out of order, or change a cell and not recalculate something that depended on the results of that cell.  It's suprisingly easy to confuse yourself.  Indeed, last time Astro 528 was offered, we used Jupyter notebooks for nearly all the assignments.  When students encountered trouble, the most common advice they got was "Restart your notebook and step through the notebook, one cell at a time until you find where it breaks."  In contrast, Pluto keeps track of all dependancies across cells.  When you update a cell, it recalculates all the cells that depend on it!  

Pluto can also be useful for making interactive visualizations.  In the example below, we'll make a plot that depends on a variable `true_mean_plt` defined below.  When you change the value of `true_mean_plt`, the plots below should automatically update itself.  Try setting it to a value of 10 or 100 times larger or smaller and observed how the difference in the estimates of the sample standard deviation change.
"""

# ╔═╡ a802faec-6745-4f9d-820a-bb8c1aa25fc1
true_mean_plt = jd_sept1_2021

# ╔═╡ a9b3f568-c421-409f-9fcb-1f9b4b8e0345
if @isdefined var_one_pass
	local N_list = [2^n for n in 2:20]
	local plt = plot()
	for i in 1:8
		scatter!(plt,N_list, compare_var_calcs.(N_list,true_mean_plt), x_scale=:log10, legend=:none)
	end
	xlabel!(plt,"Number of observation dates")
	ylabel!(plt,"|Δ Estimated Sample Var| (days²)")
	title!(plt,"Sample mean = $true_mean_plt")
end

# ╔═╡ d470aea9-b69e-4f02-bbaf-4d61cb5244b9
md"c.  Compare the accuracy of the results using data sets of different sizes and values of the true sample mean.   Under what conditions do they give results that differ by an ammount that is potentially scientifically significant?"

# ╔═╡ 10dca248-2004-4719-9e30-eb3025da0513
response_2c = md"""
INSERT RESPONSE
"""

# ╔═╡ 66d9bc94-3e61-41e8-a81d-88e307d97653
md"d.  What considerations would affect the decision of whether to use the one-pass algorithm or the two-pass algorithm?"

# ╔═╡ c63db04d-5fc8-4bee-8594-5d033b2f7a09
response_2d = md"""
INSERT RESPONSE
"""

# ╔═╡ f0c73fc1-8da9-4579-a369-a3c907fc56f4
md"e.  Consider the online 1-pass algorithm below for calculating the sample variance given below and then compare its results to the other algorithms for different data sets."

# ╔═╡ 1b7665b7-c25e-46ac-bcad-f4b8d0607693
"Compute the sample variance of an array using an online 1-pass algorithm"
function var_online(y::Array)
  n = length(y)
  sum1 = zero(first(y))
  mean = zero(first(y))
  M2 = zero(first(y))
  for i in 1:n
 	diff_by_i = (y[i]-mean)/i
 	mean += diff_by_i
 	M2 += (i-1)*diff_by_i^2+(y[i]-mean)^2
  end
  variance = M2/(n-1)
end;

# ╔═╡ de78cc1c-444e-4308-adb5-d93afdc57682
function compare_var_calcs_online(N::Integer, true_mean::Real = 0.0)
	input_data = generate_sample(N,true_mean)
	Δvar = abs(var_online(input_data) - var_two_pass(input_data))
end;

# ╔═╡ cd09046b-753e-4843-a4e4-3be0b0c7fb97
if (@isdefined var_one_pass) && (@isdefined var_two_pass)
	local N_list = [2^n for n in 2:20]
	local plt = plot()
	local true_mean = jd_sept1_2021
	for i in 1:8
		if i==1
			label_1 = "1-pass minus 2-pass" 
			label_online ="online minus 2-pass" 
		else
			label_1 = :none
			label_online = :none
		end
		scatter!(plt,N_list, compare_var_calcs.(N_list,true_mean), x_scale=:log10, color=:red,label=label_1, legend=:topleft)
		scatter!(plt,N_list, compare_var_calcs_online.(N_list,true_mean), x_scale=:log10,color=:green,label=label_online)
	end
	xlabel!(plt,"Number of observation dates")
	ylabel!(plt,"|Δ Estimated Sample Var| (days²)")
	title!(plt,"Sample mean = $true_mean")
	
end

# ╔═╡ 3f18862c-64e1-4e21-84a6-a0d2094448a7
response_2e = md"""
INSERT RESPONSE
"""

# ╔═╡ 3393a0a1-c202-4fb1-b752-275595303502
md"Under what circumstance would it be a good/poor choice to use?"

# ╔═╡ 64dcecf3-1561-411a-8759-a4ccb219e303
response_2f = md"""
INSERT RESPONSE
"""

# ╔═╡ 339639fc-77d8-4e88-85f3-59c7821cd01f
md"""
g.  Don't forget that we should test your functions for accuracy.  Should we expect all of these functions to return the exact same value?  How can we test functions that return floating point values?  
"""

# ╔═╡ af2bd92f-a67f-4fe3-965e-d337d57a2368
response_2g = md"""
INSERT RESPONSE
"""

# ╔═╡ a387d515-82d6-4211-8934-b5f0d3b062dc
md"""
h.  I've written some tests in 'test/test2.jl'.  Because of Pluto's reactivity, it's tricky to run a file from inside a notebook.  Instead, run `julia --project=test test/runtests2.jl` to run the code in this Pluto notebook and then the tests in 'test/test2.jl'.  First, check that your functions pass my tests.  If not, is it because your function has a bug?  If so, fix your functions.  Or is there another explanation?  
It may help to look at the source code for the tests to see what it means to have "passed".

Can you suggest additional tests for such functions?  Feel free to add them to the tests in 'test/test2.jl' and check that your code still passes.
"""

# ╔═╡ a11ffb3d-310f-4e28-b8f2-724aab7006a0
response_2h = md"""
INSERT RESPONSE
"""

# ╔═╡ b760fedd-41ea-4784-845f-ede0163c0d12
md"## Helper Code"

# ╔═╡ bfdd8ecf-5f05-4056-a9d8-f3404774ff52
TableOfContents()

# ╔═╡ a81ef0f8-4a54-4898-bca7-7399c678f097
function keep_working_if_var_contains_substr(var::Symbol,substr::String)
   if !@isdefined(var)
        var_not_defined(var)
   else
        PlutoTeachingTools.keep_working_if_var_contains_substr(var,eval(var),substr)
   end
end

# ╔═╡ 2ff13ed5-67e6-4f27-8097-c08cd5e84f42
keep_working_if_var_contains_substr(:response_1a,"INSERT RESPONSE")

# ╔═╡ 5f84a3cc-dab6-4ad0-9644-7ea803f43475
keep_working_if_var_contains_substr(:response_1b,"INSERT RESPONSE")

# ╔═╡ a200eb3c-7041-47e4-89d2-d077dccc18c2
keep_working_if_var_contains_substr(:response_1c,"INSERT RESPONSE")

# ╔═╡ 8588be85-c656-4239-a2f8-f0535d15e55e
keep_working_if_var_contains_substr(:response_1d,"INSERT RESPONSE")

# ╔═╡ ac593093-eebb-49df-9b9b-74ed388d3a2b
keep_working_if_var_contains_substr(:response_1e,"INSERT RESPONSE")

# ╔═╡ 569df89d-5039-4a63-8396-ab595811584c
keep_working_if_var_contains_substr(:response_2c,"INSERT RESPONSE")

# ╔═╡ 48d96e9d-b34b-4899-a976-a92602156981
keep_working_if_var_contains_substr(:response_2d,"INSERT RESPONSE")

# ╔═╡ 6134acc4-4b96-4001-ad49-37fd7d6e040e
keep_working_if_var_contains_substr(:response_2e,"INSERT RESPONSE")

# ╔═╡ 48a888f3-7067-4524-b818-279e3ed2ffdc
keep_working_if_var_contains_substr(:response_2f,"INSERT RESPONSE")

# ╔═╡ f362498a-fe8e-440d-afab-c817545b3144
keep_working_if_var_contains_substr(:response_2g,"INSERT RESPONSE")

# ╔═╡ 0cd929dc-f9b6-4dad-8de4-93cf4abd200e
keep_working_if_var_contains_substr(:response_2h,"INSERT RESPONSE")

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Dates = "ade2ca70-3891-5945-98fb-dc099432e06a"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoTest = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[compat]
Plots = "~1.19.3"
PlutoTeachingTools = "~0.1.2"
PlutoTest = "~0.1.0"
PlutoUI = "~0.7.9"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "84918055d15b3114ede17ac6a7182f68870c16f7"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.1"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c3598e525718abcc440f69cc6d5f60dda0a1b61e"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.6+5"

[[Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "e2f47f6d8337369411569fd45ae5753ca10394c6"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.0+6"

[[ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random", "StaticArrays"]
git-tree-sha1 = "ed268efe58512df8c7e224d2e170afd76dd6a417"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.13.0"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "dc7dedc2c2aa9faf59a55c622760a25cbefbe941"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.31.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[DataAPI]]
git-tree-sha1 = "ee400abb2298bd13bfc3df1c412ed228061a2385"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.7.0"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "4437b64df1e0adccc3e5d1adbc3ac741095e4677"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.9"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "92d8f9f208637e8d2d28c664051a00569c01493d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.1.5+1"

[[Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b3bfd02e98aedfa5cf885665493c5598c350cd2f"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.2.10+0"

[[FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "LibVPX_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "3cc57ad0a213808473eafef4845a74766242e05f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.3.1+4"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "35895cf184ceaab11fd778b4590144034a167a2f"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.1+14"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "cbd58c9deb1d304f5a245a0b7eb841a2560cfec6"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.1+5"

[[FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "dba1e8614e98949abfa60480b13653813d8f0157"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.5+0"

[[GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "9f473cdf6e2eb360c576f9822e7c765dd9d26dbc"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.58.0"

[[GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "eaf96e05a880f3db5ded5a5a8a7817ecba3c7392"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.58.0+0"

[[GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "15ff9a14b9e1218958d3530cc288cf31465d9ae2"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.3.13"

[[Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "7bf67e9a481712b3dbe9cb3dac852dc4b1162e02"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+0"

[[Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "c6a1fff2fd4b1da29d3dccaffb1e1001244d844e"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.12"

[[HypertextLiteral]]
git-tree-sha1 = "1e3ccdc7a6f7b577623028e0095479f4727d8ec1"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.8.0"

[[IniFile]]
deps = ["Test"]
git-tree-sha1 = "098e4d2c533924c921f9f9847274f2ad89e018b8"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.0"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[IterTools]]
git-tree-sha1 = "05110a2ab1fc5f932622ffea2a003221f4782c18"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.3.0"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "642a199af8b68253517b80bd3bfd17eb4e84df6e"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.3.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "81690084b6198a2e1da36fcfda16eeca9f9f24e4"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.1"

[[JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d735490ac75c5cb9f1b00d8b5509c11984dc6943"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.0+0"

[[LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[LaTeXStrings]]
git-tree-sha1 = "c7f1c695e06c01b95a67f0cd1d34994f3e7db104"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.2.1"

[[Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "a4b12a1bd2ebade87891ab7e36fdbce582301a92"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.6"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[LibVPX_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "12ee7e23fa4d18361e7c2cde8f8337d4c3101bc7"
uuid = "dd192d2f-8180-539f-9fb4-cc70b1dcf69a"
version = "1.10.0+0"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "761a393aeccd6aa92ec3515e428c26bf99575b3b"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+0"

[[Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "340e257aada13f95f98ee352d316c3bed37c8ab9"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+0"

[[Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "6a8a2a625ab0dea913aba95c11370589e0239ff0"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.6"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "4ea90bd5d3985ae1f9a908bd4500ae88921c5ce7"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.0"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NaNMath]]
git-tree-sha1 = "bfe47e760d60b82b66b61d2d44128b62e3a369fb"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.5"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7937eda4681660b4d6aeeecc2f7e1c81c8ee4e2f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+0"

[[OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "15003dcb7d8db3c6c857fda14891a539a8f2705a"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.10+0"

[[Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "c8abc88faa3f7a3950832ac5d6e690881590d6dc"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "1.1.0"

[[Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlotThemes]]
deps = ["PlotUtils", "Requires", "Statistics"]
git-tree-sha1 = "a3a964ce9dc7898193536002a6dd892b1b5a6f1d"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "2.0.1"

[[PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "501c20a63a34ac1d015d5304da0e645f42d91c9f"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.0.11"

[[Plots]]
deps = ["Base64", "Contour", "Dates", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs"]
git-tree-sha1 = "1bbbb5670223d48e124b388dee62477480e23234"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.19.3"

[[PlutoTeachingTools]]
deps = ["LaTeXStrings", "Markdown", "Random"]
git-tree-sha1 = "64fcdfc45fc046167c240ec79a1059ddf1ef5fce"
uuid = "661c6b06-c737-4d37-b85c-46df65de6f69"
version = "0.1.2"

[[PlutoTest]]
deps = ["HypertextLiteral", "InteractiveUtils", "Markdown", "Test"]
git-tree-sha1 = "3479836b31a31c29a7bac1f09d95f9c843ce1ade"
uuid = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"
version = "0.1.0"

[[PlutoUI]]
deps = ["Base64", "Dates", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "Suppressor"]
git-tree-sha1 = "44e225d5837e2a2345e69a1d1e01ac2443ff9fcb"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.9"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "ad368663a5e20dbb8d6dc2fddeefe4dae0781ae8"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+0"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[RecipesBase]]
git-tree-sha1 = "b3fb709f3c97bfc6e948be68beeecb55a0b340ae"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.1.1"

[[RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "2a7a2469ed5d94a98dea0e85c46fa653d76be0cd"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.3.4"

[[Reexport]]
git-tree-sha1 = "5f6c21241f0f655da3952fd60aa18477cf96c220"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.1.0"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "4036a3bd08ac7e968e27c203d45f5fff15020621"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.1.3"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "5b2f81eeb66bcfe379947c500aae773c85c31033"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.8"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
git-tree-sha1 = "1958272568dc176a1d881acb797beb909c785510"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.0.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "2f6792d523d7448bbe2fec99eca9218f06cc746d"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.8"

[[StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "000e168f5cc9aded17b6999a560b7c11dda69095"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.0"

[[Suppressor]]
git-tree-sha1 = "a819d77f31f83e5792a76081eee1ea6342ab8787"
uuid = "fd094767-a336-5f1f-9728-57cf17d0bbfb"
version = "0.2.0"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "8ed4a3ea724dac32670b062be3ef1c1de6773ae8"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.4.4"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll"]
git-tree-sha1 = "2839f1c1296940218e35df0bbb220f2a79686670"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.18.0+4"

[[XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "cc4bf3fdde8b7e3e9fa0351bdeedba1cf3b7f6e6"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.0+0"

[[libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "acc685bcf777b2202a904cdcb49ad34c2fa1880c"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.14.0+4"

[[libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7a5780a0d9c6864184b3a2eeeb833a0c871f00ab"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "0.1.6+4"

[[libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "c45f4e40e7aafe9d086379e5578947ec8b95a8fb"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+0"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d713c1ce4deac133e3334ee12f4adff07f81778f"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2020.7.14+2"

[[x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "487da2f8f2f0c8ee0e83f39d13037d6bbf0a45ab"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.0.0+3"

[[xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╟─27667e0a-8ebc-4397-8ac3-33a0f19f6987
# ╟─1f304a1e-935c-4ccc-8331-6f389ae3c7b2
# ╠═4697b219-94a8-4053-9ab6-35875c05b55c
# ╟─9ad35a1b-3cc1-475a-afd6-8f340a86cdd0
# ╠═1907ec31-4b3f-4db6-a42f-fffb3b722d7e
# ╟─60dc2204-db4f-4038-8158-d0694dd720ba
# ╟─f16fa36b-9bed-4a37-a424-a56c717eaf9a
# ╠═de8df98a-48ce-4f6f-b725-880dfaf445b9
# ╟─71829343-22e9-4f5f-8c54-afd4dffa826a
# ╠═a1699fca-90ec-418b-a675-3982dd4c11ff
# ╟─838f871a-2346-4d27-a6a1-1705c9b3b833
# ╠═7c0b516d-4e98-452e-8203-7d5988631af6
# ╠═8b757575-9b7e-4154-8222-d024cb62f08f
# ╟─29ab9da1-2130-4ea1-aa4d-af08f8011bd0
# ╠═9f4c6a89-754d-4dee-813f-b2d902439ea1
# ╟─98861118-c1c1-48d3-bb7b-1dc8f8e52604
# ╟─65190391-e0fc-4db0-8fdd-092bcd58a588
# ╟─c9b2756d-46cf-43a1-81a7-2aecf50fd69e
# ╠═6cc68a61-2c5a-4870-848d-122ac388daf1
# ╟─441d3823-5003-4e48-b24f-ba09e10735ff
# ╠═1d44aa99-26b1-47cd-9d19-64f4d0daf0fc
# ╟─66a5de37-ff4c-40f6-99fc-624ca571b881
# ╠═ca9cf926-0102-4d89-875d-8c86ec841794
# ╟─2ff13ed5-67e6-4f27-8097-c08cd5e84f42
# ╟─b4d6143c-42ad-460d-8af3-a36dae1a8879
# ╠═8c2cddbf-3a02-4969-952e-4d76ca23f95b
# ╟─5f84a3cc-dab6-4ad0-9644-7ea803f43475
# ╟─61503eb8-8a70-4ff7-b5bb-0a73c501d6c7
# ╠═ba1bac88-5b7d-4b21-991e-948fb00fc2bb
# ╠═3cb23c2a-2611-47e6-9ee5-4d1d4f0a84dc
# ╟─32831892-6da7-4f85-80ff-73c60a638382
# ╟─a4a9b516-5473-478e-a390-9e4f715310eb
# ╟─a6cfeba5-d7c7-4493-aeae-379569932ef0
# ╟─37b12cb7-377b-48ba-b3ff-2457aa2c44a9
# ╠═691632b7-3435-4c0d-aff4-3bdc87d77e7b
# ╟─84f0ce6c-9ae0-4016-91e2-d436d4385366
# ╠═5bcf3076-f31b-47e8-8297-8cf406ff71ab
# ╠═da5572db-5df8-4753-876f-e1b3a186f8a8
# ╠═0f7fb357-e4db-41bd-a24f-e156fcb9016a
# ╠═2ca37a14-1e12-41ab-b85a-b8d6e9a28ab6
# ╠═217e0561-9724-4fd2-ab8c-e19d767ed305
# ╠═ca8166f2-fd5b-4915-b856-c1d32a3cd5ee
# ╟─1313e06f-4e28-402c-b29f-04d97cca66c1
# ╠═fe4601cb-0cc3-4ac1-ae18-aa5fc7c35bb5
# ╠═a200eb3c-7041-47e4-89d2-d077dccc18c2
# ╟─731f047f-0f26-4ab7-8810-398659642b0c
# ╠═29637138-4260-4fba-9258-dfa62c214088
# ╠═8588be85-c656-4239-a2f8-f0535d15e55e
# ╟─fd31f33f-641c-47a1-9ad8-fbfb728959c2
# ╠═6347a9de-1795-4980-be61-ec83f7b6c95a
# ╟─ac593093-eebb-49df-9b9b-74ed388d3a2b
# ╟─e0f22e5f-ce24-4d78-8b21-d5ba9b31d536
# ╟─610f1c19-a2ea-40b1-9faa-d47ed60d17b1
# ╟─0b768a24-e97a-47e8-925f-b9e75601ceae
# ╟─c337d59a-cb1c-4542-ae16-830bf8a2afc5
# ╠═4ab6efe2-271c-4574-898e-ce0817fc5033
# ╟─72474fca-4bc7-471e-9116-c48023f147dd
# ╠═47104686-c7f2-44c1-be4c-7bb2497aafbf
# ╠═51ced48f-0aab-47fd-ab59-7b0acea6097a
# ╠═192e6360-5eba-4a4d-b203-363caba8af64
# ╠═a83d07b9-d7b7-4274-929a-9a3474e44f08
# ╟─723c95f7-b751-490d-968a-fe15559416dd
# ╟─58d0e74a-d4f6-4aab-97aa-18d305e888e1
# ╠═86a442a6-fb6e-45c7-9ab9-83aee71b028c
# ╟─d7e3e30e-e46c-498f-8ec3-0ba403e03f15
# ╟─398433fa-69a1-497b-8248-041a180596e0
# ╠═8b3572b8-e571-43b7-ab45-68eabecace69
# ╟─43f717de-f5c8-43b5-9229-254b9cb89ca7
# ╠═0c9c629c-cb43-4fa7-8322-0b47718f2a9a
# ╟─bfca0183-ef43-4858-8305-2e669ba14d94
# ╟─76cd6fbe-9be4-4e29-a3e9-4fac87d1a0c8
# ╟─119e51ef-ed7b-4f9b-b7dd-67ae70bf934a
# ╟─65ef6abf-460d-49ac-80e1-1ecc1d0250dd
# ╠═a802faec-6745-4f9d-820a-bb8c1aa25fc1
# ╟─a9b3f568-c421-409f-9fcb-1f9b4b8e0345
# ╟─d470aea9-b69e-4f02-bbaf-4d61cb5244b9
# ╠═10dca248-2004-4719-9e30-eb3025da0513
# ╟─569df89d-5039-4a63-8396-ab595811584c
# ╟─66d9bc94-3e61-41e8-a81d-88e307d97653
# ╠═c63db04d-5fc8-4bee-8594-5d033b2f7a09
# ╟─48d96e9d-b34b-4899-a976-a92602156981
# ╟─f0c73fc1-8da9-4579-a369-a3c907fc56f4
# ╠═1b7665b7-c25e-46ac-bcad-f4b8d0607693
# ╠═de78cc1c-444e-4308-adb5-d93afdc57682
# ╟─cd09046b-753e-4843-a4e4-3be0b0c7fb97
# ╠═3f18862c-64e1-4e21-84a6-a0d2094448a7
# ╟─6134acc4-4b96-4001-ad49-37fd7d6e040e
# ╟─3393a0a1-c202-4fb1-b752-275595303502
# ╠═64dcecf3-1561-411a-8759-a4ccb219e303
# ╠═48a888f3-7067-4524-b818-279e3ed2ffdc
# ╠═339639fc-77d8-4e88-85f3-59c7821cd01f
# ╠═af2bd92f-a67f-4fe3-965e-d337d57a2368
# ╟─f362498a-fe8e-440d-afab-c817545b3144
# ╟─a387d515-82d6-4211-8934-b5f0d3b062dc
# ╠═a11ffb3d-310f-4e28-b8f2-724aab7006a0
# ╟─0cd929dc-f9b6-4dad-8de4-93cf4abd200e
# ╟─b760fedd-41ea-4784-845f-ede0163c0d12
# ╠═af508570-b20f-4dd3-a995-36c79fc41823
# ╠═bfdd8ecf-5f05-4056-a9d8-f3404774ff52
# ╠═a81ef0f8-4a54-4898-bca7-7399c678f097
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
