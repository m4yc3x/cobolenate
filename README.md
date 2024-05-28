# Cobolenate

Cobolenate is a COBOL program designed to convert CSV files into various data formats such as vCard, JSON, XML, SQL, and Excel. This tool is particularly useful for data migration and integration tasks.

## Features

- **CSV to vCard**: Convert CSV data to vCard format for contact management.
- **CSV to JSON**: Convert CSV data to JSON format for web applications and APIs.
- **CSV to XML**: Convert CSV data to XML format for data interchange.
- **CSV to SQL**: Convert CSV data to SQL insert statements for database operations.
- **CSV to Excel**: Convert CSV data to a format compatible with Excel.

## Usage

1. **Compile the COBOL Program**:
   Ensure you have a COBOL compiler installed. Compile the program using:

```sh
cobc -x -o cobolenate cobolenate.cob
```

2. **Run the Program**:
   Execute the compiled program:

```sh
./cobolenate
```

3. **Follow the Prompts**:
   - The program will prompt you to select the output data type.
   - It will then read the CSV file (`input.csv`) and ask for custom headers if necessary.
   - The converted data will be saved to `output.dat`.

## File Structure

- **cobolenate.cob**: The main COBOL source file containing the program logic.
- **input.csv**: The input CSV file to be converted.
- **output.dat**: The output file where the converted data will be saved.

## Example

Given an `input.csv` file with the following content:

```
name,phone,address
John Doe,1234567890,123 Elm St
Jane Smith,0987654321,456 Oak St
```

Running the program and selecting `1` for vCard will produce an `output.dat` file with:

```
BEGIN:VCARD
VERSION:3.0
FN:John Doe
TEL:1234567890
ADR:123 Elm St
END:VCARD
BEGIN:VCARD
VERSION:3.0
FN:Jane Smith
TEL:0987654321
ADR:456 Oak St
END:VCARD
```

## Custom Headers

If the CSV headers do not match the expected headers for the selected format, the program will prompt you to enter the appropriate headers.

## Contributing

Feel free to fork this repository and submit pull requests. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License.

## Author

Created by [github.com/m4yc3x](https://github.com/m4yc3x).

## Acknowledgments

Special thanks to the COBOL community for their support and abundant resources.

