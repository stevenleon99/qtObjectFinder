import csv
import json
import sys
import os
import tkinter as tk
from tkinter import filedialog
from pathlib import Path

def BBorPost_detected(row1):
    if(row1.find("BB") > -1 or row1.find("Origin") > -1):
        return 1
    elif(row1.find("Post") > -1):
        return 2
    else:
        return 0
    
def SphereOrPostRead(spherePointRead, postPointRead):
    return spherePointRead or postPointRead

def isXYZ(row):
    if(row[0].find("X") > -1):
        return 0
                    
    if(row[0].find("Y") > -1):
        return 1
                    
    if(row[0].find("Z") > -1):
        return 2

def main():
    
    # Define the paths for your CSV and JSON files
    root = tk.Tk()
    root.withdraw()
    csv_file = filedialog.askopenfilename(title = "Select file",filetypes = [("csv files","*.csv")],initialdir=os.curdir)
    if(csv_file == ''):
        return

    filename = Path(csv_file).stem
    fiducials_json_file = Path.joinpath(Path(csv_file).parent, filename + "_Fiducials.json")
    drb_json_file = Path.joinpath(Path(csv_file).parent, filename + "_DRB.json")

    # Read the CSV file and convert it to the desired JSON format
    with open(csv_file, 'r') as csv_input:
        csv_reader = csv.reader(csv_input)
        fiducials = []
        markers = []
        X = 0.0
        Y = 0.0
        Z = 0.0
        spherePointRead = False
        postPointRead = False
        for row in csv_reader:
            
            match BBorPost_detected(row[1]):
                case 1:
                    spherePointRead = True
                case 2:
                    postPointRead = True
                
            if(SphereOrPostRead(spherePointRead, postPointRead)):
                match isXYZ(row):
                    case 0:
                        X = float(row[2])
                    case 1:
                        Y = float(row[2])
                    case 2:
                        Z = float(row[2])
                        
                        if(spherePointRead):
                            reference_uuid = "62cee41f-cdae-45c9-821b-61d83f98f937"
                            position = [X, Y, Z]
                            json_object = {"reference_uuid": reference_uuid, "position": position}
                            fiducials.append(json_object)
                            spherePointRead = False
                        elif(postPointRead):
                                normal = [0.0, 0.0, 1.0]
                                position = [X, Y, Z]
                                json_object = {"normal": normal, "position": position}
                                markers.append(json_object)
                                postPointRead = False
                        
                        X = 0.0
                        Y = 0.0
                        Z = 0.0
                
    # Write Fiducials JSON objects
    json_data = {"_comment": "Globus_" + filename, "reference_uuid": filename + "_NoUsed", 
                 "minRadius": 5.0, "maxRadius": 25.0, "fiducials": fiducials}
    with open(fiducials_json_file, 'w') as json_output:
        json.dump(json_data, json_output, indent=4)
        
    # Write DRB JSON objects
    json_data = {"instrument_name": "Calibration Fixture", "instrument_uuid": "e6d6d324-1d7c-4f3b-a3a7-77dba6223f70", 
                 "border_angle": 0.0, "border_inner_height": 0.0, "border_width": 0.0, "diameter": 0.0, "fiducial_type": 1, "markers": markers}
    with open(drb_json_file, 'w') as json_output:
        json.dump(json_data, json_output, indent=4)
        
if __name__ == "__main__":
    main()