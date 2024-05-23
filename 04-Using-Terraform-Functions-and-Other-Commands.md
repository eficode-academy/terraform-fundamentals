# 04-Using Terraform Functions and Other Commands

## Learning Goals

This module is designed to deepen your understanding of Terraform's capabilities by exploring both its built-in functions and a variety of advanced commands. 

Through hands-on practice, you will learn how to manipulate data and manage Terraform configurations more effectively.

### Objectives

- Master the use of Terraform's built-in functions to perform data manipulation and formatting directly within Terraform configurations.
  
- Utilize the Terraform console for interactive exploration of function capabilities.

## Step-by-Step Instructions

### 1. Setting Up the Terraform Console

Before experimenting with the functions, make sure you have a working Terraform setup.

- **Navigate** to `labs/04-Using-Terraform-Functions-and-Other-Commands` directory.
- **Open** a terminal in this directory.
- Run `terraform init`
- **Run** the Terraform console command:

  ```
  terraform console
  ```
  This opens an interactive console where you can type Terraform expressions and see their evaluated results.

### 2. Experiment with Terraform Functions

Here are some of the key Terraform functions and practical examples of how to use them in the Terraform console.

#### Numerical Functions

- **`abs(number)`**: Returns the absolute value of the given number. Try this in the console:
  ```hcl
  abs(-42)  # Outputs 42
  ```

- **`min(...)` and `max(...)`**: Return the smallest or largest value from a list of numbers, respectively. Try these examples:
  ```hcl
  min(5, 12, 9)  # Outputs 5
  max(5, 12, 9)  # Outputs 12
  ```

#### String Functions

- **`format(fmt, ...)`**: Formats a string according to the specified format string `fmt`. Here's how you use it:
  ```hcl
  format("Hello, %s!", "world")  # Outputs "Hello, world!"
  ```

- **`join(delimiter, list)`**: Concatenates the elements of a list into a single string, inserting the `delimiter` between elements. Example:
  ```hcl
  join("-", ["foo", "bar", "baz"])  # Outputs "foo-bar-baz"
  ```

- **`lower(string)`** and **`upper(string)`**: Convert a string to all lower or upper case, respectively. Examples:
  ```hcl
  lower("TERRAFORM")  # Outputs "terraform"
  upper("terraform")  # Outputs "TERRAFORM"
  ```

#### Collection Functions

- **`concat(list1, list2, ...)`**: Combines multiple lists into a single list. Example:
  ```hcl
  concat(["a", "b"], ["c"])  # Outputs ["a", "b", "c"]
  ```

- **`contains(list, value)`**: Checks if a list contains a given value. Example:
  ```hcl
  contains(["a", "b", "c"], "a")  # Outputs true
  ```

- **`element(list, index)`**: Retrieves the element at a specified index in a list. Example:
  ```hcl
  element(["a", "b", "c"], 1)  # Outputs "b"
  ```

- **`lookup(map, key, default)`**: Retrieves the value of a specified `key` from a map. Example:
  ```hcl
  lookup({"a" = "apple", "b" = "banana"}, "a", "unknown")  # Outputs "apple"
  ```

#### Encoding and Template Functions

- **`base64decode(string)`** and **`base64encode(string)`**: Decode or encode in Base64. Example:
  ```hcl
  base64encode("hello world")  # Outputs "aGVsbG8gd29ybGQ="
  base64decode("aGVsbG8gd29ybGQ=")  # Outputs "hello world"
  ```

- **`jsonencode(value)`** and **`jsondecode(string)`**: Convert a value to JSON string or parse a JSON string to a Terraform structure. Example:
  ```hcl
  jsonencode({"key" = "value"})  # Outputs "{\"key\":\"value\"}"
  jsondecode("{\"key\": \"value\"}")  # Returns {"key" = "value"}
  ```

### 3. Exiting the Console

To exit the Terraform console, simply type `exit` and press Enter.

### 4. Practice Terraform Commands

After exploring Terraform functions, we'll practice using several important Terraform CLI commands that will help you manage and interact with the configuration effectively. Below are explanations and step-by-step instructions for each command using your current Terraform setup.

#### Navigate to the directory

Before executing the commands, make sure you are in the correct directory `using terraform functions and advanced commands` where a  Terraform configuration file is located. The terraform configuration is to create a random string.
The content of the file `main.tf` looks like below

```hcl
terraform {
  required_version = "~> 1.8.0"  # Specifies the required Terraform version
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
}

resource "random_string" "randomname" {
  length  = 16
  count   = 2
  special = false
  upper   = false
}

output "random_string_values" {
  value = random_string.randomname.*.result
  description = "The generated random strings."
}
```

#### Terraform Commands to Practice

1. **`terraform validate`**:
   Ensures that the configuration is syntactically valid and internally consistent.
   ```bash
   terraform validate
   ```

2. **`terraform fmt`**:
   Automatically reformat your configuration in the standard style.
   ```bash
   terraform fmt
   ```
To effectively show how `terraform validate` and `terraform fmt` work, you can start by introducing a deliberate syntax error or formatting inconsistency in your Terraform configuration.

For instance, let's modify the `main.tf` file to include a misalignment and a small error:

```hcl
resource "random_string" "randomname" {
length = 16  # Improperly formatted line (should be indented)
count   = 2
special = false
uper    = false  # Typo here should be "upper"
}
```
First, demonstrate how `terraform fmt` can automatically correct formatting issues:

```bash
terraform fmt
```

This command will adjust the indentation for the `length` line but won't fix the typo in `uper`. You can show the changes by displaying the file content

Next, use `terraform validate` to check for configuration errors:

```bash
terraform validate
```

This command will output an error due to the typo in the attribute name (`uper` instead of `upper`). The output might look something like this:

```plaintext
Error: Unsupported argument

  on main.tf line 4, in resource "random_string" "randomname":
   4: uper    = false

An argument named "uper" is not expected here. Did you mean "upper"?
```

After identifying the error with `terraform validate`, correct the typo in the `main.tf` file:

```hcl
resource "random_string" "randomname" {
  length  = 16
  count   = 2
  special = false
  upper   = false  # Corrected typo
}
```

3. **`terraform output`**:
   Shows the outputs defined in your configuration. This is useful after an apply to retrieve the values of outputs.
   ```bash
   terraform apply
   terraform output
   ```

4. **`terraform show`**:
   Provides human-readable output from a state or plan file. Use this to inspect the current state.
   ```bash
   terraform show
   ```

5. **`terraform version`**:
   Displays the current Terraform version.
   ```bash
   terraform version
   ```

6. **`terraform get`**:
   Downloads and installs modules needed for the configuration.
   ```bash
   terraform get
   ```

7. **`terraform graph`**:

In a subsequent exercise, you will have the opportunity to explore the `terraform graph` command. This command produces a visual representation of either a configuration or execution plan. The output is in DOT format, which can be used by GraphViz to generate charts. This visual tool can be incredibly helpful for understanding the relationships between resources in your Terraform configurations and for identifying dependencies and their execution order.

   ```bash
   terraform graph > graph.dot

   dot -Tpng graph.dot -o graph.png

   ```


### Conclusion

This hands-on session with Terraform's built-in functions  and commands provides a deeper understanding of how to dynamically manage and manipulate data within Terraform configurations. 

To read more of Terraform's functions and to see a complete list of available functions, visit the [Terraform Documentation on Functions](https://www.terraform.io/language/functions).
