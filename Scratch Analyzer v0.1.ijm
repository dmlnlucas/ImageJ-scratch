// Ask for input & output folders
inputDir = getDirectory("Choose Input Folder");
outputDir = getDirectory("Choose Results Output Folder");

// Create dialog for user parameters
Dialog.create("Batch analysis parameters")
Dialog.addNumber("Lower Threshold, based on calibration", 0);
Dialog.addNumber("Upper Threshold, based on calibration", 6);
Dialog.addNumber("Min. Particle Size (px^2)", 50000);
Dialog.addNumber("Max. Particle Size (px^2), Infinity for no limit", 1e12);
Dialog.show();

// Get dialog values
lowThr = Dialog.getNumber();
highThr = Dialog.getNumber();
minSize = Dialog.getNumber();
maxSize = Dialog.getNumber();

// File loop
run("Clear Results");
fileList = getFileList(inputDir);
nimages = lengthOf(fileList);

setBatchMode(true);
// A failsafe is added that checks whether the file is an image before opening
for (i = 0; i < nimages; i++) {
    fileName = fileList[i];
    if (endsWith(fileName, ".tif") || endsWith(fileName, ".jpg") || endsWith(fileName, ".png")) {
        fullPath = inputDir + fileName;
        open(fullPath);
        // Image processing
        run("Find Edges");
        setThreshold(lowThr, highThr);
        run("Convert to Mask");
        run("Analyze Particles...", "size="+minSize+"-"+maxSize+" display add");
        close();
    }
}

// Save results once, after the loop finishes
savePath = outputDir + "results.csv";
saveAs("Results", savePath);
print("Results saved to: " + savePath);
