import csv
import json
import sys
import os
import tkinter as tk
from tkinter import filedialog
from pathlib import Path

def main():
    
    # Define the paths for your CSV and JSON files
    root = tk.Tk()
    root.withdraw()
    csv_file = filedialog.askopenfilename(title = "Select file",filetypes = [("csv files","*.csv")],initialdir=os.curdir)
    if(csv_file == ''):
        return

    filename = Path(csv_file).stem
    json_file = Path.joinpath(Path(csv_file).parent, filename + ".json")

    # Read the CSV file and convert it to the desired JSON format
    with open(csv_file, 'r') as csv_input:
        csv_reader = csv.reader(csv_input)
        fiducials = []
        for row in csv_reader:
            if len(row) >= 6:
                reference_uuid = row[0]
                position = [float(row[3]), float(row[4]), float(row[5])]
                json_object = {"reference_uuid": reference_uuid, "position": position}
                fiducials.append(json_object)
                
    # Set JSON object
    json_data = {"_comment": "Globus_" + filename, "reference_uuid": filename + "_NoUsed", "fiducials": fiducials}
                
    # Write the list of JSON objects to a JSON file
    with open(json_file, 'w') as json_output:
        json.dump(json_data, json_output, indent=4)
        
if __name__ == "__main__":
    main()