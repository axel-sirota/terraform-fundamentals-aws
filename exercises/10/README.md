# Lab 10: Understanding and Manipulating Data/Variables

As you do this exercise, you're encouraged to change the HCL to experiment a bit with the different data types
and using them in action.

### Primitive Types

Terraform has restructured to include variable types in a category "primitive." These are quite similar to
what you'd find in other language primitives.

1. Change into the `primitives` directory and `apply` to see primitives in action

 ```bash
 cd primitives
 terraform apply
 ```

 We're not really creating any infrastructure in this exercise, rather just looking at the processing and output
 of variables and data.

 You should see something like the following when running the above:

 ```
 Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

 Outputs:

 my_bool_negated = false
 my_bool_value = my_bool is true
 my_number_plus_two = 12
 my_string_interpolated = my_string_value_interpolated
 ```

1. Take a look at the main.tf file and we'll examine  each variable and each related output

 #### Strings
 * The string type is probably the simplest of the primitives, and it's the default type if you don't explicitly set a type
 * The above shows you the syntax for string interpolation
 * You could do this when defining resource properties, not just in constructing outputs as above
 * We've seen this when making our rg or storage accounts  names in the previous exercises

  ```hcl
  variable "my_string" {
     type    = string
     default = "my_string_value"
  }
  ...
  output "my_string_interpolated" {
     value = "${var.my_string}_interpolated"
  }
  ```

 #### Numbers
  * Below we show how you can deal with this number variable directly by doing arithmetic

 ```hcl
 variable "my_number" {
     type    = number
     default = 10
 }

 output "my_number_plus_two" {
     value = var.my_number + 2
 }
 ```

 #### Bools
 * The `bool` type is new in 0.12
 * It gives you the power to perform boolean operations and checks in your HCL like we see above in both the ternary and negation syntax to construct these output values

 ```hcl
 variable "my_bool" {
     type    = bool
     default = true
 }

 output "my_bool_negated" {
     value = !var.my_bool
  }
  output "my_bool_value" {
     value = var.my_bool == true ? "my_bool is true" : "my_bool is false"
}
```

### Complex Types

Complex types are lists, sets, tuples, objects, maps.

3. Let's take a look at them in action

 ```bash
 cd complex
 terraform apply
 ```

 Running the above should give you something like

 ```
 Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

 Outputs:

 my_list_index_2 = "3"
my_list_values = tolist([
  "1",
  "2",
  "3",
])
my_map_values = tomap({
  "ages" = tolist([
    "12",
    "14",
    "10",
  ])
  "names" = tolist([
    "John",
    "Susy",
    "Harold",
  ])
})
my_object_names_value = tolist([
  "John",
  "Susy",
  "Harold",
])
my_object_values = {
  "ages" = tolist([
    12,
    14,
    10,
  ])
  "names" = tolist([
    "John",
    "Susy",
    "Harold",
  ])
}
my_set_values = toset([
  1,
  2,
  3,
  4,
  5,
])
my_tuple_values = [
  "1",
  2,
  "3",
]
 ```

 * Let's look at each of the complex types individually and see what's actually going on in our `main.tf` file
 * Again, we're not creating anything in this exercise, merely setting variables and constructing outputs from these variables
 * The way we're using these variables in outputs would apply to any other resource or use in your HCL

 #### Lists
  * In our example here we're setting a [type
 constraint](https://www.terraform.io/docs/configuration/types.html), so that our list can only contain string values
  * In our two output examples, we see first an example of accessing a particular list item value, as well as using the entire list

 ```hcl
 variable "my_list" {
     type      = list(string)
     default   = ["1", "2", "3"]
 }
 
 output "my_list_index_2" {
     value = var.my_list[2]
 }

 output "my_list_values" {
     value = var.my_list
 }
 ```

 #### Sets
  * Sets are like lists, but different
  * We discussed them, but play around with the definition in the HCL here and see if you can remember or identify what makes a set unique

 ```hcl
 variable "my_set" {
     type      = set(number)
     default   = [1, 2, 3, 4, 5]
 }
 
 output "my_set_values" {
     value = var.my_set
 }
 ```

 #### Tuples
 * you'll probably use tuples the least of any of the types
 * the key takeaway is that it's a list with mixed, strict type constraints

 ```hcl
 variable "my_tuple" {
     type      = tuple([string, number, string])
     default   = ["1", 2, "3"]
 }
 output "my_tuple_values" {
     value = var.my_tuple
 }
 ```

 #### Maps

  * Maps are also not new, except that they now allow a type constraint for the related value(s)
  * A map is just a collection of key/value pairs

 ```hcl
 variable "my_map" {
     type      = map
     default   = {names: ["John", "Susy", "Harold"], ages: [12, 14, 10]}
 }

 output "my_map_values" {
     value = var.my_map # the ability to do this without quotes is new in 0.12!
 }
 ```

 #### Objects

 * Objects are similar to maps, but can you identify the differences?
 * Also, add some other outputs of your own to access specific values in the object, change the object structure to see how far you can go with setting up an object

 ```hcl
 # How is this different than the map above?
 variable "my_object" {
     type      = object({names: list(string), ages: list(number)})
     default   = {names: ["John", "Susy", "Harold"], ages: [12, 14, 10]}
}

 output "my_object_values" {
     value = var.my_object
 }
 ```

### Terraform Data and Reference

We've covered HCL data and variable concepts pretty completely at this point, but we want to finish off by looking closely
at one other thing: Terraform data sources and referencing these data sources.

Remember earlier when we queried the state of another terraform project? That was a Terraform data source. We want to look at how
providers allow you the ability to query particular sources to get things you need at runtime with the same mechanism.

4. Let's look at some of this in action

 ```bash
 cd other-data
 terraform init
 terraform apply
 ```

 You should get something like the following as the output:

 ```
Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

current_region_availability_zones = tolist([
  "us-east-1a",
  "us-east-1b",
  "us-east-1c",
  "us-east-1d",
  "us-east-1e",
  "us-east-1f",
])
most_recent_ubuntu_ami_id = "ami-0fc5d935ebf8bc3bc"
 ```

### Finishing off this exercise

We're gonna do a little bit of experimenting as a way to finish off this exercise. This will give you an opportunity to play
a bit with things that look interesting to you in the HCL syntax, variable, and data usage areas:

* Conditionals like ternary syntax, other expressions: https://www.terraform.io/docs/configuration/expressions.html
* Interpolation, figuring what you can and can't do here
* Built-in functions: https://www.terraform.io/docs/configuration/functions.html

Maybe try some of the above out with `terraform console`?
