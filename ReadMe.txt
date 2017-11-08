Vektor Tool Readme

Short version:
To make an anonymized copy of declaration file 'original.asc':
   vektor copy original.asc copy.asc \
   -r:"0203=999999999,0210=@name,0207=@date:19000101-20100101"
This will create a copy 'copy.asc' based on 'original.asc', 
where all '02' lines will have:
- '999999999' as value for the 03 element (BSN),
- a random name for element '10' (last name)
- a random date between 01-01-1900 and 01-01-2010 for element '07' (birth date)

Installation
You may place the executable (vektor.exe) anywhere on your file system,
but please make sure to place the folder 'vektor-data' in the same
directory. For convenience you can add the path containing the executable
to your PATH environment variable.

The Vektor tool is a command line tool developed to assist in the
process of analysis and modification of existing Vektis EI compliant 
declaration files. Its main function is creating adapted copies of  
declaration files. Additionally it provides for selectively viewing
information from a declaration. Furthermore it provides structural 
information on the supported Vektis file formats and also validates
a given file against the format.

The modification function provides a generic way of bulk modifying 
the value of any line element. You provide it a replacement
specification(e.g. "-r:0203=999999999" and it will replace 
all the values for the BSN element of the patient record by the 
specified replacement value. 

Vektor does not perform the modifications 'in place' in the input file
supplied. Instead it creates a copy (output file) with the same 
content of the original input file, but with the specified element
values replaced.

Vektor uses the value types specified in the Vektis EI standards. 
In short, it knows to check for numerical values where required 
and it will pad values to preserve field length.

When calling Vektor from the command line you need to specify the
following command line arguments:
- the function to perform (called the Vektor command)
- additional parameters specific to the function
E.g. for the 'copy' command you would need to specify:
- the path to the input file (if applicable for the command)
- the path of an output file to be created (if applicable)
- the elements to modify and their new values (as option -e)
If the new value should be the empty value then you don't specify
any value.

Like every command line tool, you can refer to Vektor just by its
name 'vektor' if it can be found on your PATH environment variable.
Otherwise you will have to supply the full path to the executable
to use it. The following examples assume vektor.exe can be found
via your PATH settings.

Vektor commands
Currently the following commands are supported:
1- copy: The main function, for creating modified copies.
2- validate: Support function. Checks a file for Vektis compliance.
3- show: Support function. Presents a table with the specified
line elements' values in columns.
4- info: Support function. Displays information on the structure
of the specified Vektis declaration format. Useful for looking up
line element ID's.
5- help: Provides information on how to use Vektor.

All command line options have a short version (e.g. -r:"0210=Johnson")
and a long version (e.g. --element "0210=Johnson") which is more descriptive.
Note that the short command line options are specified with a colon (:)
between the option character and the value and no space between them.
When you need to supply a value that contains a space or other
character that has special meaning in the command shell then you 
should put the value between quotes (see example 3).

The 'copy' command
Used for creating a copy of a given file, where specified line element
replacements are applied to the copy.
	vektor copy <original> <copy> [<options>]
The copy command needs to be supplied the path to the original 
declaration file, the path to the new file (the copy) and 
some options. Additionally a replacement parameter (-r), a 
replacement condition parameter (-c) and a selection 
parameter (-s) are supported.
The replacements parameter specifies which replacements to carry
out on the copy. The condition parameter specifies a condition
that must be met for the replacements to be applied. This allows
you to control which lines will be affected. The condition 
parameter only makes sense if a replacement parameter is also
specified.
The selection parameter allows you to copy only part of the 
original file (effectively extracting a part of the original file).
It can be used as the only parameter to the copy command if
only extraction is desired. All parameters can be combined,
e.g. if you want to perform replacements and selection in one go.
Both the replacement condition and the selection parameter specify
criteria that are applied for each line in the file. Criteria
are specified using a special syntax (see section Criteria).

Example:
Given a declaration file 'original.asc', to create a copy 'copy.asc' 
with all BSN values in the 02 lines by the value "999999999":
	vektor copy original.asc copy.asc -r:0403=999999999

The above example specifies 'original.asc' as input file,
'copy.asc' as output file, '04' as line id and one line element,
'03', to be given the value '999999999'.

To specifies multiple line elements you separate them by a comma:
	 -r:"0203=999999999,0210=Johnson" 
specifies a BSN and a last name for the 02 record.

To specify an empty value you pass only the name to the '-r' parameter.
Example 2:
To replace the BSN in the operation line and also set last name to
empty you just add another element specification:
	vektor copy original.asc copy.asc  -r:"0203=999999999,0210"

You can use specific symbols to specify a randomly generated value:
'@name': denotes a randomly generated name
'@date:fromdate-todate': denotes a randomly generated date. Here you
should specify values for 'fromdate' and 'todate' to indicate the desired
range for the generated date values. Date values should be specified in
standard Vektis format: 'yyyymmdd'.
Example:
To anonymize the last name and birth date fields of the 02 record:
	vektor copy original.asc copy.asc -r:"0210=@name,0207=@date:19000101-20100101"

Example:
To clear the value of the BSN and 'last name' field of the 02 record:
	vektor copy original.asc copy.asc -r:0203,0210
This will pad the BSN line element with "0"'s and the last name line
element with spaces, which are the Vektis symbolic values for 'empty value'

Criteria
Criteria specify conditions that must apply for a given action to be
taken by vektor. The copy command takes two optional parameter of the
criteria type: the replacement condition and the selection parameter.
Semantically criteria take the form of predicates about line element
values, which can be any of the following:
- The value of the specified line element is equal to a given reference value.
- The line element value is not equal to the reference value.
- The line element value is smaller than the reference value.
- The line element value is greater than the reference value.
Syntactically a predicate consists of a line element id, a comparator 
and a reference value. The comparators used are those common in programming:
'a=b': a is equal to b
'a!=b': a is not equal to b
'a<b': a is smaller than b
'a>b': a is greater than b
Criteria may consist of multiple predicates, combined by either
the OR operator '|' or the AND operator '&'.
Example:



Multiple predicates can be combined to one criteria using an 'and'
or an 'or' construction.

Example:
To display values of specific elements of specific line types:
	vektor show original.asc -e:0203,0210
This will print a two column table with the values for BSN and last name
of the 02 records in the file.