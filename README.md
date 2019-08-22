# Oobash

_(c) 2019 Finn Ellis, available for use under the terms of the [MIT license](LICENSE)._

An object-oriented programming library for bash. Sourcing `oobash.sh` allows you to define objects in bash scripts which have properties, methods, and inheritance. They're less like Java classes and more like Lua tables, in that there's no class/object distinction; each object just has a parent, to which it will look for methods and properties not defined on it.

Oobash currently has no external dependencies (not even on standard utilities), although it does use features of **bash 4** and will not work in earlier versions. It also keeps its metadata entirely in environment variables, not the filesystem. I reserve the right to change either of those constraints in the future if it facilitates implementing something cool, but I prefer not to as long as other options are available.

## Getting Help & Contributing

Feel free to open issues in this repository, or make pull requests with small changes. If you would like to make a large change, please open an issue first to propose it.

## Usage Cheatsheet

```bash
eval $(new object my_obj)
my_obj property = 'value'
my_obj property
# prints: value

my_obj method << 'EOF'
  # arguments: $1, $2 ...
  # this object: $self
  # parent object: $super
  echo hi
EOF

my_obj method
# prints: hi

eval $(new object other_obj)
other_obj property = $(my_obj property)
other_obj property
# prints: value

```

## Example Walkthrough

_The example dissected below is [test.sh](test.sh) in this repo._

Fetch a local copy of oobash.

```bash
curl -O https://raw.githubusercontent.com/relsqui/oobash/master/oobash.sh
```

Source it in your script. This will add functions called `new` and `object` to your environment, as well as a number of functions and variables with the prefix `oob_`.

```bash
source oobash.sh
```

Create new objects by calling `new` followed by the names of the parent object and the new object, in that order, and evaluating the result. Every object must have a parent; use the base `object` when you don't need another one. This creates an object called `widget`:

```bash
eval $(new object widget)
```

Set properties on an object with the syntax `object_name property_name = value`. Values are parsed like bash arguments and stored like bash variables, so put them in quotes if they contain spaces, escape special characters, and so on.

```bash
widget name = 'Widget Class'
```

Define methods with herestring syntax. The `__constructor` method is special, and will be run every time you create an object as a child of the one you defined the constructor on.

This constructor assigns every widget we create a number, incrementing each time:

```bash
widget_count=0

widget __constructor << 'EOF'
    let widget_count++
    $self widget_number = $widget_count
EOF
```

Note that you also have `$self` available to refer to an object from inside its own methods.

Like other bash functions, oobash methods can access their arguments with `$1`, `$2`, and so on. They can also use `$super` to refer to the object defined as their parent.

To retrieve the value of an oobash object property inline, enclose it in `$()` (or backticks) -- you're actually running a function which outputs the value.

```bash
widget introduce << 'EOF'
    echo "Hi, I'm $($self name), widget #$($self widget_number)."
    echo "My parent is $($super name)."
    echo "Please meet my friend, $($1 name)."
EOF
```

Having defined an object with some methods, you can instantiate child objects and give them different properties (as well as additional methods).

```bash
eval $(new widget widget1)
widget1 name = 'Widgeter'

eval $(new widget widget2)
widget2 name = 'Widgetest'
```

Child objects can call methods defined on their parent.

```
$ widget2 introduce widget1
Hi, I'm Widgetest, widget #2.
My parent is Widget Class.
Please meet my friend, Widgeter.
```

To see what's happening under the hood (such as when debugging inheritance problems), you can export the environment variable `OOB_DEBUG` with any non-empty value.

```
----[widget1] introduce widget2
----searching widget1's parent for introduce
------[widget] introduce widget2
------calling widget's introduce method for widget1 (widget2)
----------[widget1] name 
----------returning widget1's name value (Widgeter)
----------[widget1] widget_number 
----------returning widget1's widget_number value (1)
Hi, I'm Widgeter, widget #1.
----------[widget] name 
----------returning widget2's widget_number value (2)
Hi, I'm Widgetest, widget #2.
----------[widget] name
----------returning widget2's name value (Widget Class)
My parent is Widget Class.
----------[widget1] name
----------returning widget2's name value (Widgeter)
Please meet my friend, Widgeter.
```

## ... Why?!

I figured I'd keep trying until I hit the point where it was impossible, and that never happened.
