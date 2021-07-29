### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ ab976d70-f59d-4dcd-ac89-771606a74108
using PlutoUI

# ╔═╡ 0d8640d7-6103-45c3-9112-1fb842eaf1a7
using PlutoTeachingTools

# ╔═╡ 93086b90-7306-458d-a7e1-4c27e0bcfe36
(@isdefined PlutoRunner) ? using PlutoTest : using Test 

# ╔═╡ 5b826e17-ad51-43d0-9756-89a9fd0ea834
md"""
# Astro 528, Lab 1, Exercise 1
"""

# ╔═╡ acb10cb1-d03d-47c5-90dc-7216e5110ed2
md"""
## Access the lab
Before we delve into the meat of the course, we'll practice accessing the assignment via your private git repository ("repo"), cloning the repo, starting Julia, and launching the Pluto notebook server.  
Once you open the Pluto notebook, it will begin executing the entire notebook.  (Depending on your system and how complex the notebook is, sometimes this can take a little time.)  You'll read through this notebook, make some small changes, see how that affects the results, save your changes to your local machine, commit your changes to your local git repository, and then push those to your repository on github.
For many of you, this is likely your first time using all of these tools, and it probably sounds like a lot.  The good news is that before long all of this will become second nature and you'll wonder how you got along without such tools. 
"""

# ╔═╡ c15ce452-494f-407c-9c08-02d547929e6a
md"""
## Assigning Variables
In Julia, you assign variables values using the `=` sign.
Assigning integer or floating point numbers uses a natural notation.
Once a cell is executed, Pluto shows the output of each cell above the cell with the relevant code.
For example,"""

# ╔═╡ 25d5497c-3a67-4495-9f37-0bc8f2a64e68
current_year = 2021

# ╔═╡ 774b2e4a-6cd7-4c9a-920d-b4f38354d42d
md"""Strings are created by enclosing text between double quotes.  
For example,"""

# ╔═╡ 5917df75-0dab-4778-917e-91bbfddbe03a
begin
	course_number = "Astro 528"
	semester = "Fall 2021"
	instructor = "Eric Ford"
end

# ╔═╡ 0d15ba33-f2c4-46d6-9b08-9181d40596cd
md"""Notice that, when working in a Pluto notebook, cells that assign multiple variables need to be wraped in a `begin...end` block.  (This is not necessary in general (e.g., julia scripts, Jupyter notebooks, or module code.)  
Note that only the output from the last line is displayed.  The other variables were still assigned and can be accessed in other cells."""

# ╔═╡ dc0bf251-b3a6-42f7-84f6-796ac3761b2d
course_number

# ╔═╡ dbfceab2-994d-45a1-97ff-d978827bd129
tip(md"""Single quotes are used to indicate a single character (as opposed to a string of length 1).  
[Triple quoted string literals](https://docs.julialang.org/en/v1/manual/strings/#Triple-Quoted-String-Literals) are useful for quotes spanning multiple lines (and when you want to include `"` symbols). 
""")

# ╔═╡ e2bb48e5-a2b2-42d7-a8e5-5c7532d62e93
md"Assigning integer or floating point numbers uses a natural notation."

# ╔═╡ cda49166-b9fb-4e68-8b3e-b97845c7bf3b
instructor_year = current_year - 1999

# ╔═╡ 0c5d5b14-6c9a-4ac9-8126-0d6e1edba593
favorite_number = 3.1415926535897

# ╔═╡ a3450384-ccfc-4bda-af52-24ed8f429cf8
md"""Now, it's your turn to create variables named `student_name`, `student dept` and `student_year` with values based on yourself.  You can modify the code in the cells below."""

# ╔═╡ 687c15c2-bfc4-4d18-bbc6-035630fe2747
# WRITE YOUR CODE HERE

# ╔═╡ f71acc99-d355-4705-9c7f-e090948f83f1
begin
	# WRITE YOUR CODE HERE
end;

# ╔═╡ 33350a21-7971-406e-b316-6539eca72bf4
begin
	student_name = "Eric Ford"
	student_dept = "Astronomy & Astrophysics"
	student_year = current_year-1999
end;

# ╔═╡ f15643a4-39d5-4492-98d3-9db4f4cb0d3b
md"""
Run the cell with your code and make sure there are no error messages.  
Sometimes, I may provide a few quick checks in the Pluto notebook itself.  For example,
"""

# ╔═╡ 8b666639-e3d0-4535-803d-40ddc4360a9c
if !@isdefined(student_year)
	not_defined(:student_year)
else
	let
		if ismissing(student_year)
			still_missing()
		elseif isnothing(student_year)
			keep_working("Could there be a typeo?")
		elseif !(student_year isa Integer) 
			keep_working(md"The value should be an integer.")
		elseif ! (1<= student_year)
			keep_working(md"I'm expecting `student_year` to be one or larger.")
		elseif ! (student_year <= 10)
			keep_working(md"Are you sure?  Most grad students finish in less than 10 years.")
		else
			correct(md"I think that $student_year seems like a reasonable value for `student_year`.")
		end
	end
end

# ╔═╡ ca097022-5b40-44ef-ad95-8d9071cca008
if !occursin("Astro", student_dept)
	tip("We're glad to have you join us.")
end

# ╔═╡ ec4ec6e7-9548-4bd6-970a-48fefa9861d7
md"""
## Pass a Test
Once we start doing real calculations, it will be important to test our work.  Therefore, you and I will both write tests that your code should pass. For example, in this case we can test that variables with the correct names exist, they're not empty, that they have the expected type, that their value falls within a reasonable range, etc.
"""

# ╔═╡ ac9e6787-5c42-44d6-907e-e7033e7ab4bc
tip(md"Before using a test, we need to tell Julia to import a module that will provide the `@test` macro.  To simplify the notebook, I've put that code at the bottom of the notebook, so it doesn't distract from our main task.")

# ╔═╡ 087b40c4-7d59-4f9a-b584-65c2aa9f9578
md"
The first few tests below should pass.  Later, I've written a couple of tests with bugs in them for you to fix.  Look at the results of the cells below, find the tests that doesn't pass, and modify the code so that it passes.  
"

# ╔═╡ eefa92a1-1d4c-4536-abd3-1c1af98e146f
md"One of the first things to check is that variables have been defined.  If not, then later tests will fail and we might spend time trying to dive deeper into the problem than we need to."

# ╔═╡ 78f81544-fead-4649-b306-48fb1463d397
@test @isdefined(student_name)

# ╔═╡ 3d224633-0eb8-407c-b44c-0d9ec927dfc6
@test @isdefined(student_dept)

# ╔═╡ 2fe3f4e8-5288-4f61-9346-7a455c2abc85
@test @isdefined(student_year)

# ╔═╡ b49789b2-49c0-49e3-b81f-db04e60f9d23
md"Next, we'll test that the types of the variables are what we expect.  If not, then it's unlikely that the values stored will be what we expect."

# ╔═╡ 34f767c9-f95f-4968-9423-ad87bb456775
@test typeof(student_name) == String

# ╔═╡ d6417bdc-9e36-4d2b-8b3e-f5ddafd82437
@test typeof(student_dept) == String

# ╔═╡ 89ac58ea-b782-4dcc-802f-d6d063e7b855
@test typeof(student_year) <: Number

# ╔═╡ 2479fb6a-2e51-4e6f-8155-d47e9e3ae27d
@test typeof(student_year) <: Integer

# ╔═╡ 6d8e0985-3613-49bc-8050-91e2ee73de52
md"We often see the `==` operator when testing for equality of two numbers.  Here the `==` operator is testing for the equivalence of two types.
Alternatively, we can use the `<:` operator to ask if one type is a 'sub-type' of another 'abstract type'."

# ╔═╡ 7f031249-4413-4cd6-8ba5-b3369a1216a0
md"Now, we're ready to test that the values of the variables are consistent with what we expect."  

# ╔═╡ 8ff88c72-7982-4025-9057-384a48186dc9
@test length(student_name) > 3

# ╔═╡ c408ddb6-af5d-4b6a-ae81-9d338fd15f06
@test occursin(' ',student_name)

# ╔═╡ 939a5680-c387-454d-a7f0-16e0d51254d8
md"In the above cell, we test that the `occursin` function retures true.  There should be a slider widget.  Try dragging it left or right.  This can be helpful when figuring out *why* a complicated test fails."

# ╔═╡ d732ab18-65b3-417a-8f8d-5f4502baa777
@test length(student_dept) >= 3

# ╔═╡ bc491991-1c10-43bb-8afe-3ed08c91d3d7
@test 1 <= student_year <= 10

# ╔═╡ a328c8c6-6268-4b1f-ae1c-84ee295285c8
@test student_name == instructor

# ╔═╡ 852d7d9d-fc12-42f2-863f-af0b647979df
md"**TODO:** There are (at least) two bugs in the above tests.  Find them and fix them."

# ╔═╡ 6584e095-465d-4b3d-a383-9ac569e307cc
md"In the future, we'll separate out the tests for each exercise into a separate file (located in the `test` directory of the lab repository), so that they don't distract from the code we're writing."

# ╔═╡ 68341392-aa5a-41b7-a76a-76db1c6357f5
md"""Once you're happy with the results, it's time to save your notebook.  Look for the button in the upper right or `Ctrl`+'S'.  If it's not there, then your notebook has been autosaved.  

Then read the [instructions for submitting assignments](https://psuastro528.github.io/tips/submitting) for how to commit your changes to your local git repository and push them to github. 
    
When you're done you can look into the second notebook (ex2) in this repository to begin the next exercise."""

# ╔═╡ 51a1bf7c-6a1d-4d31-a735-de3414a97ab6
md"""## Helper code"""

# ╔═╡ 4d860e75-0631-4ef6-853c-818bafe080f4
md"""Students can ignore the code below was quietly used above."""

# ╔═╡ 45efd82d-63e1-4016-838e-d0fbb21db99f
md"The PlutoUI package provides several cool features, but for now we just use it to add the Table of Contents in the upper right corent."

# ╔═╡ 73a3ce7e-9967-4d11-8ab7-0e0409190975
TableOfContents()

# ╔═╡ ceff74da-4cd2-4091-af1a-8ecde8e13700
md"The PlutoTeachingTools package has several small functions that we use for things like tips."

# ╔═╡ 98ecc733-15f3-4263-821a-483dadfc8ab8
tip(md"Normally, we'd use the `Test` module for the `@test` macro.  Julia has a large set of modules and packages, that range from very basic functionality to complex science codes.  The quality also varries widely.  Several modules (like `Test`) are included in Julia standard library, so they're already installed for us.  
	
However, inside Pluto, it can be helpful to instead import `PlutoTest`, since it displays the results particularly nicely.  (It's an external package and it's still experimental, so if things break in the future, then we can revert to just using `Test`.  
	
Below, I pick one based on whether we are inside a Pluto notebook session.")

# ╔═╡ 88d4af01-64ea-4455-ac80-b3c9444bf82a
md"""
The above cell both loads the code in the Test module and brings the functions (and macros) that it "exports" "into scope", meaing that we can "just call them".  For example,
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoTest = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[compat]
PlutoTeachingTools = "~0.1.0"
PlutoTest = "~0.1.0"
PlutoUI = "~0.7.9"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[HypertextLiteral]]
git-tree-sha1 = "1e3ccdc7a6f7b577623028e0095479f4727d8ec1"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.8.0"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "81690084b6198a2e1da36fcfda16eeca9f9f24e4"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.1"

[[LaTeXStrings]]
git-tree-sha1 = "c7f1c695e06c01b95a67f0cd1d34994f3e7db104"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.2.1"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "c8abc88faa3f7a3950832ac5d6e690881590d6dc"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "1.1.0"

[[PlutoTeachingTools]]
deps = ["LaTeXStrings", "Markdown", "Random"]
git-tree-sha1 = "4a70f8a4954bbfa3d02b41d4149607bcf93ff9b4"
uuid = "661c6b06-c737-4d37-b85c-46df65de6f69"
version = "0.1.0"

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

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "5f6c21241f0f655da3952fd60aa18477cf96c220"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.1.0"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Suppressor]]
git-tree-sha1 = "a819d77f31f83e5792a76081eee1ea6342ab8787"
uuid = "fd094767-a336-5f1f-9728-57cf17d0bbfb"
version = "0.2.0"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
"""

# ╔═╡ Cell order:
# ╟─5b826e17-ad51-43d0-9756-89a9fd0ea834
# ╟─acb10cb1-d03d-47c5-90dc-7216e5110ed2
# ╟─c15ce452-494f-407c-9c08-02d547929e6a
# ╠═25d5497c-3a67-4495-9f37-0bc8f2a64e68
# ╟─774b2e4a-6cd7-4c9a-920d-b4f38354d42d
# ╠═5917df75-0dab-4778-917e-91bbfddbe03a
# ╟─0d15ba33-f2c4-46d6-9b08-9181d40596cd
# ╠═dc0bf251-b3a6-42f7-84f6-796ac3761b2d
# ╠═dbfceab2-994d-45a1-97ff-d978827bd129
# ╟─e2bb48e5-a2b2-42d7-a8e5-5c7532d62e93
# ╠═cda49166-b9fb-4e68-8b3e-b97845c7bf3b
# ╠═0c5d5b14-6c9a-4ac9-8126-0d6e1edba593
# ╟─a3450384-ccfc-4bda-af52-24ed8f429cf8
# ╠═687c15c2-bfc4-4d18-bbc6-035630fe2747
# ╠═f71acc99-d355-4705-9c7f-e090948f83f1
# ╠═33350a21-7971-406e-b316-6539eca72bf4
# ╟─f15643a4-39d5-4492-98d3-9db4f4cb0d3b
# ╟─8b666639-e3d0-4535-803d-40ddc4360a9c
# ╟─ca097022-5b40-44ef-ad95-8d9071cca008
# ╟─ec4ec6e7-9548-4bd6-970a-48fefa9861d7
# ╟─ac9e6787-5c42-44d6-907e-e7033e7ab4bc
# ╟─087b40c4-7d59-4f9a-b584-65c2aa9f9578
# ╟─eefa92a1-1d4c-4536-abd3-1c1af98e146f
# ╠═78f81544-fead-4649-b306-48fb1463d397
# ╠═3d224633-0eb8-407c-b44c-0d9ec927dfc6
# ╠═2fe3f4e8-5288-4f61-9346-7a455c2abc85
# ╟─b49789b2-49c0-49e3-b81f-db04e60f9d23
# ╠═34f767c9-f95f-4968-9423-ad87bb456775
# ╠═d6417bdc-9e36-4d2b-8b3e-f5ddafd82437
# ╠═89ac58ea-b782-4dcc-802f-d6d063e7b855
# ╠═2479fb6a-2e51-4e6f-8155-d47e9e3ae27d
# ╟─6d8e0985-3613-49bc-8050-91e2ee73de52
# ╟─7f031249-4413-4cd6-8ba5-b3369a1216a0
# ╠═8ff88c72-7982-4025-9057-384a48186dc9
# ╠═c408ddb6-af5d-4b6a-ae81-9d338fd15f06
# ╟─939a5680-c387-454d-a7f0-16e0d51254d8
# ╠═d732ab18-65b3-417a-8f8d-5f4502baa777
# ╠═bc491991-1c10-43bb-8afe-3ed08c91d3d7
# ╠═a328c8c6-6268-4b1f-ae1c-84ee295285c8
# ╟─852d7d9d-fc12-42f2-863f-af0b647979df
# ╟─6584e095-465d-4b3d-a383-9ac569e307cc
# ╟─68341392-aa5a-41b7-a76a-76db1c6357f5
# ╟─51a1bf7c-6a1d-4d31-a735-de3414a97ab6
# ╟─4d860e75-0631-4ef6-853c-818bafe080f4
# ╠═ab976d70-f59d-4dcd-ac89-771606a74108
# ╟─45efd82d-63e1-4016-838e-d0fbb21db99f
# ╠═73a3ce7e-9967-4d11-8ab7-0e0409190975
# ╟─ceff74da-4cd2-4091-af1a-8ecde8e13700
# ╠═0d8640d7-6103-45c3-9112-1fb842eaf1a7
# ╟─98ecc733-15f3-4263-821a-483dadfc8ab8
# ╠═93086b90-7306-458d-a7e1-4c27e0bcfe36
# ╟─88d4af01-64ea-4455-ac80-b3c9444bf82a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
