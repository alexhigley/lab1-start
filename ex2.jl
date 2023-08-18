### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 1907ec31-4b3f-4db6-a42f-fffb3b722d7e
using Dates, Random, Statistics

# ╔═╡ 0c9c629c-cb43-4fa7-8322-0b47718f2a9a
using Plots

# ╔═╡ af508570-b20f-4dd3-a995-36c79fc41823
begin
	using PlutoUI, PlutoTeachingTools, PlutoTest
	eval(Meta.parse(code_for_check_type_funcs))
end

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
The Julia language includes many powerful features.  While many of the most commonly used functions and macros are available by default (such as `sqrt` above), other functions are only avaliable if you *import* a module.  For the first part of this exercise, we'll be using the Dates, Random and Statistics modules.  (The Dates, Random, and Statistics are part of Julia's standard library, a set of modules that are distributed with Julia.)

To be able to access functions in a  module, you execute `import MyModule` and then execute `MyModule.fn(x)` to call a function named `fn` with parameter `x`.
Alternatively, `using MyModule` will import all the functions that the Module module has specified should be *exported* by default.  Basically, this means you don't have to write `MyModule.` before every call to a function that `MyModule` intends for end users to call.  Often, `using` is very convenient.  For very common functions names (e.g., `mean`, `apply`) `using` risks creating confusion about which module is being reference.  In these caeses `import` provides more control of exactly which functions are loaded into the current namespace.
"""

# ╔═╡ 60dc2204-db4f-4038-8158-d0694dd720ba
md"""
The first time you execute any command in Julia (or start up a notebook), you'll notice a delay while the Julia kernel starts.  Then, the first time you import a module, Julia will parse the code in the module and compile some functions.  The next you import the same module it will be mucuh faster, as it won't need to reparse and recompile some of that module's code (as long as the module hasn't changed, e.g., you modify the module's code directly or due to the package being updated).
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
It will be very useful to write and organize your code into many small functions.  I strongly recommend you develop a habit of writing code in the form of functions.  A good rule of thumb is that each function should do one specific thing.  Another rule of thumb is to try to keep each function to no more than can fit on one page of paper (or one screen), even when it's complicated.  If nothing else, this makes it easier for humans to debug the function.  The code for most functions is considerably smaller, but sometimes a hard scientific problem demands a longer function.  Often, after writing a complex function, one can refactor the code into multiple smaller functions, resulting in code that is easier to read, debug, maintain and optimize.  Julia provides multiple syntaxes for writing functions, [as described in the Julia manual](https://docs.julialang.org/en/v1/manual/functions/index.html). (I suggest stopping before the subsection on "Operators Are Functions" for now.)
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
function generate_sample(N::Integer, true_mean = 0.0; seed::Integer = 42)
   Random.seed!(seed) # reseed the pseudo-random number generator
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
The third parameter (after the `;`) is a named parameter (i.e., you must specify the name of the parameter when calling the function, instead of just using its position).  Because it has a default value it is optional.

Each time the function is called, it will begin by seeding a pseudo-random number generator.
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
response_1a = missing  # INSERT your responces as Markdown text.

# ╔═╡ b77abd33-0214-46f4-9fde-8b38afafd224
display_msg_if_fail(check_type_isa(:response_1a,response_1a,Markdown.MD)) 

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
response_1b = missing

# ╔═╡ 5f84a3cc-dab6-4ad0-9644-7ea803f43475
display_msg_if_fail(check_type_isa(:response_1b,response_1b,Markdown.MD)) 

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
response_1c = missing

# ╔═╡ a200eb3c-7041-47e4-89d2-d077dccc18c2
display_msg_if_fail(check_type_isa(:response_1c,response_1c,Markdown.MD)) 

# ╔═╡ 731f047f-0f26-4ab7-8810-398659642b0c
md"""
Change the value of the variable `num_obs` defined in a cell above to smaller and larger values.  
How does the mangitude of the differnces depend on the number of observation dates?"""

# ╔═╡ 29637138-4260-4fba-9258-dfa62c214088
response_1d = missing

# ╔═╡ 8588be85-c656-4239-a2f8-f0535d15e55e
display_msg_if_fail(check_type_isa(:response_1d,response_1d,Markdown.MD)) 

# ╔═╡ fd31f33f-641c-47a1-9ad8-fbfb728959c2
md"e. What lessons does this exercise illustrate that could be important when writing similar code for your research?"

# ╔═╡ 6347a9de-1795-4980-be61-ec83f7b6c95a
response_1e = missing

# ╔═╡ ac593093-eebb-49df-9b9b-74ed388d3a2b
display_msg_if_fail(check_type_isa(:response_1e,response_1e,Markdown.MD)) 

# ╔═╡ e0f22e5f-ce24-4d78-8b21-d5ba9b31d536
md"""
### Computing Variances

Next, you will compute the variance of the above data using multiple algorithms and compare their relative merits.  Algebraically, the sample mean is calculated via
$m = 1/N \times \sum_{i=1}^{N} y_i$ and the sample variance can be written two ways
$$s^2 = 1/(N-1) \times \sum_{i=1}^N (y_i-m)^2$$ or 
$$s^2 =  1/(N-1)  \times \left[ \left( \sum_{i=1}^N y_i^2 \right) - N m^2 \right] = 1/(N-1)  \times \left[ \left( \sum_{i=1}^N y_i^2 \right) - \left(\sum_{i=1}^N y_i\right)^2 /N \right]$$.

In this exercise, you will consider how to calculate the sample variance accurately and efficiently.  First, you'll try writing a function yourself.  To get help with syntax, you can hover your mouse over the following tip boxes below.  
The example in the first hint box demonstrates how to write a function with a *for loop* and how to access elements of an array in Julia.  The second hint box demonstrates using a two function calls.  
"""

# ╔═╡ c337d59a-cb1c-4542-ae16-830bf8a2afc5
md"""a.  Write a function named `var_one_pass` that takes inputs similar to `mean_demo_verbose` and implements a **one-pass algorithm** to calculate the variance, reading each value of y from the computer's main memory only once.  Note that using the same element of an array repeatedly (i.e., before accessing the any other elements of the array) only counts as a single pass, since it can be reused without repeatedly copying the data from main memory."""

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
end
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

# ╔═╡ 4ab6efe2-271c-4574-898e-ce0817fc5033
function var_one_pass(y::Array)
	# INSERT CODE for var_one_pass
	return missing
end

# ╔═╡ 72474fca-4bc7-471e-9116-c48023f147dd
md"""
Your code should pass the following tests.  If it doesn't, fix your code so it does.
"""

# ╔═╡ 47104686-c7f2-44c1-be4c-7bb2497aafbf
@test @isdefined var_one_pass

# ╔═╡ 51ced48f-0aab-47fd-ab59-7b0acea6097a
@test length(methods(var_one_pass,[Array])) >= 1

# ╔═╡ 5f959c70-2a7a-47c9-b575-68c46dc4eeba


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
			!ismissing(var_one_pass(ones(10))) &&
			var_one_pass(ones(10)) ≈ 0 &&
		 	var_one_pass([0,1,2,3,4,5,6,7,8,9,10]) ≈ 11
			correct()
		else
			keep_working()	
		end
	end
end

# ╔═╡ 58d4e72a-aed5-4b8f-846e-bb63e4cc54c7
protip(md"Normally, we'd use the `Test` module for the `@test` macro.  Julia has a large set of modules and packages, that range from very basic functionality to complex science codes.  The quality also varries widely.  Several modules (like `Test`) are included in Julia standard library, so they're already installed for us.  
	
However, inside Pluto, it can be helpful to instead import `PlutoTest`, since it displays the results particularly nicely.  (It's an external package and it's still experimental, so if things break in the future, then we can revert to just using `Test`.  
	
Below, I pick one based on whether we are inside a Pluto notebook session.")

# ╔═╡ 58d0e74a-d4f6-4aab-97aa-18d305e888e1
md"""b.  Write a function named `var_two_pass` take takes input similar to `mean_demo_verbose` and provides a two-pass algorithm to calculate the variance more accurately than the one pass algoritihm by using two loops over the $y_i$'s."""

# ╔═╡ 86a442a6-fb6e-45c7-9ab9-83aee71b028c
function var_two_pass(y::Array)
	# INSERT CODE for var_two_pass
	return missing
end

# ╔═╡ d7e3e30e-e46c-498f-8ec3-0ba403e03f15
if !@isdefined(var_two_pass)
   func_not_defined(:var_two_pass)
else
	let
		if length(methods(var_two_pass,[Array])) >= 1 &&
		    !ismissing(var_two_pass(ones(10))) &&
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
md"Once you've completed the questions above and made your prediction, **click this box**: $(@bind ready_to_plot CheckBox())"

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
Some of you may have experience using Jupyter notebooks.  Indeed, Jupyter notebooks are a useful and commonly used for small Astronomy and Data Science projects.  One big disadvantage of Jupyter notebooks is that the notebook doesn't provide a complete description of the kernel state.  That's a fancy way of saying that you can run cells out of order, or change a cell and not recalculate something that depended on the results of that cell.  It's suprisingly easy to confuse yourself.  Indeed, the first time Astro 528 was offered, we used Jupyter notebooks for nearly all the assignments.  When students encountered trouble, the most common advice they got was "Restart your notebook and step through the notebook, one cell at a time until you find where it breaks."  In contrast, Pluto keeps track of all dependancies across cells.  When you update a cell, it recalculates all the cells that depend on it!  

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
response_2c = missing

# ╔═╡ 569df89d-5039-4a63-8396-ab595811584c
display_msg_if_fail(check_type_isa(:response_2c,response_2c,Markdown.MD)) 

# ╔═╡ 66d9bc94-3e61-41e8-a81d-88e307d97653
md"d.  What considerations would affect the decision of whether to use the one-pass algorithm or the two-pass algorithm?"

# ╔═╡ c63db04d-5fc8-4bee-8594-5d033b2f7a09
response_2d = missing

# ╔═╡ 48d96e9d-b34b-4899-a976-a92602156981
display_msg_if_fail(check_type_isa(:response_2d,response_2d,Markdown.MD)) 

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
response_2e = missing

# ╔═╡ 6134acc4-4b96-4001-ad49-37fd7d6e040e
display_msg_if_fail(check_type_isa(:response_2e,response_2e,Markdown.MD)) 

# ╔═╡ 3393a0a1-c202-4fb1-b752-275595303502
md"Under what circumstance would it be a good/poor choice to use?"

# ╔═╡ 64dcecf3-1561-411a-8759-a4ccb219e303
response_2f = missing

# ╔═╡ 48a888f3-7067-4524-b818-279e3ed2ffdc
display_msg_if_fail(check_type_isa(:response_2f,response_2f,Markdown.MD)) 

# ╔═╡ 339639fc-77d8-4e88-85f3-59c7821cd01f
md"""
g.  Don't forget that we should test your functions for accuracy.  Should we expect all of these functions to return the exact same value?  How can we test functions that return floating point values?  
"""

# ╔═╡ af2bd92f-a67f-4fe3-965e-d337d57a2368
response_2g = missing

# ╔═╡ f362498a-fe8e-440d-afab-c817545b3144
display_msg_if_fail(check_type_isa(:response_2g,response_2g,Markdown.MD)) 

# ╔═╡ a387d515-82d6-4211-8934-b5f0d3b062dc
md"""
h.  I've written some tests in 'test/test2.jl'.  Because of Pluto's reactivity, it's tricky to run a file from inside a notebook.  Instead, run `julia --project=test test/runtests2.jl` to run the code in this Pluto notebook and then the tests in 'test/test2.jl'.  First, check that your functions pass my tests.  If not, is it because your function has a bug?  If so, fix your functions.  Or is there another explanation?  
It may help to look at the source code for the tests to see what it means to have "passed".

Can you suggest additional tests for such functions?  Feel free to add them to the tests in 'test/test2.jl' and check that your code still passes.
"""

# ╔═╡ a11ffb3d-310f-4e28-b8f2-724aab7006a0
response_2h = missing

# ╔═╡ 0cd929dc-f9b6-4dad-8de4-93cf4abd200e
display_msg_if_fail(check_type_isa(:response_2h,response_2h,Markdown.MD)) 

# ╔═╡ b760fedd-41ea-4784-845f-ede0163c0d12
md"## Helper Code"

# ╔═╡ 9ca08091-8906-4b2e-b965-f8dbc385623d
ChooseDisplayMode()

# ╔═╡ bfdd8ecf-5f05-4056-a9d8-f3404774ff52
TableOfContents()

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
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.2"
manifest_format = "2.0"
project_hash = "e5045777d436635474a11468e5fba8a1911aeabe"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "91bd53c39b9cbfb5ef4b015e8b582d344532bd0a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "43b1a4a8f797c1cddadf60499a8a077d4af2cd2d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.7"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "a1296f0fe01a4c3f9bf0dc2934efbf4416f5db31"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.3.4"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "02aa26a4cf76381be7f66e020a3eddeb27b0a092"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.2"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "d9a8f86737b665e15a9641ecbac64deef9ce6724"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.23.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

    [deps.ColorVectorSpace.weakdeps]
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.Compat]]
deps = ["UUIDs"]
git-tree-sha1 = "e460f044ca8b99be31d35fe54fc33a5c33dd8ed7"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.9.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "5372dbbf8f0bdb8c700db5367132925c0771ef7e"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.2.1"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3dbd312d370723b6bb43ba9d02fc36abade4518d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.15"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "e90caa41f5a86296e014e148ee061bd6c3edec96"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.9"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "4558ab818dcceaab612d1bb8c19cee87eda2b83c"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.5.0+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d8db6a5a2fe1381c1ea4ef2cab7c69c2de7f9ea0"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.1+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "UUIDs", "p7zip_jll"]
git-tree-sha1 = "d73afa4a2bb9de56077242d98cf763074ab9a970"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.72.9"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "FreeType2_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt6Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "1596bab77f4f073a14c62424283e7ebff3072eca"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.72.9+1"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "d3b3624125c1474292d0d8ed0f65554ac37ddb23"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.74.0+2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "cb56ccdd481c0dd7f975ad2b3b62d9eda088f7e2"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.9.14"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "f377670cda23b6b7c1c0b3893e37451c5c1a2185"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.5"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6f2675ef130a300a112286de91973805fcc5ffbc"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.91+0"

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "e8ab063deed72e14666f9d8af17bd5f9eab04392"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.24"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f689897ccbe049adb19a065c495e75f372ecd42b"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "15.0.4+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "f428ae552340899a935973270b8d98e5a31c49fe"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.1"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c7cb1f5d892775ba13767a87c7ada0b980ea0a71"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+2"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "2da088d113af58221c52828a80378e16be7d037a"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.5.1+1"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "c3ce8e7420b3a6e071e0fe4745f5d4300e37b13f"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.24"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "cedb76b37bc5a6c702ade66be44f831fa23c681e"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.0"

[[deps.LoweredCodeUtils]]
deps = ["JuliaInterpreter"]
git-tree-sha1 = "60168780555f3e663c536500aa790b6368adc02a"
uuid = "6f1432cf-f94c-5a45-995e-cdbf5db27b0b"
version = "2.3.0"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "03a9b9718f5682ecb107ac9f7308991db4ce395b"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.7"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "51901a49222b09e3743c65b8847687ae5fc78eb2"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.1"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "bbb5c2115d63c2f1451cb70e5ef75e8fe4707019"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.22+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "2e73fe17cac3c62ad1aebe70d44c963c3cfdc3e3"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.2"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+0"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "716e24b21538abc91f6205fd1d8363f39b442851"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.2"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "64779bc4c9784fee475689a1752ef4d5747c5e87"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.42.2+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "f92e1315dadf8c46561fb9396e525f7200cdc227"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.5"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Preferences", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "9f8675a55b37a70aa23177ec110f6e3f4dd68466"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.38.17"

    [deps.Plots.extensions]
    FileIOExt = "FileIO"
    GeometryBasicsExt = "GeometryBasics"
    IJuliaExt = "IJulia"
    ImageInTerminalExt = "ImageInTerminal"
    UnitfulExt = "Unitful"

    [deps.Plots.weakdeps]
    FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
    GeometryBasics = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"
    ImageInTerminal = "d8c32880-2388-543b-8c61-d9f865259254"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.PlutoHooks]]
deps = ["InteractiveUtils", "Markdown", "UUIDs"]
git-tree-sha1 = "072cdf20c9b0507fdd977d7d246d90030609674b"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0774"
version = "0.0.5"

[[deps.PlutoLinks]]
deps = ["FileWatching", "InteractiveUtils", "Markdown", "PlutoHooks", "Revise", "UUIDs"]
git-tree-sha1 = "8f5fa7056e6dcfb23ac5211de38e6c03f6367794"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0420"
version = "0.1.6"

[[deps.PlutoTeachingTools]]
deps = ["Downloads", "HypertextLiteral", "LaTeXStrings", "Latexify", "Markdown", "PlutoLinks", "PlutoUI", "Random"]
git-tree-sha1 = "542de5acb35585afcf202a6d3361b430bc1c3fbd"
uuid = "661c6b06-c737-4d37-b85c-46df65de6f69"
version = "0.2.13"

[[deps.PlutoTest]]
deps = ["HypertextLiteral", "InteractiveUtils", "Markdown", "Test"]
git-tree-sha1 = "17aa9b81106e661cffa1c4c36c17ee1c50a86eda"
uuid = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"
version = "0.2.2"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "e47cd150dbe0443c3a3651bc5b9cbd5576ab75b7"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.52"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "9673d39decc5feece56ef3940e5dafba15ba0f81"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.1.2"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "7eb1686b4f04b82f96ed7a4ea5890a4f0c7a09f1"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Qt6Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "364898e8f13f7eaaceec55fd3d08680498c0aa6e"
uuid = "c0090381-4147-56d7-9ebc-da0b1113ec56"
version = "6.4.2+3"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "PrecompileTools", "RecipesBase"]
git-tree-sha1 = "45cf9fd0ca5839d06ef333c8201714e888486342"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.12"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "90bc7a7c96410424509e4263e277e43250c05691"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.0"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Revise]]
deps = ["CodeTracking", "Distributed", "FileWatching", "JuliaInterpreter", "LibGit2", "LoweredCodeUtils", "OrderedCollections", "Pkg", "REPL", "Requires", "UUIDs", "Unicode"]
git-tree-sha1 = "1e597b93700fa4045d7189afa7c004e0584ea548"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.5.3"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "30449ee12237627992a99d5e30ae63e4d78cd24a"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "c60ec5c62180f27efea3ba2908480f8055e17cee"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "45a7769a04a3cf80da1c1c7c60caf932e6f4c9f7"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.6.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "75ebe04c5bed70b91614d684259b661c9e6274a4"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "9a6ae7ed916312b41236fcef7e0af564ef934769"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.13"

[[deps.Tricks]]
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"

[[deps.URIs]]
git-tree-sha1 = "b7a5e99f24892b6824a954199a45e9ffcc1c70f0"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "607c142139151faa591b5e80d8055a15e487095b"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.16.3"

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

    [deps.Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "e2d817cc500e960fdbafcf988ac8436ba3208bfd"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.3"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "ed8d92d9774b077c53e1da50fd81a36af3744c1c"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "93c41695bc1c08c46c5899f4fe06d6ead504bb73"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.10.3+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "cf2c7de82431ca6f39250d2fc4aacd0daa1675c0"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.4.4+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "afead5aba5aa507ad5a3bf01f58f82c8d1403495"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.6+0"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6035850dcc70518ca32f012e46015b9beeda49d8"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.11+0"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "34d526d318358a859d7de23da945578e8e8727b7"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.4+0"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8fdda4c692503d44d04a0603d9ac0982054635f9"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.1+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "b4bfde5d5b652e22b9c790ad00af08b6d042b97d"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.15.0+0"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "730eeca102434283c50ccf7d1ecdadf521a765a4"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.2+0"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "330f955bc41bb8f5270a369c473fc4a5a4e4d3cb"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.6+0"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "691634e5453ad362044e2ad653e79f3ee3bb98c3"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.39.0+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e92a1a012a10506618f10b7047e478403a046c77"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.5.0+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "49ce682769cd5de6c72dcf1b94ed7790cd08974c"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.5+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "868e669ccb12ba16eaf50cb2957ee2ff61261c56"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.29.0+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9ebfc140cc56e8c2156a15ceac2f0302e327ac0a"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+0"
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
# ╟─b77abd33-0214-46f4-9fde-8b38afafd224
# ╟─b4d6143c-42ad-460d-8af3-a36dae1a8879
# ╠═8c2cddbf-3a02-4969-952e-4d76ca23f95b
# ╠═5f84a3cc-dab6-4ad0-9644-7ea803f43475
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
# ╟─a200eb3c-7041-47e4-89d2-d077dccc18c2
# ╟─731f047f-0f26-4ab7-8810-398659642b0c
# ╠═29637138-4260-4fba-9258-dfa62c214088
# ╟─8588be85-c656-4239-a2f8-f0535d15e55e
# ╟─fd31f33f-641c-47a1-9ad8-fbfb728959c2
# ╠═6347a9de-1795-4980-be61-ec83f7b6c95a
# ╟─ac593093-eebb-49df-9b9b-74ed388d3a2b
# ╟─e0f22e5f-ce24-4d78-8b21-d5ba9b31d536
# ╟─c337d59a-cb1c-4542-ae16-830bf8a2afc5
# ╟─610f1c19-a2ea-40b1-9faa-d47ed60d17b1
# ╟─0b768a24-e97a-47e8-925f-b9e75601ceae
# ╠═4ab6efe2-271c-4574-898e-ce0817fc5033
# ╟─72474fca-4bc7-471e-9116-c48023f147dd
# ╠═47104686-c7f2-44c1-be4c-7bb2497aafbf
# ╠═51ced48f-0aab-47fd-ab59-7b0acea6097a
# ╠═5f959c70-2a7a-47c9-b575-68c46dc4eeba
# ╠═192e6360-5eba-4a4d-b203-363caba8af64
# ╠═a83d07b9-d7b7-4274-929a-9a3474e44f08
# ╟─723c95f7-b751-490d-968a-fe15559416dd
# ╟─58d4e72a-aed5-4b8f-846e-bb63e4cc54c7
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
# ╟─48a888f3-7067-4524-b818-279e3ed2ffdc
# ╟─339639fc-77d8-4e88-85f3-59c7821cd01f
# ╠═af2bd92f-a67f-4fe3-965e-d337d57a2368
# ╟─f362498a-fe8e-440d-afab-c817545b3144
# ╟─a387d515-82d6-4211-8934-b5f0d3b062dc
# ╠═a11ffb3d-310f-4e28-b8f2-724aab7006a0
# ╟─0cd929dc-f9b6-4dad-8de4-93cf4abd200e
# ╟─b760fedd-41ea-4784-845f-ede0163c0d12
# ╠═9ca08091-8906-4b2e-b965-f8dbc385623d
# ╠═af508570-b20f-4dd3-a995-36c79fc41823
# ╠═bfdd8ecf-5f05-4056-a9d8-f3404774ff52
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
