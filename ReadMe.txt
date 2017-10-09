Vektor Tool Readme

Short version:
To anonymize the 02 line of a declaration file:
	vektor copy original.asc -o:copy.asc -l:02 -e:"03=999999999,10=@name,07=@date:19000101-20100101"
This will create a copy 'copy.asc' based on 'original.asc', where all '02' line will have:
- '999999999' as value for the 03 element (BSN),
- a random name for element '10' (last name)
- a random date between 01-01-1900 and 01-01-2010 for element '07' (birth date)

The Vektor tool is a command line tool developed to assist in the
process of analysis and modification of existing Vektis EI compliant 
declaration files. Currently its main function is modification,
but there is also a working print function and other analysis
and generation functions are in the works.
The modification function provides a generic way of 
bulk modifying the value of any line element. You provide it a line and
element ID(e.g. "-l:02" "-e:03" for BSN) and a value (e.g. "999999999") 
and it will replace all the values for the BSN element of the 
02 record by the specified replacement value.

Vektor does not perform the modifications 'in place' in the input file
supplied. Instead it creates a copy (output file) with the same 
content of the original input file, but with the specified element
values replaced.

Vektis uses the value types specified in the Vektis EI standards. 
In short, it knows to check for numerical values where required 
and it will pad values to preserve field length.

When calling Vektor from the command line you need to specify the
following command line arguments:
- the function to perform
- the path to the input file (as last command line argument)
- the path of an output file to be created (as command line option -o)
- the line type to modify (line ID of the record, e.g. '02')
- the elements to modify and their new values (as option -e)
If the new value should be the empty value then you don't specify
any value.

Like every command line tool, you can refer to Vektor just by its
name 'vektor' if it can be found on your PATH environment variable.
Otherwise you will have to supply the full path to the executable
to use it. The following examples assume vektor.exe can be found
via your PATH settings.

Example 1:
Given a declaration file 'original.asc', to create a copy 'copy.asc' 
with all BSN values in the 02 lines by the value "999999999":
	vektor copy original.asc -o:copy.asc -l:04 -e:03=999999999

The above example specifies 'original.asc' as input file,
'copy.asc' as output file, '04' as line id and one line element,
'03', to be given the value '999999999'.

All command line options have a short version (e.g. -e:"10=Johnson")
and a long version (e.g. --element "10=Johnson") which is more descriptive.
Note that the short command line options are specified with a colon (:)
between the option character and the value and no space between them.
When you need to supply a value that contains a space or other
character that has special meaning in the command shell then you 
should put the value between quotes (see example 3).

To specifies multiple line elements you separate them by a comma:
	-l:02 -e:"03=999999999,10=Johnson" 
specifies a BSN and a last name for the 02 record.

To specify an empty value you pass only the name to the '-e' parameter.
Example 2:
To replace the BSN in the operation line and also set last name to
empty you just add another element specification:
	vektor modify -o:copy.asc -l:04 -e:"03=999999999,10" original.asc

You can use specific symbols to specify a randomly generated value:
'@name': denotes a randomly generated name
'@date:fromdate-todate': denotes a randomly generated date. Here you
should specify values for 'fromdate' and 'todate' to indicate the desired
range for the generated date values. Date values should be specified in
standard Vektis format: 'yyyymmdd'.
Example 3:
To anonymize the last name and birth date fields of the 02 record:
	vektor modify original.asc -o:copy.asc -l:02 -e:"10=@name,07=@date:19000101-20100101"

Example 4:
To clear the value of the BSN and 'last name' field of the 02 record:
	vektor modify original.asc -o:copy.asc -l:02 -e:03,10
This will pad the BSN line element with "0"'s and the last name line
element with spaces, which are the Vektis symbolic values for 'empty value'

Example 5:
To display values of specific elements of specific line types:
	vektor show original.asc -o:copy.asc -l:02 -e:03,10
This will print a two column table with the values for BSN and last name
of the 02 records in the file.