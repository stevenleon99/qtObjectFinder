# QML Search Skill Resources

This directory provides reference materials to support effective searching and understanding of QML files.

## Contents

- **search-examples.md**  
	Provides practical examples of search queries in JSON format and their expected results. Demonstrates how to structure requests and interpret responses for common QML search scenarios

- **dvp-protocols.md**  
	Reference for Data-View-Protocol (DVP) usage in QML:
	- Protocol types (User, Patient, Case, System, etc.)
	- Common usage patterns
	- How to recognize protocol usage in QML files

- **query-reply-format.md**  
	Defines the standard JSON structure for search queries and replies, including required fields and example formats for both requests and responses.

- **qml-file-structure.md**  
    Outlines the typical structure of QML files, including common directories and file organization patterns to help users navigate QML codebases effectively.

## Usage Instructions

1. Upload a query in JSON format
2. QML Search Skill processes the query against the files under QML/ directory, referencing `dvp-protocols.md` and `qml-file-structure.md`.
3. Ask questions in natural language.
4. Reply will be in JSON format as defined in `query-reply-format.md`.


## Tips

- Be specific in your queries.
- Mention file names for targeted searches.
- Ask follow-up questions for more detail.

## Limitations

- Only analyzes uploaded QML files under QML/ directory.
- Requires valid QML syntax.
- Cannot execute or validate QML code.
- Does not analyze C++ implementation files.
