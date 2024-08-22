// This Macro is written in 20 August 2024.
// By Leila Nahidiazar 
// To measure invagination of LaminB1

// Initialize
var i = 0;
saveSettings();
run("Close All");
run("Clear Results");
roiManager("reset"); 

// Close ROI Manager if open
if (isOpen("ROI Manager")) {
    selectWindow("ROI Manager");
    run("Close");
}

// Ask user to open a file
path = File.openDialog("Select a file...");
open(path);
run("16-bit");
rename("original");

// Let the user select a region to analyze
selectWindow("original");
setTool("polygon");
waitForUser("Draw a line on lamin and click OK to continue");   

// Check if the user pressed "Cancel"
if (selectionType() == -1) {
    exit("No selection made. Exiting."); // Exit the macro if "Cancel" was pressed
}

// Check if the user made a valid selection
if (selectionType() >= 0 && selectionType() <= 3) {
    run("Duplicate...", " ");
    roiManager("Add");  // Add the selected region to the ROI Manager
    //rename("selected_area");
}

setAutoThreshold("Otsu dark");
run("Convert to Mask");
run("Median...", "radius=2");
roiManager("Select", 0);
run("Set Measurements...", "area area_fraction decimal=1");
roiManager("Select", 0);
run("Measure");

// Get area_fraction from the Results table
area_fraction = getResult("Area Fraction", nResults-1);

// Check the area_fraction and print the result
if (area_fraction >= 5) {
    print(area_fraction + "% is covered with lamin - positive invagination");        
}

// Save the results as a CSV file
selectWindow("Results");  // Activate the results table
saveAs("Results", path + ".csv");