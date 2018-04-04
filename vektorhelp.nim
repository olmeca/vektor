import tables

let helpSubjects* = {
   "none": """
   Vektor: a tool for analyzing and modifying Vektis EI declaration files.
   (c) 2017 Rudi Angela
   Vektor provides a controlled and repeatable way to adapt existing Vektis 
   formatted declaration files (or rather creating adapted copies thereof).

   Usage: vektor <command> [arguments] [<options>]

   To get more detailed information on the commands and options provided you use
   the 'help' command. For instance:
      vektor help copy
   will display information on the 'copy' command.
   
   Help topics available:
   copy       The main command, creates adapted copy of a given declaration.
   validate   Validates a given file against the Vektis format specification.
   show       Support command, selectively displays content of a declaration.
   info       Support command, shows structural information of a Vektis format.
   options    List of options that govern the behavior of the commands
   predicates Explains usage and syntax of predicates
   symbols    List of symbols that can be used as replacement values when 
              using the copy command. Symbols denote random values.
   """, 
   "copy": """
   copy <source file name> <destination file name> [<options>]
      Makes a copy of the source file to the destination file, where the options
      specify modifications and/or filtering of content in the copy operation.
            
   Available options:
   -r:<replacement specification list parameter> 
      replaces element values during the copy operation, as specified in the 
      replacement list. Items in this list take the form
      '<line element id> = < new value>' and are separated by semi-colons.
      Each item in this list is a replacement specification. It specifies the
      line element ID (before the '=') and a replacement value (after the '=').
      E.g. copy mz301.asc new.asc -r:'0203 = 999999999; 0403=999999999'.
      This will replace the BSN element (03) values by 999999999 in all patient
      records (02) and all operation records (04). Note that the whole parameter 
      value is placed within single quotes. There is also no space between 
      the '-r:' and the parameter value. Textual replacement values need to
      be placed within double quotes (e.g. -r:'0210 = "Johnson"' ). 
      Numerical replacement values and date values are specified without quotes
      (e.g. -r:'0207 = 19850304' )
      
   -R:<replacement specification list file>
      Will read the file passed and interpret the contents as a replacement
      specification list as above. This is useful in cases where the set of
      replacements is too cumbersome to type repeatedly on the command line.
      Example: -r:anonymize.txt
         
   -c:<condition>
      The additional '-c' option specifies a condition that must be met for the
      target line to be modified. It is only used in addition to an '-r' parameter
      E.g. copy mz301.asc copy.asc -r:'0413 = "C14" ' -c:'0413 = "C11" '
      This will only change the operation lines that have operation code 'C11'
      and set this value to 'C14'. See help on options for more details.
         
   -s:<selection criteria>
      The '-s' options specifies criteria that will be applied to every line
      to determine if it will be included in the copy. Lines that don't match
      will be skipped. If a line matches, all of its parent lines will also be
      included. Also all of its sublines will be included in the copy.
      E.g. copy mz301.asc copy.asc -s:'0413 = "C11" '
      This will create a copy with only 04 lines that have operation code C11.
      For every matched 04 line the parent 02 line will be included. Also, if
      the 04 line has a 98 line then that comment line will also be included.
      The '-s' parameter can be combined with the '-r' parameter to perform
      replacement and filtering in one go.
      
   -S:<selection criteria file>
      Will read the selection criteria from the specified file. As selection
      criteria may become complex and difficult to type on the command line
      and as once formulated criteria may be valuable for later.
      Example: -S:only-under-18.txt
   """, 
   "info": """
   info     Displays the list of supported Vektis declaration formats.
      E.g. vektis info mz301
   info <format name> 
      Displays the list of versions known for the given format.
      E.g. vektis info MZ301
      
   info <format name> <format version>
      Displays summary information for the given format & version.
      Mainly displays the list of line types of the format.
      The version is specified as version and subversion,
      separated by a '.'
      Example: vektis info MZ301 1.3
      
   info <format name> <format version> -l:<line id>
      Displays the list of line element types for the given line type.
      For each element type the start position, length and type are displayed.
      The line type is specified with option '-l:', followed by the line ID.
      Example vektis info MZ301 1.3 -l:02
   """,
   "show": """
   show <file path> -e:<element list> (or: --elements <element list>)
      Displays a table with a column for each element in the given element list.
      The element column displays the value of the element per line.
      The element list is a list of line element ID's, separated by a ';'.
      Example: vektor show mz301.asc -e:'0403; 0408;0413'
      This will display of every operation line (04) the BSN, date and operation code.
      
   show <file path> -e:<element list> -s:<selection criteria>
      The additional '-s' option specifies a criteria that must be met for the
      target line to be displayed. 
      Example: vektor copy mz301.asc -e:'0210,0408,0413' -s:'0208 = 1'
      This will display patient's name, operation date and operation code for every
      operation lines of male patients (0208 is the gender field). 
      See help on options for more details.
   """,
   "validate": """
   validate <file path>
      Validates the contents of the file passed in as argument. Currently this is
      a very basic validation. All that is checked is if the content of every
      line element conforms to the data type. E.g. if the content of a date
      field is really a date. Presence of required data is currently not yet
      validated.
      The result is a simple 'OK' if there are no errors found in the file.
      Otherwise the result will be one error line per error found.
      If more than 20 errors are found the first 20 will be listed, followed
      by the text 'Too many errors'.
   """,
   "options": """
   Some Vektor commands take extra options that specify details of the task at hand. 
   A command line option consists of a dash, a one character identifier, a colon and 
   a string, without spaces between these items. E.g. "-l:02" specifies a line ID 
   of "02". If the value must contain spaces or other special characters 
   (like "&" or "|") then the value must be single quoted, 
   e.g. -r:'0210= "Mac Donalds"'
   
   Options list
   Those options that specify a list of items, like the elements option, must be 
   enclosed in sinqle quotes and the list items must be separated by semi-colons.
   
   Elements:      -e:'<element ID>[;<element ID>]'
      e.g.        -e:'0210;0408;0413'
      This example specifies displaying the patient's last name, the operation 
      date and operation code for every operation line in the declaration file. 
      The elements list must be enclosed by single quotes.
      Commands where applicable: show
      Specifies a comma separated list of line element ID's to be displayed.
      
   Replacement:   -r:'<element ID>=<value>[; <element ID>=<value>]'
      e.g.        -r:'0203=999999999; 0210 = "Johnson"'
      Specifies a list of replacements to be applied during the copy command.
      A replacement specifies which line elements in the declaration will be replaced 
      and which new value to assign to the line element. A literal value can be
      specified as replacement value (e.g. -r:'0203=999999999; 0210="Johnson"'),
      but some special symbols can be specified, that indicate that a random
      value should be generated. For details on using symbols, use 'help symbols'.
      Commands where applicable: copy
      
   Condition:     -c:"<list of conditions for applying replacement>"
      e.g.        -c:"0207 < 20100314 "
      This condition requires the patient to be born before 14-03-2010
      
      Specifies the condition under which the current line will be be modified 
      under the copy command. 
      Conditions are - just like selection criteria (see below) - predicates.
      Predicates can be simple, like in the above example, or complex. The
      section Predicates explains in detail how to specify predicates.
      
      Commands applicable: copy, when also using option '-r'
      A condition is either a single predicate
      or a list of predicates joined by either 
      a "&" (meaning And) or 
      a "|" (meaning Or).
      A predicate consists of an element ID, a comparator and a literal value.
      Textual literal values must be enclosed in double quotes. 
      E.g. -c:'0210 = "Johnson"'
      Numerical values and date values are not enclosed in quotes.
      E.g. -c:'0203 = 999999909'
            
   Selection:     -s:'<selection criteria>'
      e.g.        -s:'0208 = 1'
      This criteria selects only male patients.
      
      Specifies the criteria for filtering declaration lines when using the
      copy or show commands. Only lines that match the criteria will be shown
      or copied. The selection criteria
      Selection criteria are, like conditions, predicates.
      Predicates can be simple, like in the above example, or complex. The
      section Predicates explains in detail how to specify predicates.
      
   """,
   "predicates": """
   Predicates
      A predicate makes a categorical statement about a line, e.g. 
      "The patient's gender is Male and he is born before 1980".
      Such statements are used as conditions for vektor commands.
      For instance the show command will only show lines for which 
      the predicate applies that is passed as option -s (selection).
      The copy command will also only copy lines for which the
      predicate applies that was passed as option -s. The copy
      command also takes an option -c (condition) when using the -r
      (replacement) option. The -c option takes a predicate as value.
      Only lines for which that predicate applies will undergo the
      value replacements specified in option -r.
      A predicate always makes a statement about the value of a
      line element. E.g: 'line element 0208 has value 1'. Only 02
      lines for which element 08 has value 1 meet this predicate.
      A predicate consists of 3 parts: a line element ID,
      a comparator and a reference value. The reference value is
      always a literal value, e.g. 1 (if numerical) or "Johnson"
      (if textual).
   
      The following comparators are supported:
      Equals      :  A = B    A is equal to B
      Unequal     :  A != B   A is unequal to B
      Greater than:  A > B    A is greater than B
      Less than   :  A < B    A is less than B
      
      You can compose predicates using the AND and OR operators and parentheses.
      The AND operator is the '&' and the OR operator is the '|'.
      E.g. the predicate '(0207 < 19080101 & 0208 = 1)' specifies that the
      patient be born before 1980 AND be a male. The parentheses are required
      around a pair of combined predicates. The AND and OR operators are
      binary operators: they always take two predicates. But they can also
      take composite predicates. For example the predicate
      '(0208 = 1 & (0207 > 19200101 & 0207 < 20000101))'
      specifies that the patient be a male born between 1950 and 2000. Here the
      second predicate of the first AND is itself a composite AND predicate.
   """,
   "symbols": """
   Symbols can be used in the copy command, in the replacements option.
   That option specifies a list of element value replacements to be applied when
   doing a copy. An element value replacement specifies an element ID and a replacement
   value, e.g. "-r:0210=Johnson" says: replace last name by "Johnson". Instead of a 
   literal replacement value a symbol can be used to denote some random value.
   The following symbols are currently available:
   
   randomtext   : denotes some random text.
   Example: vektor copy mz301.asc new.asc -r:'0210 = randomtext'
   This will replace the patient's name by gibberish text.
   
   randomtext(min, max)    : denotes random text with length within a range
   E.g.: vektor copy mz301.asc new.asc -r:' 0210 = randomtext(5, 10)'
   This will replace the patient's name by gibberish text with a length
   between 5 and 10 characters.
   
   RANDOMTEXT:    : like randomtext, produces text in capital letters
   RANDOMTEXT(min, max): like randomtext(min, max), result all capitals
   
   randomdate(<from>, <to>) : denotes a random date between the <from> and <to> dates. 
   The dates are specified in Vektis format: 'yyyymmdd'.
   Example: vektor copy mz301.asc new.asc -r:'0207 = randomdate(01011920, 01012010)'
   This will produce a copy with all patients' birth dates replaced by a
   random date between 1st January 1920 and 1st January 2010.
   """
}.toTable()
