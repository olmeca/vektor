import tables

let helpSubjects* = {
   "none": """
   Vektor: a tool for analyzing and modifying Vektis EI declaration files.
   (c) 2017 Rudi Angela
   Vektor provides a convenient way to adapt existing Vektis declaration files
   (or rather creating adapted copies thereof).

   Usage: vektor <command> [arguments] [<options>]

   To get more detailed information on the commands and options provided you use
   the 'help' command. For instance:
      vektor help copy
   will display information on the 'copy' command.
   Help topics available:
      copy     The main command, creates adapted copy of a given declaration.
      show     Support command, selectively displays content of a declaration.
      info     Support command, displays structural information of a declaration format.
      options  List of options that govern the behavior of the commands
      symbols  List of symbols that can be used as replacement values when using the
               copy command. Symbols denote random values.
   """, 
   "copy": """
   copy <original file name> <copy file name> -r:<replacement values>
            Makes a copy of the original file and replaces element values in the copy,
            as specified in the replacement list. Items in this list take the form
            '<line element id>=<new value>' and are separated by commas.
            E.g. copy mz301.asc new.asc -r:0203=999999999,0403=999999999
            This will replace the BSN element values by 999999999 in all patient
            records (02) and all operation records (04). Replacement by random values
            is also supported, using so called symbols (see help on symbols).
            
   copy <original file name> <copy file name> -r:<replacement values> -c:<condition>
            The additional '-c' option specifies a condition that must be met for the
            target line to be modified. 
            E.g. copy original.asc copy.asc -r:0413=C14 -c:0413=C11
            This will only change the operation lines that have operation code 'C11'
            and set this value to 'C14'. See help on options for more details.
   """, 
   "info": """
   info     Displays the list of supported Vektis declaration formats.
            E.g. vektis info 
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
            E.g. vektis info MZ301 1.3 -l:02
   """,
   "show": """
   show <file path> -e:<element list> (or: --elements <element list>)
            Displays a table with a column for each element in the given element list.
            The element column displays the value of the element per line.
            The element list is a list of line element ID's, separated by a ','.
            Example: vektor show mz301.asc -e:0403,0408,0413
            This will display of every operation line (04) the BSN, date and operation code.
   show <file path> -e:<element list> -c:<condition>
            The additional '-c' option specifies a condition that must be met for the
            target line to be displayed. 
            Example: vektor copy mz301.asc -e:0210,0408,0413 -c:0208=1
            This will display patient's name, operation date and operation code for every
            operation lines of male patients (0208 is the gender field). 
            See help on options for more details.
   """,
   "options": """
   Some Vektor commands take extra options that specify details of the task at hand. A command line
   option consists of a dash, a one character identifier, a colon and a string, without spaces
   between these items. E.g. "-l:02" specifies a line ID of "02". If the value must contain
   spaces or other special characters (like "'", "&" or "|") then the value must be quoted, 
   e.g. "-r:0210='Mac Donalds'".
   
   Options list
   Elements:      -e:<element ID>[,<element ID>]
      e.g.        -e:0210,0408,0413
      This example specifies displaying the patient's last name, the operation date and operation
      code for every operation line in the declaration file.
      
      Commands applicable: show
      Specifies a comma separated list of line element ID's to be displayed.
   Replacement:   -r:<element ID>=<value>[,<element ID>=<value>]
      Commands applicable: copy
      Specifies a comma separated list of replacements to be applied during the copy command.
      A replacement specifies which line elements in the declaration will be replaced and
      which new value to assign to the line element. The value is taken literally unless it 
      starts with a '@'. In that case it is interpreted as a built in symbol. A symbol denotes a
      value that has to be generated ramdomly. E.g. '@name' denotes a random name.
      See help on symbols for a full list of available symbols.
      
   Condition:     -c:"<element ID><comparator><value>[&<element ID><comparator><value>]"
      e.g.        -c:"0207<20100314&0208=1"
      This condition requires the patient to be male and born before 14-03-2010
      
                  -c:"<element ID><comparator><value>[|<element ID><comparator><value>]"
      e.g.        -c:"0207<20100314|0208=1"
      This condition requires the patient to be male or born before 14-03-2010
      
      Commands applicable: copy, show
      Specifies the condition under which the current line will be showed under the show
      command or be modified under the copy command. A condition is either a single predicate
      or a list of predicates joined by either a "&" (meaning And) or a "|" (meaning Or).
      A predicate consists of an element ID, a comparator and a literal value.
      
      The following comparators are supported:
      Equals      :  A=B    A is equal to B
      Unequal     :  A!=B   A is unequal to B
      Greater than:  A>B    A is greater than B
      Less than   :  A<B    A is less than B
      
      Combining & and | in a condition string is currently not supported.
   """,
   "symbols": """
   Symbols can be used in the copy command, in the replacements option.
   That option specifies a list of element value replacements to be applied when
   doing a copy. An element value replacement specifies an element ID and a replacement
   value, e.g. "-r:0210=Johnson" says: replace last name by "Johnson". Instead of a 
   literal replacement value a symbol can be used to denote some random value.
   The following symbols are currently available:
   
   @name                : denotes a random name.
   Example: vektor copy mz301.asc new.asc -r:0210=@name
   This will replace every patient's last name by a random name.
   
   @date:<from>-<to>    : denotes a random date between the <from> and <to> dates. 
   The dates are specified in Vektis format: 'yyyymmdd'.
   Example: vektor copy mz301.asc new.asc -r:0207=@date:01011920-01012010
   This will produce a copy with all patients' birth dates replaced by a
   random date between 1st January 1920 and 1st January 2010.
   """
}.toTable()
